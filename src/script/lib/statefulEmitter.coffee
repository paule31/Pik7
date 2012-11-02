# A simple emitter with an internal state and `get()` and `set()`

define ['lib/emitter'], (Emitter) ->
  return class StatefulEmitter extends Emitter


    # Create an emitter and an interal state from the state object
    constructor: (stateObj) ->
      if typeof stateObj != 'object'
        throw new Error "StatefulEmitter requires an object to create, got #{typeof stateObj}"
      topics = Object.keys(stateObj)
      super(topics...)
      @createState(stateObj)


    # Create the state object and attach events that set values when called
    createState: (stateObj) ->
      @state = {}
      for own key, val of stateObj
        @state[key] = val
        do (key) =>
          @on key, (val) =>
            @state[key] = val


    # Overload trigger to require exactly 2 arguments
    trigger: (key, val, rest...) ->
      if not val?
        throw new Error "StatefulEmitter requires a value for triggers, got #{typeof val}"
      if rest.length > 0
        throw new Error "StatefulEmitter can only pass one value, got #{rest.length + 1}"
      super(key, val)


    set: (key, val) -> @trigger(key, val)
    get: (key) -> return @state[key]
