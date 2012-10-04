define ['lib/presentation', 'lib/hash', 'jquery'], (Presentation, Hash) ->
  return class Slides


    # Index for the current, next and previous slide
    curr: 0
    next: 1
    prev: -1

    # Special elements storage
    slides: null
    wrapper: null
    hideLayer: null

    constructor: ->
      self = this
      @setupDom()
      @setupSizes()
      @presentation = new Presentation ->
        @on('slide', self.goTo)
        @on('hidden', self.setHidden)
        self.print()


    # Try to figure out where the base directory is relative to the page
    getBasePath: ->
      source = if window.parent != window
        window.parent.location.href
      else
        window.opener.location.href || ''
      return base = if source
        Hash::commonPath(window.location.href, source)
      else
        '../../'


    # Link the stylesheet, create the hide layer and store the slides in `@slides`
    setupDom: ->
      basePath = @getBasePath()
      # Slide storage
      @slides = $('.pikSlide')
      # Base style sheet
      $('<link></link>').attr({
        rel: 'stylesheet'
        href: "#{basePath}core/pik7.css"
      }).appendTo('head')
      # Add the wrapper around the slides
      @wrapper = $('<div></div>').attr({
        id: 'PikSlideWrapper'
      })
      @wrapper.append(@slides).appendTo('body')
      # Hide layer
      @hideLayer = $('<div></div>').attr({
        id: 'PikHide'
      }).appendTo('body')
      # Link theme style sheet
      theme = $('script[data-theme]').data('theme') || 'default'
      $('<link></link>').attr({
        rel: 'stylesheet'
        href: "#{basePath}themes/#{theme}.css"
      }).appendTo('head')


    # Maintain a 4:3 aspect ratio, body positions, font and slide size every time the
    #presentation loads or the window is resized.
    setupSizes: ->
      $(window).ready =>
        setSizes = =>
          size = {
            x: $('html').width()
            y: $('html').height()
          }
          ratio = 4 / 3
          newwidth  = if size.x > size.y * ratio then size.y * ratio else size.x
          newheight = if size.x > size.y * ratio then size.y else size.x / ratio
          topmargin = Math.floor((size.y - newheight) / 2)
          fontsize  = (newheight + newwidth) / 6.5
          @wrapper.css({
            'width'     : newwidth  + 'px'
            'height'    : newheight + 'px'
            'font-size' : fontsize  + '%'
            'top'       : topmargin + 'px'
          })
        $(window).bind('load', setSizes)
        $(window).bind('resize', setSizes)


    # Pop up the print dialog if it look like a good idea
    print: ->
      window.print() if window.location.hash == '#print'


    # Display the slide `num`
    goTo: (num) =>
      $(@slides[@curr]).trigger('pikDeactivate')
      $(@slides[@curr]).removeClass('pikCurrent')
      $(@slides[@next]).removeClass('pikNext')
      $(@slides[@prev]).removeClass('pikPrev')
      @curr = num
      @next = num + 1
      @prev = num - 1
      $(@slides[@curr]).trigger('pikActivate')
      $(@slides[@curr]).addClass('pikCurrent')
      $(@slides[@next]).addClass('pikNext')
      $(@slides[@prev]).addClass('pikPrev')
      $(window).trigger('pikSlide', [@curr])


    # Hide the presentation
    setHidden: (state) ->
      if state
        $(window).trigger('pikHide', [@curr])
        $('#PikHide').addClass('pikActive')
      else
        $(window).trigger('pikShow', [@curr])
        $('#PikHide').removeClass('pikActive')