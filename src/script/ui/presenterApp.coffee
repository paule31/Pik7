# Presenter App
# =============

# UI code for the presenter view.

define ['lib/forceAspectRatio', 'jquery'], (forceAspectRatio, $) -> (app) ->


  # Use a 4/3 aspect ratio throughout the entire presenter app
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
  # Opera Mobile (and Chrome Mobile?) don't fire resize event when the device
  # orientation changes, so we use media query listeners (works at least for
  # Opera)
  if window.matchMedia
    mql = window.matchMedia("(orientation: portrait)")
    mql.addListener(ratioEnforcer)


  # Reloadable App UI
  countdownTimerId = null
  app.on 'load', ->
    frame = $('#PikFrame')[0].contentWindow
    pik = frame.Pik.__app__
    # Change the page title when a new presentation loads
    presentationTitle = frame.$('title').text()
    $('title').text(presentationTitle)
    # Update slide counter
    $('#PikSlideCount').text(pik.numSlides)
    $('#PikSlideCurrent').text(app.controller.getSlide() + 1)
    app.controller.on 'slide', (num) ->
      $('#PikSlideCurrent').text(num + 1)


    # Slide select
    $slideSelect = $('#PikControlsSelect')
    pik.slides.each (index, slide) ->
      text = $(slide).find('h1, h2, h3, h4, h5, h6, p').first().text() || index
      $('<option />').attr('value', index).text(text).appendTo($slideSelect)
    # Advance the select to the current slide
    $slideSelect.val(app.controller.getSlide())
    # Listen for changes
    $slideSelect.change -> app.controller.goTo($(this).val())
    # Keep up with slide changes
    app.controller.on 'slide', (num) -> $slideSelect.val(num)


    # Timers
    # ------


    $timerCurrent = $('#PikTimeCurrent')
    $timerCountdown = $('#PikTimeCountdown')
    timerStart = Date.now()


    # Turn a number into a string and pad it with a leading zero if it's a single digit
    pad = (x) -> if String(x).length == 1 then '0' + x else '' + x


    # Countdown timer
    countdownStep = 1
    updateCountdown = do ->
      ticks = 0
      return ->
        ticks += countdownStep
        diff = new Date(ticks * 1000)
        $timerCountdown.html(pad(diff.getHours() - 1) + ':' + pad(diff.getMinutes()) + ':' + pad(diff.getSeconds()))
    if countdownTimerId? then clearInterval(countdownTimerId)
    countdownTimerId = setInterval(updateCountdown, 1000)


    # Current time display
    updateTime = ->
      now = Date.now()
      diff = new Date(now - timerStart)
      $timerCurrent.html(new Date(now).toLocaleTimeString())
    setInterval(updateTime, 1000)


    # Countdown timer controls
    $('#PikCountdownControl').click (evt) ->
      evt.preventDefault()
      $self = $(this)
      if $self.hasClass('running')
        clearInterval(countdownTimerId)
        $self.toggleClass('running paused')
        $self.children().first().html('Start')
      else
        countdownTimerId = setInterval(updateCountdown, 1000)
        $self.toggleClass('running paused')
        $self.children().first().html('Stop')


  # Options window
  # --------------


  # Open and close options window
  $('#PikPresenterOptionsLink').click ->
    $('#PikPresenterOptions').addClass('open')
    $('#PikPresenterOptionsOverlay').addClass('open')
  $('#PikOptionsCloseButton').click ->
    $('#PikPresenterOptions').removeClass('open')
    $('#PikPresenterOptionsOverlay').removeClass('open')


  # Main frame selection
  $mainFrameSelect = $('#PikOptionsMainFrameContent')
  $mainFrameSelect.val(app.options.get('mainFrameContent'))
  $mainFrameSelect.change -> app.options.set('mainFrameContent', this.value)
  app.options.on 'mainFrameContent', (value) -> $mainFrameSelect.val(value)


  # Secondary frame selection
  $secondaryFrameSelect = $('#PikOptionsSecondaryFrameContent')
  $secondaryFrameSelect.val(app.options.get('secondaryFrameContent'))
  $secondaryFrameSelect.change -> app.options.set('secondaryFrameContent', this.value)
  app.options.on 'secondaryFrameContent', (value) -> $secondaryFrameSelect.val(value)


  # Suppress events
  $suppressEvents = $('#PikNoEvents')
  $suppressEvents.prop('checked', app.options.get('suppressEvents'))
  $suppressEvents.change ->
    app.options.set('suppressEvents', this.checked)
  app.options.on 'suppressEvents', (state) ->
    $suppressEvents.prop('checked', state)
  app.options.trigger('suppressEvents', app.options.get('suppressEvents'))


  # Full screen for iframes
  fullScreenApi =
    if Element.prototype.requestFullScreen then 'requestFullScreen'
    else if Element.prototype.mozRequestFullScreen then 'mozRequestFullScreen'
    else if Element.prototype.webkitRequestFullScreen then 'webkitRequestFullScreen'
    else null
  if fullScreenApi
    $container = $('#PikTimer')
    $('<a />').attr({
      'id': 'PikFullScreenMain'
      'title': 'Fullsceen for main frame'
      'class': 'iconFullscreen pikFullScreen'
    }).appendTo($container).click ->
      $('#PikFrame')[0][fullScreenApi]()
    $('<a />').attr({
      'id': 'PikFullScreenPreview'
      'title': 'Fullsceen for secondary frame'
      'class': 'iconFullscreen pikFullScreen'
    }).appendTo($container).click ->
      $('#PikFramePreview')[0][fullScreenApi]()