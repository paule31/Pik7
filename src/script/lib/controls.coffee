# Controls
# ========

# Catches key events (left/right arrow, F5, ESC) and trigger the accoding events
# (`next`, `prev`, `toggleHidden`). Also catches touch events.

define ['lib/emitter', 'jquery'], (Emitter) -> return class Controls extends Emitter


  # Events are not caught when their original target is an interactive element
  nonTargets: ['a', 'input', 'textarea', 'select', 'button']


  constructor: ->
    super('next', 'prev', 'toggleHidden')
    @addKeyEvents()
    @addTouchEvents()


  addKeyEvents: ->
    $(window).keydown (evt) =>
      if @filterTargets(evt) then @dispatchKeyEvent(evt)


  addTouchEvents: ->
    $(window).bind 'touchstart', (evt) =>
      if @filterTargets(evt) then @dispatchTouchEvents(evt)


  stopEvent: (evt) -> evt.preventDefault()


  filterTargets: (evt) ->
    if evt.target.nodeType != 1 then return true
    if $(evt.target).attr('contenteditable') == 'true' then return false
    return evt.target.nodeName.toLowerCase() not in @nonTargets


  dispatchKeyEvent: (evt) ->
    code = evt.keyCode
    if(code == 37 || code == 33) # Left arrow key and pgdn (previous slide)
      @trigger('prev', evt)
      @stopEvent(evt)
    else if code == 39 || code == 34 # Right arrow key and pgup (next slide)
      @trigger('next', evt)
      @stopEvent(evt)
    else if code == 116 || code == 27 # F5 / ESC (hides the presentation)
      @trigger('toggleHidden', evt)
      @stopEvent(evt)


  # Tap on the right half of the screen = next slide.
  # Tap on the left half of the screen = previous slide.
  dispatchTouchEvents: (evt) ->
    if evt.originalEvent.touches[0].pageX > window.innerWidth / 2
      @trigger('next', evt)
      @stopEvent(evt)
    else
      @trigger('prev', evt)
      @stopEvent(evt)