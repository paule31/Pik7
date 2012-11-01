# Presenter view app

define ['app', 'lib/forceAspectRatio', 'jquery'], (App, forceAspectRatio, $) ->

  # Use 4/3 throughout the entire prsenter app
  forceAspectRatio = forceAspectRatio.bind(null, 4/3)


  return class PresenterApp extends App


    constructor: (defaults) ->
      super(defaults)
      @setSizes()
      @startTimers()


    #
    setSizes: ->
      wrapperEnforcer = forceAspectRatio('#PikPresenterAppWrapper', 'html', 1, yes, yes, 'margin-top')
      mainEnforcer = forceAspectRatio('#PikFrame', '#PikPresenterAppWrapper', 0.75)
      prevEnforcer = forceAspectRatio('#PikFramePreview', '#PikPresenterAppWrapper', 0.425)
      ratioEnforcer = ->
        wrapperEnforcer()
        mainEnforcer()
        prevEnforcer()
      ratioEnforcer()
      $(window).bind('resize', ratioEnforcer)


    #
    startTimers: ->
      $current = $('#PikTimeCurrent')
      $elapsed = $('#PikTimeElapsed')
      start = Date.now()
      # Pad a number with a leading zero
      pad = (x) ->
        x = x + ''
        if x.length == 1 then return '0' + x else  return x
      # Time update function to run each second
      update = ->
        now = Date.now()
        diff = new Date(now - start)
        $current.html(new Date(now).toLocaleTimeString())
        $elapsed.html(pad(diff.getHours() - 1) + ':' + pad(diff.getMinutes()) + ':' + pad(diff.getSeconds()))
      setInterval(update, 1000)

