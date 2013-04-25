# Pik7
# ====

# `pik7.coffee` is the basis for every aspect of Pik7. It powers the viewer, the
# presenter or a slide set, depending on where it is included. Therefore, this
# module is responsible for loading all the polyfills, libraries and classes
# that will ever be used by Pik7.
require [
  'almond',            # AMD implementation for optimzed build
  'lib/polyfill/bind', # Required by prehistoric android browsers
  'app', 'presenterApp', 'ui/app', 'ui/presenterApp', 'slides', # Pik7 classes
  'jquery', 'prefixfree'
], (_bind, _almond, App, PresenterApp, appUi, presenterAppUi, Slides) ->


  # Default values for a newly initalized App or PresenterApp
  appDefaults = {
    file: 'core/welcome.html'
    slide: 0
    hidden: no
    numSlides: 1
  }


  # Default PresenterApp options
  presenterAppOptionDefaults = {
    mainFrameContent: 'currentSlide'
    secondaryFrameContent: 'nextSlide'
    suppressEvents: no
    countdown: no
    countdownRunning: no
    countdownAmount: 30
    countdownWarnAmount: 1
  }


  # Depending on the environment, initalize Pik7 as a Viewer (`App`), as a
  # PresenterApp or as a slide set
  isApp = $('#PikApp').length > 0
  isPresenter = $('#PikPresenterApp').length > 0
  isSlides = $('#PikSlides').length > 0

  if isApp
    appUi new App(appDefaults)
  else if isPresenter
    presenterAppUi new PresenterApp(appDefaults, presenterAppOptionDefaults)
  else if isSlides
    new Slides()