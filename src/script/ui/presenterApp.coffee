# UI code for the presenter view
define ['jquery'], -> (app) ->

  app.on 'load', ->
    frame = $('#PikFrame')
    frameWindow = frame[0].contentWindow

    # Change the page title when a new presentation loads
    presentationTitle = frameWindow.$('title').text()
    $('title').text(presentationTitle)

    # Update slide counter
    $('#PikSlideCount').text(frameWindow.Pik.numSlides)
    app.controller.on 'slide', (num) ->
      console.log arguments
      $('#PikSlideCurrent').text(num)