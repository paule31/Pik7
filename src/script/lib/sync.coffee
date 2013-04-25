# Sync
# ====

# Provides an event api to keep multiple browsing contexts in sync using local
# storage. The library detects changes to local storage in other windows and
# triggers the associated events.
define ['lib/emitter'], (Emitter) -> return class Syncer extends Emitter


  # Note: using `window.sessionStorage` doesn't work in all browsers because
  # storage events don't get triggered
  constructor: (@storageArea = window.localStorage) ->
    @validKeys = [ 'file', 'slide', 'hidden' ]
    super('change')
    @initEvents()
    @storageKey = if @storageArea == window.localStorage
      'localStorage'
    else
      'sessionStorage'


  # Trigger events on the syncer if the storage changes
  initEvents: ->
    @onStorage = (evt) =>
      values = evt.newValue
      if values
        state = JSON.parse(values)
        @trigger('change', state, evt)
    window.addEventListener('storage', @onStorage, false)


  # Expected/returned state object format:
  # `{ String file, Number slide, Boolean hidden }`
  setState: (state) ->
    values = JSON.stringify(state)
    if values
      @storageArea.setItem('pik', values)
  getState: () ->
    values = @storageArea.getItem 'pik'
    return JSON.parse(values)


  # Note: `get()` and `set()` are pure sugar and don't really just write und
  # read individual properties

  set: (key, value) ->
    if key not in @validKeys
      throw new Error "Can't set #{key}; not a valid key for storage"
    state = @getState()
    state[key] = value
    @setState(state)

  get: (key) ->
    if key not in @validKeys
      throw new Error "Can't get #{key} from storage; not a valid key"
    state = @getState()
    return switch key
      when 'file' then state.file
      when 'slide' then Number state.slide
      when 'hidden' then /^true$/i.test state.hidden


  # Remove all stored data
  wipe: -> @storageArea.removeItem('pik')


  # Don't forget to clear the storage when offing the emitter
  offAll: ->
    super()
    @wipe()