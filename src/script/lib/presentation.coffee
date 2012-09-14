# Center of command for a presentation. Implements the global (for the frame) API that
# is used to recieve commands from the outside and to relay control commands.

define ['lib/emitter', 'lib/controls', 'jquery'], (Emitter, Controls) ->
  'use strict'

  # By default, the initCallback does nothing but set the number of slides (usually using
  # the html class `.pik-slide`) found in the presentation
  defaultInitCb = ->
    @numSlides = $('.pik-slide').length

  return class Presentation extends Emitter

    constructor: (initCb = defaultInitCb) ->
      super 'slide', 'hidden'
      initCb.call this
      @createApi()

    createApi: ->
      self = this
      window.Pik = {
        numSlides: self.numSlides
        controls: new Controls()
        goTo: (slide) -> self.trigger 'slide', slide
        setHidden: (state) -> self.trigger 'hidden', state
      }