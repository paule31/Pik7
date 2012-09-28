require ['frame', 'presentation', 'jquery', 'prefixfree'], (Frame, Presentation) ->

  # If the page looks like a frame, it's probably just that
  if $('#Pik-Frame').length > 0
    console.log 'Frame!'


  # otherwise it's obviously a presentation
  else
    console.log 'Präsi!'