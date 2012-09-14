# Parses URLs and creates hashes
#
# Format (visible): #!/path/to/file.html@42
# Format (hidden):  #!/path/to/file.html@42!hidden

define ['lib/emitter'], (Emitter) ->
  'use strict'

  return class Hash extends Emitter

    #
    constructor: (@format = /(?:#!\/?(.*)@([0-9]*)(!hidden)?)/) ->
      super 'change'
      @addEvents()

    #
    onchange: (evt) =>
      data = @parse evt.newURL
      @trigger 'change', data, evt if data?

    #
    addEvents: ->
      window.addEventListener 'hashchange', @onchange, false

    #
    parse: (url) ->
      parsed = @format.exec url
      if parsed
        file = parsed[1] || null unless parsed[1] == 'undefined'
        slide = Number parsed[2] unless !parsed[2]
        hidden = if parsed[3] == '!hidden' then true else false
        return { file, slide, hidden }

    #
    createHash: (file, slide, hidden) ->
      file   = String file
      slide  = Number(slide).toString()
      hidden = Boolean hidden
      hash  = '!'
      hash += '/' if file[0] != '/'
      hash += file
      hash += '@'
      hash += slide
      if hidden == true then hash += '!hidden'
      return hash

    # Do a full hash replacement
    set: (args...) ->
      window.location.hash = @createHash args...

    # Do a partial hash update
    update: (key, value, defaults) ->
      parsed = @parse(window.location.hash) || defaults
      parsed[key] = value
      @set parsed.file, parsed.slide, parsed.hidden

    #
    offAll: () ->
      window.removeEventListener 'hashchange', @onchange, false
      window.location.hash = ''
      super()