# Controls one frame from the outside

define ['lib/emitter', 'jquery'], (Emitter) ->
  'use strict'

  return class Frame extends Emitter

    # Store frame and window references, call `super` and kick off the init procedure
    constructor: (frame) ->
      if frames.length == 0 then throw new Error 'No frames defined'
      @frame  = $(frame)
      @window = @frame[0].contentWindow
      super 'load'
      @initFrame()

    # Dispatch load events in the frame to self
    initFrame: () ->
      @frame.load =>
        @trigger 'load', @window.location.href if @window.Pik?

    # Trigger `action` with `arg` on the frames `Pik` object
    do: (action, arg) ->
      if action == 'file'
        @window.location.href = arg
      else if @window.Pik?
        if action == 'slide'
          @window.Pik.goTo arg
        if action == 'hidden'
          @window.Pik.setHidden arg

    getNumSlides: -> return @window.Pik.numSlides if @window.Pik?