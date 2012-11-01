# UI code for the presenter view
define ['jquery'], -> (app) ->

  app.on 'load', ->
    frame = $('#PikFrame')[0].contentWindow
    pik = frame.Pik


    # Change the page title when a new presentation loads
    presentationTitle = frame.$('title').text()
    $('title').text(presentationTitle)


    # Update slide counter
    $('#PikSlideCount').text(frame.Pik.numSlides)
    $('#PikSlideCurrent').text(app.controller.getSlide() + 1)
    app.controller.on 'slide', (num) ->
      console.log arguments
      $('#PikSlideCurrent').text(num)