define ['lib/presentation', 'jquery'], (Presentation) ->

  presentation = new Presentation ->
    console.log 'Presentation ready'

  presentation.on 'slide', (num) ->
    console.log "Presentation slide: #{num}"

  presentation.on 'hidden', (state) ->
    console.log "Presentation hidden state: #{num}"