# A controller instance connects many emitters and provides an api to control the
# whole application. It's an umbrealla for:

# 1. a `State` emitter
# 2. a `Sync` instance
# 3. a `Hash` instance
# 4. any number of `Controls` instances


define ['lib/state', 'lib/sync', 'lib/hash', 'lib/controls'], (State, Sync, Hash, Controls) ->
  return class Controller

    constructor: (defaults) ->
      @createEmitters(defaults)
      @initialUpdate()

    # Create the four emitters (the state object with a starting state derived from the
    # defaults, the url and local storage), then connect emitters
    createEmitters: (defaults) ->
      [ @hash, @sync, @controls ] = [ new Hash(), new Sync(), new Controls() ]
      @state = new State do =>
        fromUrl = @hash.parse(window.location.hash) || {}
        fromSync = @sync.getState() || {}
        return {
          file: fromUrl.file || fromSync.file || defaults.file
          slide: fromUrl.slide || fromSync.slide || defaults.slide
          hidden: fromUrl.hidden || fromSync.hidden || defaults.hidden
          numSlides: defaults.numSlides
        }
      @connectHash(@hash)
      @connectSync(@sync)
      @connectControls(@controls)

    # After a state has been established, update Hash and Sync once
    initialUpdate: ->
      file = @state.get('file')
      slide = @state.get('slide')
      hidden = @state.get('hidden')
      @hash.set(file, slide, hidden)
      @sync.setState({ file, slide, hidden })


    # Connect Emitters
    # ----------------
    # 1. Emitters listen for events on the controller
    # 2. Emitters trigger `@state.update()`
    # 3. `@state.update()` triggers the controller, if the update did really set new values
    # Passing emitters as arguments simplifies connecting emitters from elsewhere (eg.
    # the frames' controls instances)

    # 1. Listen for hash changes and update the state accordingly
    # 2. When an event fires on the state, update the hash using `stateCb`
    connectHash: (emitter) ->
      emitter.on 'change', (data) =>
        @state.set(data, emitter)

      # Listen on the state emitter
      onstatechange = (key, value) =>
        emitter.update(key, value, { # `update` should better be called `setState`, like in Sync
          file: @state.get('file')
          slide: @state.get('slide')
          hidden: @state.get('hidden')
        })
      @state.on 'file', emitter, onstatechange.bind(this, 'file')
      @state.on 'slide', emitter, onstatechange.bind(this, 'slide')
      @state.on 'hidden', emitter, onstatechange.bind(this, 'hidden')

    # 1. Listen on the emitter's change event and update the state accordingly
    # 2. When an event fires on the state, update the sync storage using `set()`
    connectSync: (emitter) ->
      # Listen on the sync emitter
      emitter.on 'change', (state) =>
        # **HACK HACK HACK HACK**
        # If we use the value passed to this callback to set the state, the state is
        # changed one value at a time. This would only work for changes that only
        # touch one of the state's properties - if more properties are changed after
        # one another, it gets nasty as soon more than one window is involved. What
        # happens is that when we update the state `{ a:x, b:1 }` to `{ a:y, b:1 }` and
        # then to `{ a:y, b:2 }`, the storage event for `{ a:y, b:1 }` is triggered on
        # other windows *after* we set `{ a:y, b:2 }` on our window. So the other
        # window triggers an event for `{ a:y, b:1 }`, while we are already on
        # `{ a:y, b:2 }`, so we update and trigger an event, while the other window
        # recieves `{ a:y, b:2 }` ... and we've got ourselfes a nice endless loop.
        # This can be "fixed" by not actually setting the state to the value that
        # the Sync callback reports, but to the value that's currently in the sync's
        # storage. This works because storage events *always* fire only after all
        # changes to the storage are applied, even for multiple changes in sequence.
        # This allows us to fake a bulk update of the state, which fixes the
        # endless loop problem.
        @state.set(@sync.getState(), emitter)
      # Listen on the state emitter
      onstatechange = (key, value) => emitter.set(key, value)
      @state.on 'file', emitter, (value) -> onstatechange('file', value)
      @state.on 'slide', emitter, (value) -> onstatechange('slide', value)
      @state.on 'hidden', emitter, (value) -> onstatechange('hidden', value)

    # Connect the contol emitter's events directly to the api methods
    connectControls: (emitter) ->
      emitter.on 'prev', => @goPrev()
      emitter.on 'next', => @goNext()
      emitter.on 'toggleHidden', => @toggleHidden()

    # API
    # ---

    # Expose the state manager's event hooks, but hide the "smart" parts
    # of the SmartEmitter's functionality by using `null` for caller/subscriber objects
    on: (args...) ->
      args.splice(1, 0, null) if args.length == 2 # add `null` as the `subscriber` object
      @state.on(args...)
      console.log args
    trigger: (args...) ->
      args.splice(1, 0, null) if args.length == 2 # add `null` as the `caller` object
      @state.trigger(args...)
      console.log args
    off: (args...) ->
      @state.off(args...)
    offAll: (args...) ->
      @state.offAll(args...)
      @hash.offAll(args...)
      @sync.offAll(args...)
      @controls.offAll(args...)

    # Get and set the current file
    getFile: -> @state.get('file')
    openFile: (newFile) -> @state.set { file: newFile }

    # Get and navigate the slides
    getSlide: -> @state.get('slide')
    goTo: (num) -> @state.set { slide: Number num }
    goNext: -> @goTo(@getSlide() + 1)
    goPrev: -> @goTo(@getSlide() - 1)

    # Get, set and toggle the hidden state
    getHidden: -> @state.get('hidden')
    setHidden: (state) -> @state.set { hidden: state }
    toggleHidden: -> @setHidden(!@getHidden())