require ['lib/statefulEmitter'], (StatefulEmitter) ->

  'use strict'
  testKey = 'statefulEmitterTest'
  window.localStorage.removeItem(testKey)

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

  test 'Initialize and re-initialize with storage option', ->
    testObj = { foo: 23 }
    e1 = new StatefulEmitter(testObj, testKey)
    strictEqual(window.localStorage.getItem(testKey), JSON.stringify(testObj))
    # Test that something's written for `testKey` and that new emitters read it on init
    e2 = new StatefulEmitter(null, testKey)
    strictEqual(e2.get('foo'), testObj.foo)
    # Test that write operations change the storage
    e1.set('foo', 42)
    strictEqual(window.localStorage.getItem(testKey), JSON.stringify({ foo: 42}))

  # TODO: Test cross-browsing-context storage event. No idea if it works at all.

  test 'Fail when creating without state object and/or storage key', ->
    raises -> e = new StatefulEmitter('something')
    raises -> e = new StatefulEmitter(null, 'NOTHING_HERE')

  test 'Fail when triggering without value or with more than one value', ->
    e = new StatefulEmitter({ foo: 42 })
    raises -> e.trigger('foo')
    raises -> e.trigger('foo', 23, 42, 1337)