# UI code for the default app view
define ['jquery'], ($) -> return (app) ->


  # Reload link
  $('.reloadLink').click ->
    $('iframe')[0].contentWindow.location.reload(true)


  # Print link
  $('.printLink').click ->
    printPath = $('iframe')[0].contentWindow.location.href + '#print'
    window.open(printPath)


  # Open and close the control panel by toggleing a class on touch or mouseover.
  # Working with :hover makes things complicated on touch devices, so this will have
  # to do. Open/close the control panel when it's hovered or touched.
  $controlsContainer = $('#PikControlsContainer')
  $controlsContainer.bind 'mouseover', -> $(this).addClass('open')
  $controlsContainer.bind 'mouseout', -> $(this).removeClass('open')
  $controlsContainer.bind 'touchstart', (evt) ->
    evt.stopPropagation()
    evt.preventDefault()
    $(this).toggleClass('open')
  $controlsContainer.find('a').bind 'touchstart', (evt) ->
    evt.stopPropagation()
    # The timeout prevents iOS from closing the control panel before the touch is
    # registered on the link
    setTimeout (-> $controlsContainer.removeClass('open')), 600


  # Change the page title when a new presentation loads
  app.on 'load', ->
    presentationTitle = $('iframe')[0].contentWindow.$('title').text()
    $('title').text(presentationTitle)


    # Clicks and touches in the iframe don't bubble up to the containing window by
    # themselves, so we have to delegate them manually
    for iframe in $('iframe')
      iframe.contentWindow.$('body').bind 'touchstart', (evt) ->
        if $controlsContainer.hasClass('open')
          $controlsContainer.removeClass('open')
          evt.preventDefault()
          evt.stopPropagation()