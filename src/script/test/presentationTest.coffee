require ['lib/presentation'], (Presentation) -> $(window).ready ->
  'use strict'

  test 'Init procedure', ->
    stop()
    presentation = new Presentation ->
      equal window.Pik.numSlides, $('.pikSlide').length
      start()

  test 'API functions trigger events on presentation object', ->
    stop 2
    presentation = new Presentation ->
      @on 'slide', (slide) ->
        equal slide, 1337
        start()
      @on 'hidden', (state) ->
        equal state, 'something'
        start()
      window.Pik.goTo 1337
      window.Pik.setHidden 'something'