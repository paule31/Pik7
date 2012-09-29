define ['lib/controller', 'lib/iframe'], (Controller, Iframe) ->

  return class App

    initialized = no

    constructor: (defaults) ->
      @iframe = new Iframe('iframe')
      @controller = new Controller defaults
      @connectIframe()
      @init()

    # Delegate control events from the iframe to the controller
    # Delegate slide and hidden status events from the controller to the presentation
    connectIframe: ->
      @iframe.on 'load', =>
        if initialized then @reset()
        @iframe.window.Pik.controls.on 'next', @controller.goNext.bind(@controller)
        @iframe.window.Pik.controls.on 'prev', @controller.goPrev.bind(@controller)
        @iframe.window.Pik.controls.on 'toggleHidden', @controller.toggleHidden.bind(@controller)
        @controller.on 'file', @onFile.bind(@)
        @controller.on 'slide', @onSlide.bind(@)
        @controller.on 'hidden', @onHidden.bind(@)
        initialized = yes if not initialized

    init: ->
      @onFile @controller.getFile()
      @onSlide @controller.getSlide()
      @onHidden @controller.getHidden()

    onFile: (file) ->
      @iframe.do 'file', file
    onSlide: (slide) ->
      @iframe.do 'slide', slide
    onHidden: (state) ->
      @iframe.do 'hidden', state

    reset: ->
      console.log('Reset!')