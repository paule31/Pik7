define ['lib/presentation', 'jquery'], (Presentation) ->

  return class Slides

    # Store the slide set and the index for the current, next and previous slide
    #slides: null
    #slide: 0
    #next:  1
    #prev: -1

    constructor: ->
      @setupDom()
      that = this
      presentation = new Presentation ->
        @on 'slide', that.goTo
        @on 'hidden', that.setHidden

    setupDom: ->
      # Styles
      $('<link></link>').attr({
        rel: 'stylesheet'
        href: '../../core/pik7.css'
      }).appendTo('head')
      # Hide layer
      $('<div></div>').attr({
        id: 'PikHide'
      }).appendTo('body')
      # Store slides
      @slides = $('.pikSlide')


    goTo: (num) ->
      console.log "Presentation slide: #{num}"


    setHidden: (state) ->
      console.log "Presentation hidden state: #{state}"