require ['lib/presentation'], (Presentation) ->
  'use strict'

  test 'Init procedure', ->
    stop()
    presentation = new Presentation ->
      equal window.Pik.__app__.numSlides, $('.pikSlide').length
      start()

  test 'API functions trigger events on presentation object', ->
    stop(2)
    presentation = new Presentation ->
      @on 'slide', (slide) ->
        equal(slide, 1337)
        start()
      @on 'hidden', (state) ->
        equal(state, true)
        start()
      window.Pik.__app__.goTo(1337)
      window.Pik.__app__.setHidden(true)