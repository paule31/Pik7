# UI code for the presenter view
define -> (app) ->

  # Change the page title when a new presentation loads
  app.on 'load', ->
    presentationTitle = $('iframe')[0].contentWindow.$('title').text()
    $('title').text(presentationTitle)