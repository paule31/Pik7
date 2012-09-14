require ['../lib/frame'], (Frame) -> $(window).ready ->
  'use strict'

  frameEl  = $('#Testframe')
  frameWin = frameEl[0].contentWindow

  test 'Init procedure', ->
    frame = new Frame(frameEl)
    stop()
    frame.on 'load', ->
      equal frame.getNumSlides(), frameWin.$('.pik-slide').length

      test 'Commands', ->
        stop(2)
        frameWin.testPresentation.on 'slide', (num) ->
          equal num, 1337
          start()
        frameWin.testPresentation.on 'hidden', (state) ->
          equal state, false
          start()
        frame.do 'slide', 1337
        frame.do 'hidden', false

      start()


  frameEl.attr 'src', 'frameTest/frameTestFrame.html'