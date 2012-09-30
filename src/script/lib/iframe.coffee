# Controls one frame from the outside

define ['lib/emitter', 'jquery'], (Emitter) ->
  'use strict'

  return class Iframe extends Emitter

    # Store frame and window references, call `super` and kick off the init procedure
    constructor: (frame) ->
      @frame  = $(frame)
      if @frame.length == 0 then throw new Error "Iframe error: frame #{frame} not found"
      @window = @frame[0].contentWindow
      super('load')
      @initFrame()

    # Dispatch load events in the frame to self
    initFrame: ->
      @frame.load =>
        @trigger('load', @window.location.href) if @window.Pik?

    # Trigger `action` with `arg` on the frames `Pik` object
    do: (action, arg) ->
      if action == 'file'
        @window.location.href = arg
      else if @window.Pik?
        if action == 'slide'
          @window.Pik.goTo(arg)
        if action == 'hidden'
          @window.Pik.setHidden(arg)

    getNumSlides: -> @window.Pik.numSlides if @window.Pik?