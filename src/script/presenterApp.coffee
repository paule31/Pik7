# Presenter view app

define ['app', 'lib/statefulEmitter', 'lib/iframe', 'jquery'], (App, StatefulEmitter, Iframe, $) ->

  return class PresenterApp extends App


    constructor: (defaults, options) ->
      @setOptions(options)
      super(defaults)
      @on 'load', =>
        @switchNotes(@iframe, (@options.get('mainFrameContent') == 'currentNotes'))
        @switchNotes(@secondaryIframe, (@options.get('secondaryFrameContent') == 'currentNotes'))


    # Create the options emitter and let the iframes listen for changes on relevant options
    setOptions: (options) ->
      @options = new StatefulEmitter(options, 'pikOptions')
      @options.on 'mainFrameContent', (value) =>
        @switchNotes(@iframe, (value == 'currentNotes'))
        @onSlide(@controller.getSlide())
      @options.on 'secondaryFrameContent', (value) =>
        @switchNotes(@secondaryIframe, (value == 'currentNotes'))
        @onSlide(@controller.getSlide())


    # Switch show-notes-only mode on and off for the passed iframe instance
    switchNotes: (iframe, status) ->
      method = if status then 'addClass' else 'removeClass'
      iframe.window.$('html')[method]('pikOnlyNotes')


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