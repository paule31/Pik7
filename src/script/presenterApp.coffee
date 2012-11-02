# Presenter view app

define ['lib/iframe', 'app', 'jquery'], (Iframe, App, $) ->

  return class PresenterApp extends App


    constructor: (defaults, options) ->
      super(defaults)


    # In addition to the main iframe connect the secondary frame
    connectIframe: (defaults) ->
      @secondaryIframe = new Iframe('#PikFramePreview')
      super(defaults)


    # Do a normal init but add the secondard iframe afterwards
    init: (defaults) ->
      super(defaults)
      @secondaryIframe.do('file', @controller.getFile())


    # Have `onReady` to be called twice, once for each frame
    onReady: -> PresenterApp::onReady = -> super()


    # Overload methods to add the secondary frame
    onFile: (file) ->
      if super(file)
        @secondaryIframe.do('file', file)
    onSlide: (slide) ->
      super(slide)
      @secondaryIframe.do('slide', slide)
    onHidden: (state) ->
      super(state)
      @secondaryIframe.do('hidden', state)