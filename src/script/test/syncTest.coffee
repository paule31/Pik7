require ['../lib/sync'], (Sync) -> $(window).load ->

  QUnit.config.reorder = false;
  sync = new Sync
  otherWindow = document.getElementById('Testframe').contentWindow
  otherWindow[sync.storageKey].clear()
  defaults = {
    file: 'foo/bar.html'
    slide: 42
    hidden: true
  }

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