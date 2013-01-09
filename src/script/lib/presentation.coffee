# Center of command for a presentation. Implements the global (for the frame) API that
# is used to recieve commands from the outside and to relay control commands.
define ['lib/emitter', 'lib/controls', 'jquery'], (Emitter, Controls) ->
  return class Presentation extends Emitter


    constructor: (initCb) ->
      super('slide', 'hidden')
      $(window).ready =>
        @numSlides = $('.pikSlide').length
        @createApi()
        initCb.call(this) if initCb?


    createApi: ->
      self = this
      window.Pik = {
        slides: $('.pikSlide')
        numSlides: self.numSlides
        controls: new Controls()
        goTo: (slide) -> self.trigger('slide', slide)
        setHidden: (state) -> self.trigger('hidden', state)
        inPrint: window.location.hash == '#print'
      }