require ['lib/controller', 'lib/polyfill/bind'], (Controller) ->

  c = null
  defaults = {
    file: 'core/welcome.html'
    slide: 0
    hidden: no
    numSlides: 1
  }

  module('Controller', {
    setup: ->
      c?.offAll()
      c = null
      window.localStorage.clear()
      window.location.hash = ''
  })

  test 'Init and getters', ->
    c = new Controller(defaults)
    equal(c.getFile(), defaults.file)
    equal(c.getSlide(), defaults.slide)
    equal(c.getHidden(), defaults.hidden)

  # test 'Setters', ->


  # Changes to the hash trigger
  # 1. Sync
  # 2. External listeners
  #test 'Change hash', ->
  #  c = new Controller(defaults)


  # Changes to sync trigger
  # 1. Hash
  # 2. External listeners


  # Control events trigger
  # 1. Hash
  # 2. Sync
  # 3. External listeners