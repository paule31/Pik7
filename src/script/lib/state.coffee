#

define ['../lib/smartEmitter'], (SmartEmitter) ->

  return class State extends SmartEmitter

    #
    constructor: (defaults) ->
      super 'file', 'slide', 'hidden'
      required = ['file', 'slide', 'hidden', 'numSlides']
      throw new Error "Missing #{val} value in state defaults" for idx, val of required when val not of defaults
      @addState defaults

    #
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
              # Special treatment for the slide number
              if key == 'slide'
                if value < 0 then value = 0
                if value >= @current.numSlides then value = @current.numSlides - 1
              @current[key] = value
              that.trigger key, caller, value
      }

    #
    set: (data, caller) ->
      if 'numSlides' of data
        throw new Error "Can't modify numSlides after init"
      @state.update data, caller

    #
    get: (key) ->
      return @state.current[key]