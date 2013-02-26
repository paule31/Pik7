# Presenter view
# ==============

# The presenter view app is an extension of the normal viewer. The main
# difference is that the presenter view has two iframes instead of one.
define [
  'app',
  'lib/statefulEmitter',
  'lib/iframe',
  'jquery'
], (App, StatefulEmitter, Iframe, $) -> return class PresenterApp extends App


  # When the app loads, trigger `@switchNotes()` once for each iframe to display
  # content in the right configuration
  constructor: (defaults, options) ->
    @setOptions(options)
    super(defaults)
    @on 'load', =>
      @switchNotes(@iframe, @options.get('mainFrameContent'))
      @switchNotes(@secondaryIframe, @options.get('secondaryFrameContent'))


  # The presenter has some configuration options that are represented by a
  # stateful emitter. The iframes listen for changes on relevant options and
  # react to them by e.g displaying notes instead of slides
  setOptions: (options) ->
    @options = new StatefulEmitter(options, 'pikOptions')
    @options.on 'mainFrameContent', (value) =>
      @switchNotes(@iframe, value)
      @onSlide(@controller.getSlide())
    @options.on 'secondaryFrameContent', (value) =>
      @switchNotes(@secondaryIframe, value)
      @onSlide(@controller.getSlide())


  # Switch notes modes on and off for the passed iframe instance by simply
  # changing classes
  switchNotes: (iframe, value) ->
    # Only-notes-state
    onlyMethod = if value == 'currentNotes' then 'addClass' else 'removeClass'
    iframe.window.$('html')[onlyMethod]('pikOnlyNotes')
    # On/Off state
    onOffMethod = if value.substr(-7) == 'NoNotes' then 'addClass' else 'removeClass'
    iframe.window.$('html')[onOffMethod]('pikNoNotes')


  # Connect the secondary frame along with the primary iframe (`super()`)
  connectIframe: (defaults) ->
    @secondaryIframe = new Iframe('#PikFramePreview')
    super(defaults)


  # Do a normal init but add the secondard iframe afterwards
  init: (defaults) ->
    super(defaults)
    @secondaryIframe.do('file', @controller.getFile())


  # Require `onReady()` to be called twice, once for each frame. Load the second
  # iframe with the correct file after the first call
  onReady: do ->
    fn = ->
      if @initialized
        file = @iframe.frame[0].contentWindow.location.href
        @secondaryIframe.do('file', file)
      PresenterApp::onReady = ->
        super()
        PresenterApp::onReady = fn


  # Overload file method to add the secondary frame, but change only if the
  # primary did
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