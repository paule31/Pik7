require ['lib/polyfill/bind', 'lib/vendor/almond',
         'app', 'presenterApp', 'ui/app', 'ui/presenterApp',
         'slides', 'jquery', 'prefixfree'], (_bind, _almond, App, PresenterApp, appUi, presenterAppUi, Slides) ->

  # Default values for a newly initalized App or PresenterApp
  appDefaults = {
    file: 'core/welcome.html'
    slide: 0
    hidden: no
    numSlides: 1
  }

  # Default PresenterApp options
  presenterAppOptionDefaults = {
    optionsOpen: no
    mainFrameContent: 'currentSlide'
    secondaryFrameContent: 'nextSlide'
    countdown: no
    countdownRunning: no
    countdownAmount: 30
    countdownWarnAmount: 1
  }

  # Default app view
  if $('#PikApp').length > 0
    app = new App(appDefaults)
    appUi(app)

  # Presenter view
  else if $('#PikPresenterApp').length > 0
    app = new PresenterApp(appDefaults, presenterAppOptionDefaults)
    presenterAppUi(app)

  # Slide set
  else if $('#PikSlides').length > 0
    new Slides()