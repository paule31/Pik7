require ['lib/polyfill/bind', 'lib/vendor/almond',
         'app', 'presenterApp', 'slides',
         'jquery', 'prefixfree'], (_bind, _almond, App, PresenterApp, Slides) ->


  # Default values for a newly initalized App or PresenterApp
  appDefaults = {
    file: 'core/welcome.html'
    slide: 0
    hidden: no
    numSlides: 1
  }


  # If the page looks like an app frame, it's probably just that
  if $('#PikApp').length > 0
    app = new App(appDefaults)

    # Change the page title when a new presentation loads
    app.on 'load', ->
      presentationTitle = $('iframe')[0].contentWindow.$('title').text()
      $('title').text(presentationTitle)

    # Reload link
    $('.reloadLink').click ->
      $('iframe')[0].contentWindow.location.reload(true)

    # Print link
    $('.printLink').click ->
      printPath = $('iframe')[0].contentWindow.location.href + '#print'
      window.open(printPath)


  # ... or might it just be a presenter view?
  else if $('#PikPresenterApp').length > 0
    app = new PresenterApp(appDefaults)


  # Otherwise it's obviously a slide set
  else new Slides()