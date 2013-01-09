require ['lib/emitter', 'jquery'], (Emitter) ->
  'use strict'

  test 'Fail to initalize without topics', ->
    raises -> emitter = new Emitter()

  test 'Add callbacks', ->
    emitter = new Emitter 'foo', 'bar'
    cb1 = ->
    cb2 = ->
    emitter.on 'foo', cb1
    emitter.on 'bar', cb2
    strictEqual emitter.topics['foo'][0], cb1
    strictEqual emitter.topics['bar'][0], cb2

  test 'Remove callbacks', ->
    emitter = new Emitter 'foo'
    cb1 = ->
    cb2 = ->
    cb3 = ->
    emitter.on 'foo', cb1
    emitter.on 'foo', cb2
    emitter.on 'foo', cb3
    emitter.off 'foo', cb2
    ok emitter.topics['foo'].indexOf cb1 > -1
    ok emitter.topics['foo'].indexOf cb2 == -1
    ok emitter.topics['foo'].indexOf cb3 > -1
    ok emitter.topics['foo'].length == 2

  test 'Remove all callbacks from a topic', ->
    emitter = new Emitter 'foo'
    emitter.on 'foo', ->
    emitter.on 'foo', ->
    emitter.offAll 'foo'
    ok emitter.topics['foo'].length == 0

  test 'Remove all callbacks', ->
    emitter = new Emitter 'foo', 'bar'
    emitter.on 'foo', ->
    emitter.on 'foo', ->
    emitter.on 'bar', ->
    emitter.on 'bar', ->
    emitter.offAll()
    ok emitter.topics['foo'].length == 0
    ok emitter.topics['bar'].length == 0

  test 'Remove callbacks in ways that triggers errors', ->
    emitter = new Emitter 'foo'
    cb1 = ->
    cb2 = ->
    emitter.on 'foo', cb1
    raises -> emitter.off 'foo', cb2
    raises -> emitter.off 'bat', cb1
    raises -> emitter.off 'foo', 'not a callback'
    raises -> emitter.offAll 'bat'

  test 'Add callbacks in ways that triggers errors', ->
    emitter = new Emitter 'foo', 'bar'
    raises ->
      emitter.on 'topic_doesnt_exist', ->
    raises ->
      fn = ->
      emitter.on 'foo', fn
      emitter.on 'foo', fn
    raises ->
      fn = 'not a callback'
      emitter.on 'foo', fn

  test 'Trigger events', ->
    emitter = new Emitter 'foo'
    emitter.on 'foo', -> ok yes
    emitter.trigger 'foo'

  test 'Trigger events with arguments', ->
    emitter = new Emitter 'foo'
    emitter.on 'foo', (a, b) ->
      strictEqual a, 'hello'
      strictEqual b, 42
    emitter.trigger 'foo', 'hello', 42

  test 'Trigger events in ways that triggers errors', ->
    emitter = new Emitter 'foo'
    raises -> emitter.trigger 'bar'