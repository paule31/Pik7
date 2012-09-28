define ['lib/presentation', 'jquery'], (Presentation) ->

  return class Slides

    constructor: ->
      presentation = new Presentation ->
        @on 'slide', (num) ->
          console.log "Presentation slide: #{num}"
        @on 'hidden', (state) ->
          console.log "Presentation hidden state: #{state}"