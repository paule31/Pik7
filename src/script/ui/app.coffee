# UI code for the default app view
define -> (app) ->

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