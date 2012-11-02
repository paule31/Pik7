define ['lib/presentation', 'lib/hash', 'lib/forceAspectRatio', 'jquery'], (Presentation, Hash, forceAspectRatio, $) ->
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
      @presentation = new Presentation ->
        self.setupDom()
        self.setupSizes()
        @on('slide', self.goTo)
        @on('hidden', self.setHidden)
        # Trigger ready state *after* setting up the slide and hidden events to prevent
        # hours of bug seaching...
        if window != window.parent then window.parent.Pik.app.trigger('ready')
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
      # **HACK HACK HACK HACK**
      # Hack to ensure a fully sized canvas ASAP. This is needed because iframe's
      # load events are unreliable, but domready events are not. So when we add
      # `ratioEnforder()` to the load event in `@setupSizes()` there's no guarantee that
      # this will ever happen. But simply calling `setSizes()` on domready isn't enough
      # too, because than the base style sheet might not be loaded and/or parsed/applied
      # to the document. Only way out is to set the styles manually and calling
      # `ratioEnforder()` once independently of any events down in `@setupSizes()`.
      $('html, body').css('height', '100%')


    # Maintain a 4:3 aspect ratio, body positions, font and slide size every time the
    #presentation loads or the window is resized.
    setupSizes: ->
      ratioEnforcer = forceAspectRatio(4 / 3, @wrapper)
      ratioEnforcer() # See the long comment in `@setupDom()` for why this is here
      $(window).bind('resize', ratioEnforcer)


    # Pop up the print dialog if it look like a good idea
    print: ->
      window.print() if window.location.hash == '#print'


    # Display the slide `num`
    goTo: (num) =>
      $(@slides[@curr]).trigger('pikDeactivate') unless $('html').hasClass('pikNoEvents')
      $(@slides[@curr]).removeClass('pikCurrent')
      $(@slides[@next]).removeClass('pikNext')
      $(@slides[@prev]).removeClass('pikPrev')
      @curr = num
      @next = num + 1
      @prev = num - 1
      $(@slides[@curr]).trigger('pikActivate') unless $('html').hasClass('pikNoEvents')
      $(@slides[@curr]).addClass('pikCurrent')
      $(@slides[@next]).addClass('pikNext')
      $(@slides[@prev]).addClass('pikPrev')
      $(window).trigger('pikSlide', [@curr]) unless $('html').hasClass('pikNoEvents')


    # Hide the presentation
    setHidden: (state) ->
      if state
        $(window).trigger('pikHide', [@curr])
        $('#PikHide').addClass('pikActive')
      else
        $(window).trigger('pikShow', [@curr])
        $('#PikHide').removeClass('pikActive')