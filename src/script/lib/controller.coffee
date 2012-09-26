# A controller instance connects many emitters and provides an api to control the
# whole application. It's an umbrealla for:
# 0. a `State` emitter
# 1. a `Sync` instance
# 2. a `Hash` instance
# 2. any number of `Controls` instances

define ['lib/state', 'lib/sync', 'lib/hash', 'lib/controls'], (State, Sync, Hash, Controls) ->

  return class Controller

    # Create state object using `defaults`, create and connect emitters
    constructor: (defaults, initialTriggers) ->
      # Create emitters
      @hash = new Hash()
      @sync = new Sync()
      @controls = new Controls()
      # Create state
      initialState = @bootstrapState(defaults)
      initialState.numSlides = defaults.numSlides
      @state = new State(initialState)
      # Connect emitters
      @connectHash @hash
      @connectSync @sync
      @connectControls(@controls)

    #
    bootstrapState: (defaults) ->
      fromUrl = @hash.parse(window.location.hash) || {}
      fromSync = @sync.getState() || {}
      return {
        file: fromUrl.file || fromSync.file || defaults.file
        slide: fromUrl.slide || fromSync.slide || defaults.slide
        hidden: fromUrl.hidden || fromSync.hidden || defaults.hidden
      }

    #
    initialUpdate: (file, slide, hidden) ->
      file = @state.get('file')
      slide = @state.get('slide')
      hidden = @state.get('hidden')
      @hash.set(file, slide, hidden)
      @sync.setState { file, slide, hidden }


    # Connect Emitters
    # ----------------
    # 0. Emitter lauschen auf dem Manager
    # 1. Emitter lösen state.update aus
    # 2. state.update löst ggf. (falls es wirklich ein Update war) auf dem Manager aus
    # Explizite Objekt-Übergabe erleichtet später das Verbinden weiterer Emitter (z.B. für Controls aus dem Frame)

    # 0. Listen for hash changes and update the state accordingly
    # 1. When an event fires on the state, update the hash using `stateCb`
    connectHash: (emitter) ->
      # Listen on the hash emitter
      emitter.on 'change', (data) =>
        @state.set data, emitter
      # Listen on the state emitter
      onstatechange = (key, value) =>
        emitter.update key, value, { # `update` sollte `setState` heißen, wie bei Sync
          file: @state.get('file')
          slide: @state.get('slide')
          hidden: @state.get('hidden')
        }
      @state.on 'file', emitter, onstatechange.bind(this, 'file')
      @state.on 'slide', emitter, onstatechange.bind(this, 'slide')
      @state.on 'hidden', emitter, onstatechange.bind(this, 'hidden')

    # 0. Listen on the emitter's change event and update the state accordingly
    # 1. When an event fires on the state, update the sync storage using `set()`
    connectSync: (emitter) ->
      # Listen on the sync emitter
      emitter.on 'change', (state) =>
        # **HACK HACK HACK HACK**
        # If we use the value passed to this callback to set the state, the state is
        # changed one value at a time. This would only work for changes that only
        # touch one of the state's properties - if more properties are changed after
        # one another, it gets nasty as soon more than one window is involved. What
        # happens is that when we update the state { a:x, b:1 } to { a:y, b:1 } and
        # then to { a:y, b:2 }, the storage event for { a:y, b:1 } is triggerd on
        # other windows *after* we set { a:y, b:2 } on our window. So the other
        # window triggers an event for { a:y, b:1 }, while we are already on
        # { a:y, b:2 }, so we update and trigger an event, while the other window
        # recieves { a:y, b:2 }... and we've got ourselfes a nice endless loop.
        # This can be "fixed" by not actually setting the state to the value that
        # the Sync callback reports, but to the value that's currently in the sync's
        # storage. This works because storage events always fire only after all
        # changes to the storage are applied, even for multiple changes in sequence.
        # This allows us to fake a bulk update of the state, which fixes the
        # endless loop problem.
        @state.set @sync.getState(), emitter
      # Listen on the state emitter
      onstatechange = (key, value) =>
        emitter.set key, value
      @state.on 'file', emitter, (value) -> onstatechange 'file', value
      @state.on 'slide', emitter, (value) -> onstatechange 'slide', value
      @state.on 'hidden', emitter, (value) -> onstatechange 'hidden', value

    # Connect the contol emitter's events directly to the api methods
    connectControls: (emitter) ->
      emitter.on 'prev', => @goPrev()
      emitter.on 'next', => @goNext()
      emitter.on 'toggleHidden', => @toggleHidden()





    # API
    # ---
    #

    # Expose the state manager's event hooks, but hide the "smart" parts
    # of the SmartEmitter's functionality
    on: (args...) ->
      args.splice 1, 0, null # add `null` as the `subscriber` object
      @state.on args...
    trigger: (args...) ->
      args.splice 1, 0, null # add `null` as the `caller` object
      @state.trigger args...
    off: (args...) ->
      @state.off args...
    offAll: (args...) ->
      @state.offAll args...
      @hash.offAll args...
      @sync.offAll args...
      @controls.offAll args...

    # Get and set the current file
    getFile: ->
      return @state.get 'file'
    openFile: (newFile) ->
      @state.set { file: newFile }

    # Get and navigate the slides
    getSlide: ->
      return @state.get 'slide'
    goTo: (num) ->
      @state.set { slide: Number num }
    goNext: ->
      @goTo(@getSlide() + 1)
    goPrev: ->
      @goTo(@getSlide() - 1)

    # Get, set and toggle the hidden state
    getHidden: ->
      return @state.get 'hidden'
    setHidden: (state) ->
      @state.set { hidden: state }
    toggleHidden: ->
      @setHidden !@getHidden()