# Catch key events (left/right arrow, F5, ESC) and trigger the accoding events (`next`,
# `prev`, `toggleHidden`)

define ['lib/emitter', 'jquery'], (Emitter) ->

  return class Controls extends Emitter

    # Events are not caught when thier original target is an input or textarea
    # element (`@nonTargets`)
    constructor: ->
      super 'next', 'prev', 'toggleHidden'
      @nonTargets = ['input', 'textarea']
      @addKeyEvents()

    addKeyEvents: ->
      $(window).keydown (evt) =>
        if @filterTargets evt then @dispatch evt

    stopEvent: (evt) ->
      evt.preventDefault()

    filterTargets: (evt) ->
      if evt.target.nodeType != 1 then return true
      return evt.target.nodeName.toLowerCase() not in @nonTargets

    dispatch: (evt) ->
      code = evt.keyCode
      if(code == 37 || code == 33) # Left arrow key (previous slide)
        @trigger 'prev', evt
        @stopEvent(evt)
      else if code == 39 || code == 34 # Right arrow key (next slide)
        @trigger 'next', evt
        @stopEvent(evt)
      else if code == 116 || code == 27 # F5 / ESC (hides the presentation)
        @trigger 'toggleHidden', evt
        @stopEvent(evt)
