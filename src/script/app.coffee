define ['lib/controller', 'lib/iframe', 'lib/hash'], (Controller, Iframe, Hash) ->

  # Asdfd

  return class App

    # Different things need to happen when the iframe loads depending on if this is the
    # first load or a late change of slides, so `initialized` keeps track of this.
    initialized = no

    constructor: (defaults) ->
      @iframe = new Iframe('iframe')
      @controller = new Controller(defaults)
      @connectController()
      @connectIframe()
      @init()

    # Listen for controller events
    connectController: ->
      @controller.on('file', @onFile.bind(@))
      @controller.on('slide', @onSlide.bind(@))
      @controller.on('hidden', @onHidden.bind(@))

    # Connects the Iframe's control events to the controller as soon as the prsentation
    # inside loads. Also triggers a controller reset if this isn't the first presentation
    # in this session
    connectIframe: ->
      @iframe.on 'load', =>
        if initialized then @reset()
        @iframe.window.Pik.controls.on('next', @controller.goNext.bind(@controller))
        @iframe.window.Pik.controls.on('prev', @controller.goPrev.bind(@controller))
        @iframe.window.Pik.controls.on('toggleHidden', @controller.toggleHidden.bind(@controller))
        initialized = yes if not initialized

    # To trigger the initial load of the iframe, the trigger functions must be called once
    # with exactly the values that are present in in controller at this time
    init: ->
      @onFile @controller.getFile()
      @onSlide @controller.getSlide()
      @onHidden @controller.getHidden()

    # Things to do when the controller reports changes. Also needed for init on first load
    # of the frame (see `@init`)
    onFile: (file) -> @iframe.do('file', file)
    onSlide: (slide) -> @iframe.do('slide', slide)
    onHidden: (state) -> @iframe.do('hidden', state)

    # A "reset" happens each time after a new presentation is loaded into the iframe. It
    # consists of
    #
    # 1. unbinding of all previous controller events
    # 2. creation of a new controller with a new blank state
    reset: ->
      basePath = Hash::commonPath window.location.href, @iframe.window.location.href
      slidesPath = @iframe.window.location.href.substring(basePath.length, @iframe.window.location.href.length)
      state = {
        file: '/' + slidesPath
        numSlides: @iframe.window.Pik.numSlides
        slide: 0
        hidden: no
      }
      @controller.offAll()
      @controller = new Controller(state)
