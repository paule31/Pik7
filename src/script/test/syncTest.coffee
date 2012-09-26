require ['../lib/sync'], (Sync) ->

  sync = new Sync
  defaults = {
    file: 'foo/bar.html'
    slide: 42
    hidden: true
  }

  # Before running the tests, the browser's dom storage has to be wiped. To make sure that
  # the stoage event from the wiping operation doesn't interfere with the tests, the
  # actual tests, contained in `tests()` are fired only after this event has happend.

  tests = ->

    # Only trigger `tests()` once
    window.removeEventListener 'storage', tests

    test 'Trigger state events when the storage keys change', ->
      stop()
      sync.on 'change', (state) ->
        deepEqual state, defaults
        start()
      otherWindow[sync.storageKey].setItem 'pik', JSON.stringify defaults

    test 'Get values from the syncer', ->
      strictEqual sync.get('file'), defaults.file
      strictEqual sync.get('slide'), defaults.slide
      strictEqual sync.get('hidden'), defaults.hidden
      deepEqual sync.getState(), defaults

    test 'Test for storage events in the frame when using setters', ->
      stop()
      defaults = {
        file: 'bar/foo.html'
        slide: 1337
        hidden: false
      }
      otherWindow.onstorage = (evt) ->
        results = JSON.parse evt.newValue
        deepEqual results, defaults
        start()
      sync.setState defaults

    start()


  stop()
  window.addEventListener 'storage', tests, false
  otherWindow = document.getElementById('Testframe').contentWindow
  otherWindow[sync.storageKey].clear()