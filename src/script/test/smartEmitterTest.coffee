require ['lib/smartEmitter', 'lib/emitter', 'jquery'], (SmartEmitter, Emitter) ->
  $(document).ready ->

    'use strict'

    test 'Events triggered by non-subscribing (simple) objects fire', ->
      stop(2)
      testObj1 = {}
      testObj2 = {}
      emitter = new SmartEmitter 'foo'
      emitter.on 'foo', testObj1, (arg) ->
        start()
        strictEqual arg, 42
      emitter.trigger 'foo', testObj2, 42
      emitter.trigger 'foo', null, 42

    test "Events triggered by subscribing (simple) objects don't fire", ->
      stop()
      testObj = {}
      emitter = new SmartEmitter('foo')
      emitter.on 'foo', testObj, ->
        throw new Error 'Event triggered; this should never happen!'
        start()
      emitter.trigger 'foo', testObj
      setTimeout ->
        ok(yes)
        start()
      , 500

    test "Connect two other emitters", ->
      stop(2)
      emitter = new SmartEmitter('bar', 'foo')
      testObj1 = new Emitter('foo', 'bar')
      testObj2 = new Emitter('foo', 'bar')
      emitter.onAll testObj1
      emitter.onAll testObj2
      # Event triggered on Object 2 should be recieved by O1 and the SE, but not by O2
      # This should result in exactly 2 events
      count = 0
      emitter.on 'foo', testObj1, (arg) ->
        count++
        ok(arg == 42)
        ok(count < 3)
        start()
      emitter.on 'foo', testObj2, (arg) ->
        count++
        ok(arg == 24)
        ok(count < 3)
        start()
      testObj1.trigger('foo', 24)
      testObj2.trigger('foo', 42)

    test "Fail to connect incompatible emitters", ->
      emitter = new SmartEmitter('foo', 'bar')
      testObj = new Emitter('foo', 'baz')
      raises -> emitter.onAll(testObj)