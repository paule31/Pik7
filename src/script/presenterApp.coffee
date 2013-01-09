# Presenter view app

define ['app', 'lib/statefulEmitter', 'lib/iframe', 'jquery'], (App, StatefulEmitter, Iframe, $) ->

  return class PresenterApp extends App


    constructor: (defaults, options) ->
      @setOptions(options)
      super(defaults)
      @on 'load', =>
        @switchNotes(@iframe, @options.get('mainFrameContent'))
        @switchNotes(@secondaryIframe, @options.get('secondaryFrameContent'))


    # Create the options emitter and let the iframes listen for changes on relevant options
    setOptions: (options) ->
      @options = new StatefulEmitter(options, 'pikOptions')
      @options.on 'mainFrameContent', (value) =>
        @switchNotes(@iframe, value)
        @onSlide(@controller.getSlide())
      @options.on 'secondaryFrameContent', (value) =>
        @switchNotes(@secondaryIframe, value)
        @onSlide(@controller.getSlide())


    # Switch notes modes on and off for the passed iframe instance
    switchNotes: (iframe, value) ->
      # Only-notes-state
      onlyMethod = if value == 'currentNotes' then 'addClass' else 'removeClass'
      iframe.window.$('html')[onlyMethod]('pikOnlyNotes')
      # On/Off state
      onOffMethod = if value.substr(-7) == 'NoNotes' then 'addClass' else 'removeClass'
      iframe.window.$('html')[onOffMethod]('pikNoNotes')


    # In addition to the main iframe connect the secondary frame
    connectIframe: (defaults) ->
      @secondaryIframe = new Iframe('#PikFramePreview')
      super(defaults)


    # Do a normal init but add the secondard iframe afterwards
    init: (defaults) ->
      super(defaults)
      @secondaryIframe.do('file', @controller.getFile())


    # Require `onReady()` to be called twice, once for each frame. Load the second iframe
    # with the correct file after the first call
    onReady: do ->
      fn = ->
        if @initialized
          file = @iframe.frame[0].contentWindow.location.href
          @secondaryIframe.do('file', file)
        PresenterApp::onReady = ->
          super()
          PresenterApp::onReady = fn


    # Overload file method to add the secondary frame, but change only if the primary did
    onFile: (file) ->
      hasChanged = super(file)
      if hasChanged
        @secondaryIframe.do('file', file)


    # Check the options to see what slide to display
    onSlide: (currentSlide) ->
      mainSlide = currentSlide
      if @options.get('mainFrameContent') in ['nextSlide', 'nextSlideNoNotes']
        mainSlide++
      super(mainSlide)
      secondarySlide = currentSlide
      if @options.get('secondaryFrameContent') in ['nextSlide', 'nextSlideNoNotes']
        secondarySlide++
      @secondaryIframe.do('slide', secondarySlide)


    # Overload method to add the secondary frame
    onHidden: (state) ->
      super(state)
      @secondaryIframe.do('hidden', state)