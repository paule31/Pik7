require ['lib/controls'], (Controls) -> $(window).ready ->
  'use strict'

  class MockControls extends Controls
    constructor: ->
      $(window).off 'keydown'
      super()
    addKeyEvents: ->
      $(window).keydown (evt, testCode) =>
        if @filterTargets evt then @dispatch { keyCode: testCode }
    stopEvent: ->

  keys = {
    'next': [39, 34]
    'prev': [37, 33]
    'toggleHidden': [116, 190, 27]
  }

  test 'Navigation keys', ->
    controls = new MockControls
    stop 2
    controls.on 'next', (evt) ->
      ok evt.keyCode in keys.next
      start()
    controls.on 'prev', (evt) ->
      ok evt.keyCode in keys.prev
      start()
    $(window).trigger('keydown', code) for code in keys.next
    $(window).trigger('keydown', code) for code in keys.prev

  test 'Hide keys', ->
    controls = new MockControls
    stop 3
    controls.on 'toggleHidden', (evt) ->
      ok evt.keyCode in keys.toggleHidden
      start()
    $(window).trigger('keydown', code) for code in keys.toggleHidden

  test 'Key events filtered on blocking targets', ->
    controls = new MockControls
    triggered = false
    controls.on 'next', (evt) -> triggered = true
    stop()
    setTimeout ->
      strictEqual triggered, false
      start()
    , 500
    $('body > input, body > textarea').each (index, element) ->
      $(element).trigger 'keydown', code for code in keys.next