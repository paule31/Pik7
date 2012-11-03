# A simple emitter with an internal state and `get()` and `set()`

define ['lib/emitter'], (Emitter) ->
  return class StatefulEmitter extends Emitter


    # Create an emitter and an interal state from the state object
    constructor: (stateObj, @storageKey) ->
      state = @readStorage() || stateObj
      if not state?
        throw new Error "Failed to create state, no stored state and no default state found"
      topics = Object.keys(state)
      super(topics...)
      @createState(state)
      @writeStorage()
      @watchStorage()


    # Read write and watch state to local storage
    readStorage: ->
      return JSON.parse(window.localStorage.getItem(@storageKey)) if @storageKey?
    writeStorage: ->
      window.localStorage.setItem(@storageKey, JSON.stringify(@state)) if @storageKey?
    watchStorage: ->
      if @storageKey?
        watchFn = (evt) =>
          if evt.storageArea == window.localStorage && evt.key == @storageKey
            @compareWithStorage()
        window.addEventListener('storage', watchFn, false)


    # Compare current state with local storage and trigger state changes when changes are
    # detected
    compareWithStorage: () ->
      otherState = @readStorage()
      for own key of @state
        if @state[key] != otherState[key]
          if !@state[key]? || !otherState[key]?
            throw new Error "Incompatible states detected (key '#{key}' not found)"
          else
            @trigger(key, otherState[key])


    # Create the state object and attach events that set values when called
    createState: (stateObj) ->
      @state = {}
      for own key, val of stateObj
        @state[key] = val
        do (key) =>
          @on key, (val) =>
            @state[key] = val
            @writeStorage()


    # Overload trigger to require exactly 2 arguments
    trigger: (key, val, rest...) ->
      if not val?
        throw new Error "StatefulEmitter requires a value for triggers, got #{typeof val}"
      if rest.length > 0
        throw new Error "StatefulEmitter can only pass one value, got #{rest.length + 1}"
      super(key, val)


    set: (key, val) -> @trigger(key, val)
    get: (key) -> return @state[key]
