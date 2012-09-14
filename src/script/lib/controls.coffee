#
#
#

define ['lib/emitter', 'jquery'], (Emitter) ->

  return class Controls extends Emitter

    #
    constructor: ->
      super 'next', 'prev', 'toggleHidden'
      @nonTargets = ['input', 'textarea']
      @addKeyEvents()

    addKeyEvents: ->
      $(window).keydown (evt) =>
        if @filterTargets evt then @dispatch evt

    stopEvent: (evt) ->
      evt.preventDefault()
      evt.stopPropagation()

    #
    filterTargets: (evt) ->
      if evt.target.nodeType != 1 then return true
      return evt.target.nodeName.toLowerCase() not in @nonTargets

    #
    dispatch: (evt) ->
      code = evt.keyCode
      # Left arrow key (previous slide)
      if(code == 37 || code == 33)
        @trigger 'prev', evt
        @stopEvent evt
      # Right arrow key (next slide)
      else if code == 39 || code == 34
        @trigger 'next', evt
        @stopEvent evt
      # F5 / ESC (hides the presentation)
      else if code == 116 || code == 190 || code == 27
        @trigger 'toggleHidden', evt
        @stopEvent evt
