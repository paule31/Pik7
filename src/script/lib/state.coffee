# Creates a state object that's representing (wait for it...) the presentation's state!

define ['../lib/smartEmitter'], (SmartEmitter) ->

  return class State extends SmartEmitter

    # `defaults` is a state object that must also contain the `numSlides` a property for
    # obvious reasons.
    constructor: (defaults) ->
      super 'file', 'slide', 'hidden'
      required = ['file', 'slide', 'hidden', 'numSlides']
      throw new Error "Missing #{val} value in state defaults" for idx, val of required when val not of defaults
      @addState defaults

    # Setup state events, pre-fill the state with the supplied defaults
    addState: (defaults) ->
      that = this
      @state = {
        current: {
          file: defaults.file
          slide: defaults.slide
          hidden: defaults.hidden
          numSlides: defaults.numSlides
        }
        update: (data, caller) ->
          for key, value of data
            if value != @current[key]
              # Special treatment for the slide number to keep it from going below 0
              # or above `numSlides` (it's still possible to call `@state.set` with such
              # slide numbers, but the new value won't be used)
              if key == 'slide'
                if value < 0 then value = 0
                if value >= @current.numSlides then value = @current.numSlides - 1
              @current[key] = value
              that.trigger key, caller, value
      }

    set: (data, caller) ->
      if 'numSlides' of data then throw new Error "Can't modify numSlides after init"
      @state.update data, caller

    get: (key) -> return @state.current[key]