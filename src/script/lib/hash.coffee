# Hash
# ====

# Parses URLs and creates hashes for presentation frame windows.
define ['lib/emitter'], (Emitter) -> return class Hash extends Emitter


  # The default format format looks like `#!/path/to/file.html@42!hidden`
  # where...
  # 1. `/path/to/file.html` is the current presentation
  # 2. `@42` indicates the current slide
  # 3. the string `!hidden`, if present in the hash, indicates that the
  #    presentation is in the hidden state
  constructor: (@format = /(?:#!\/?(.*)@([0-9]*)(!hidden)?)/) ->
    super 'change'
    @addEvents()


  # Adds the `@hashchange` function to the window's `hashchange` event. Called
  # automatically when constructing a new instance
  addEvents: -> window.addEventListener('hashchange', @onchange, false)


  # The callback that's added to the window's `hashchange` event when a new
  # Hash instance created.
  onchange: (evt) =>
    data = @parse(evt.newURL)
    @trigger('change', data, evt) if data?


  # Parses a url, returns an object with the state information contained in
  # the url. Format: `{ String file, Number slide, Boolean hidden }`
  # Note: slide numbers are the *actual* slide numbers, not the array index
  # (first slide = 1)
  parse: (url) ->
    parsed = @format.exec url
    if parsed
      file = parsed[1] || null unless parsed[1] == 'undefined'
      slide = Number(parsed[2]) - 1 unless !parsed[2]
      hidden = if parsed[3] == '!hidden' then true else false
      return { file, slide, hidden }


  # Calculate the common path of two urls. Stolen from
  # http://medialize.github.com/URI.js/
  commonPath: (a, b) ->
    pos = 0
    while pos < Math.min(a.length, b.length)
      if a[pos] != b[pos] then break
      pos++
    if pos < 1
      return a[0] == b[0] && a[0] == '/' ? '/' : ''
    if a[pos] != '/'
      pos = a.substring(0, pos).lastIndexOf('/')
    return a.substring(0, pos + 1)


  # Creates a new hash (without pound sign) from state information (`file`,
  # `slide` `hidden`). Note: slide numbers are the *actual* slide numbers, not
  # the array index (first slide = 1)
  createHash: (file, slide, hidden) ->
    file   = String(file)
    slide  = (Number(slide) + 1).toString()
    hidden = Boolean(hidden)
    hash  = '!'
    hash += '/' if file[0] != '/'
    hash += file
    hash += '@'
    hash += slide
    if hidden == true then hash += '!hidden'
    return hash


  # Do a full hash replacement from the supplied state information
  set: (file, slide, hidden) ->
    window.location.hash = @createHash(file, slide, hidden)


  # Do a partial hash update from the supplied state information
  update: (key, value, defaults) ->
    parsed = @parse(window.location.hash) || defaults
    parsed[key] = value
    @set(parsed.file, parsed.slide, parsed.hidden)


  # Overload the basic emitter's `offAll()` the remove the `hashchange` event
  # from window along with all the emitter's events.
  offAll: () ->
    window.removeEventListener('hashchange', @onchange, false)
    window.location.hash = ''
    super()