require ['lib/sync'], (Sync) ->

  QUnit.config.reorder = false

  otherWindow = document.getElementById('Testframe').contentWindow
  sync = new Sync()
  defaults = {
    file: 'foo/bar.html'
    slide: 42
    hidden: true
  }
  setup = ->
    setTimeout ->
      window[sync.storageKey].clear()
    , 250

  module('Syncer', { setup })

  asyncTest 'Trigger state events when the storage keys change', ->
    sync.on 'change', (state) ->
      deepEqual(state, defaults)
      start()
    otherWindow[sync.storageKey].setItem('pik', JSON.stringify(defaults))

  test 'Set state, get values from the syncer', ->
    sync.setState(defaults)
    strictEqual sync.get('file'), defaults.file
    strictEqual sync.get('slide'), defaults.slide
    strictEqual sync.get('hidden'), defaults.hidden
    deepEqual(sync.getState(), defaults)

  asyncTest 'Test for storage events in the frame when using setters', ->
    changed = {
      file: 'bar/foo.html'
      slide: 1337
      hidden: false
    }
    otherWindow.onstorage = (evt) ->
      if evt.newValue?
        results = JSON.parse(evt.newValue)
        deepEqual(results, changed)
        start()
    sync.setState(changed)