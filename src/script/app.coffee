define ['lib/controller', 'lib/iframe'], (Controller, Iframe) ->

  return class App

    # PROBLEM: nach mehrmaligem Neuladen summieren sich die Controller-Instanzen auf
    # PROBLEM: Controller bekommt nicht mit, wenn sich die URL des Iframes nach neuladen ändert

    constructor: (defaults) ->
      @iframe = new Iframe('iframe')
      @iframe.on 'load', (url) =>
        @connectEmitters {
          file: url,
          slide: 0,
          hidden: defaults.hidden
          numSlides: @iframe.window.Pik.numSlides
        }

    connectEmitters: (defaults) ->
      @controller = new Controller(defaults)
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
