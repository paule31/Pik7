# UI code for the presenter view
define ['lib/forceAspectRatio', 'jquery'], (forceAspectRatio, $) -> (app) ->

  # Interface sizes
  # ---------------

  # Use a 4/3 aspect ratio throughout the entire prsenter app
  forceAspectRatio = forceAspectRatio.bind(null, 4/3)
  wrapperEnforcer = forceAspectRatio('#PikPresenterAppWrapper', 'html', 1, yes, yes, 'margin-top')
  mainEnforcer = forceAspectRatio('#PikFrame', '#PikPresenterAppWrapper', 0.75)
  prevEnforcer = forceAspectRatio('#PikFramePreview', '#PikPresenterAppWrapper', 0.425)
  optionsEnforcer = forceAspectRatio('#PikPresenterOptions', '#PikPresenterAppWrapper', 0.7, yes, no)
  ratioEnforcer = ->
    wrapperEnforcer()
    mainEnforcer()
    prevEnforcer()
    optionsEnforcer()
  ratioEnforcer()
  $(window).bind('resize', ratioEnforcer)


  # Reloadable App UI
  # -----------------

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


    # Timers
    # ------
    $timerCurrent = $('#PikTimeCurrent')
    $timerElapsed = $('#PikTimeElapsed')
    timerStart = Date.now()
    # Pad a number with a leading zero
    pad = (x) ->
      x = x + ''
      if x.length == 1 then return '0' + x else  return x
    # Time update function to run each second
    update = ->
      now = Date.now()
      diff = new Date(now - timerStart)
      $timerCurrent.html(new Date(now).toLocaleTimeString())
      $timerElapsed.html(pad(diff.getHours() - 1) + ':' + pad(diff.getMinutes()) + ':' + pad(diff.getSeconds()))
    setInterval(update, 1000)