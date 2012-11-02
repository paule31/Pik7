require ['lib/statefulEmitter'], (StatefulEmitter) ->
  'use strict'

  test 'Initialize with the default values', ->
    e = new StatefulEmitter({ foo: 23 })
    strictEqual(e.get('foo'), 23)

  test 'Setters trigger events', ->
    stop()
    e = new StatefulEmitter({ foo: 23 })
    e.on 'foo', (x) ->
      strictEqual(x, 42)
      start()
    e.set('foo', 42)

  test 'Triggered events affect the state', ->
    stop()
    e = new StatefulEmitter({ foo: 23 })
    e.on 'foo', ->
      strictEqual(e.get('foo'), 42)
      start()
    e.trigger('foo', 42)

  test 'Fail when creating without a state object', ->
    raises -> e = new StatefulEmitter('something')

  test 'Fail when triggering without value or with more than one value', ->
    e = new StatefulEmitter({ foo: 42 })
    raises -> e.trigger('foo')
    raises -> e.trigger('foo', 23, 42, 1337)