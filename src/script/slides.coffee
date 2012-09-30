define ['lib/presentation', 'jquery'], (Presentation) ->

  return class Slides

    # Store the slide set and the index for the current, next and previous slide
    slides: null
    curr: 0
    next: 1
    prev: -1

    constructor: ->
      self = this
      @setupDom()
      @setupSizes()
      @presentation = new Presentation ->
        @on 'slide', self.goTo
        @on 'hidden', self.setHidden

    # Link the stylesheet, create the hide layer and store the slides in `@slides`
    setupDom: ->
      $('<link></link>').attr({
        rel: 'stylesheet'
        href: '../../core/pik7.css'
      }).appendTo('head')
      $('<div></div>').attr({
        id: 'PikHide'
      }).appendTo('body')
      @slides = $('.pikSlide')


    # Maintain a 4:3 aspect ratio, body positions, font and slide size every time the
    #presentation loads or the window is resized.
    setupSizes: ->
      $(window).ready ->
        setSizes = ->
          size = {
            x: $('html').width()
            y: $('html').height()
          }
          ratio = 4 / 3
          newwidth  = if size.x > size.y * ratio then size.y * ratio else size.x
          newheight = if size.x > size.y * ratio then size.y else size.x / ratio
          topmargin = Math.floor((size.y - newheight) / 2)
          fontsize  = (newheight + newwidth) / 6.5
          $('body').css {
            'width'     : newwidth  + 'px'
            'height'    : newheight + 'px'
            'font-size' : fontsize  + '%'
            'top'       : topmargin + 'px'
          };
        $(window).bind('load', setSizes);
        $(window).bind('resize', setSizes);


    # Display the slide `num`
    goTo: (num) =>
      $(@slides[@curr]).removeClass('pikCurrent')
      $(@slides[@next]).removeClass('pikNext')
      $(@slides[@prev]).removeClass('pikPrev')
      @curr = num
      @next = num + 1
      @prev = num - 1
      $(@slides[@curr]).addClass('pikCurrent')
      $(@slides[@next]).addClass('pikNext')
      $(@slides[@prev]).addClass('pikPrev')


    # Hide the presentation
    setHidden: (state) ->
      if state
        $('#PikHide').addClass('pikActive')
      else
        $('#PikHide').removeClass('pikActive')