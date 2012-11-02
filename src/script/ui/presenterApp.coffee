# UI code for the presenter view
define ['jquery'], ($) -> (app) ->

  app.on 'load', ->
    frame = $('#PikFrame')[0].contentWindow
    pik = frame.Pik


    # Add a class to the presentation's html element to indicate that it's displayed in the presenter
    frame.$('html').addClass('pikInPresenter')


    # Change the page title when a new presentation loads
    presentationTitle = frame.$('title').text()
    $('title').text(presentationTitle)


    # Update slide counter
    $('#PikSlideCount').text(frame.Pik.numSlides)
    $('#PikSlideCurrent').text(app.controller.getSlide() + 1)
    app.controller.on 'slide', (num) ->
      $('#PikSlideCurrent').text(num + 1)


    # Slide select
    # ------------

    $slideSelect = $('#PikControlsSelect')

    # Populate slide select
    pik.slides.each (index, slide) ->
      text = $(slide).find('h1, h2, h3, h4, h5, h6, p').first().text() || index
      $('<option />').attr('value', index).text(text).appendTo($slideSelect)

    # Advance the select to the current slide
    $slideSelect.val(app.controller.getSlide())

    # Listen for changes
    $slideSelect.change -> app.controller.goTo($(this).val())

    # Keep up with slide changes
    app.controller.on 'slide', (num) -> $slideSelect.val(num)


    # Suppress Events
    # ---------------
    $('#PikNoEvents').change ->
      if this.checked
        frame.$('html').addClass('pikNoEvents')
      else
        frame.$('html').removeClass('pikNoEvents')