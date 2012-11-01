# Presenter view app

define ['app', 'lib/forceAspectRatio', 'jquery'], (App, forceAspectRatio, $) ->

  # Use 4/3 throughout the entire prsenter app
  forceAspectRatio = forceAspectRatio.bind(null, 4/3)


  return class PresenterApp extends App


    constructor: (defaults) ->
      super(defaults)
      @setSizes()


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