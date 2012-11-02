# Presenter view app

define ['app', 'lib/statefulEmitter', 'lib/iframe', 'jquery'], (App, StatefulEmitter, Iframe, $) ->

  return class PresenterApp extends App


    constructor: (defaults, options) ->
      @setOptions(options)
      super(defaults)


    # Create the options emitter and let the iframes listen for changes on relevant options
    setOptions: (options) ->
      @options = new StatefulEmitter(options)
      @options.on 'mainFrameContent', => @onSlide(@controller.getSlide())
      @options.on 'secondaryFrameContent', => @onSlide(@controller.getSlide())


    # In addition to the main iframe connect the secondary frame
    connectIframe: (defaults) ->
      @secondaryIframe = new Iframe('#PikFramePreview')
      super(defaults)


    # Do a normal init but add the secondard iframe afterwards
    init: (defaults) ->
      super(defaults)
      @secondaryIframe.do('file', @controller.getFile())


    # Require `onReady()` to be called twice, once for each frame
    onReady: -> PresenterApp::onReady = -> super()


    # Overload file method to add the secondary frame, but change only if the primary did
    onFile: (file) ->
      if super(file)
        @secondaryIframe.do('file', file)


    # Check the options to see what slide to display
    onSlide: (currentSlide) ->
      mainSlide = currentSlide
      if @options.get('mainFrameContent') == 'nextSlide' then mainSlide++
      super(mainSlide)
      secondarySlide = currentSlide
      if @options.get('secondaryFrameContent') == 'nextSlide' then secondarySlide++
      @secondaryIframe.do('slide', secondarySlide)


    # Overload method to add the secondary frame
    onHidden: (state) ->
      super(state)
      @secondaryIframe.do('hidden', state)