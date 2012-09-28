define ['lib/controller', 'lib/iframe'], (Controller, Iframe) ->

  return class App

    constructor: (@defaults) ->
      @iframe = new Iframe('iframe')
      @controller = new Controller @defaults
      @iframe.on 'load', => @connectEmitters()
      @iframe.do('file', @defaults.file)

    connectEmitters: ->
      iframeControls = @iframe.window.Pik.controls
      # Let the controller listen to the iframe's controls
      iframeControls.on 'next', =>
        @controller.goNext()
      iframeControls.on 'prev', =>
        @controller.goPrev()
      iframeControls.on 'toggleHidden', =>
        @controller.toggleHidden()
      # Let the iframe listen to the controller
      @controller.on 'file', (file) =>
        @iframe.do('file', file)
      @controller.on 'slide', (slide) =>
        @iframe.do('slide', slide)
      @controller.on 'hidden', (state) =>
        @iframe.do('hidden', state)
