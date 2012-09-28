require ['lib/vendor/almond',
         'app', 'presentation',
         'jquery', 'prefixfree'], (_almond, App, Presentation) ->

  # If the page looks like an app frame, it's probably just that
  if $('#Pik-Frame').length > 0
    app = new App()
    console.log app


  # otherwise it's obviously a presentation
  else
    console.log 'Präsi!'