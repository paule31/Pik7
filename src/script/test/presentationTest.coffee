require ['../lib/presentation'], (Presentation) -> $(window).ready ->
  'use strict'

  test 'Default init procedure', ->
    presentation = new Presentation()
    equal window.Pik.numSlides, $('.pik-slide').length

  test 'Custom init callback', ->
    presentation = new Presentation ->
      @numSlides = 42
    equal window.Pik.numSlides, 42

  test 'API functions trigger events on presentation object', ->
    presentation = new Presentation()
    stop 2
    presentation.on 'slide', (slide) ->
      equal slide, 1337
      start()
    presentation.on 'hidden', (state) ->
      equal state, 'something'
      start()
    window.Pik.goTo 1337
    window.Pik.setHidden 'something'