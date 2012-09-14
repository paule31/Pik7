require ['../lib/hash'], (Hash) ->
  'use strict'

  hash = new Hash

  examples = {
    'http://foo.org/index.html#!/index/index.html@1':                ['index/index.html', 1, false]
    'localhost://#!presentations/HTML5/05_Formulare.html@37!hidden': ['presentations/HTML5/05_Formulare.html', 37, true]
    'http://www.foo.de/some/dir#!/presentations/Pik6Vorstellung@14': ['presentations/Pik6Vorstellung', 14, false]
    'file:///home/user/moo.html#!Pik6Vorstellung@11!hidden':         ['Pik6Vorstellung', 11, true]
  }

  test 'Parse URLs', ->
    for url, expected of examples
      parsed = hash.parse url
      deepEqual parsed, {
        file: expected[0]
        slide: expected[1]
        hidden: expected[2]
      }

  test 'Create hashes', ->
    for url, values of examples
      expectedHash = url.split('#').pop()
      if expectedHash[1] != '/' then expectedHash = '!/' + expectedHash.substr(1) # Ignore slash inconstistencies
      builtHash = hash.createHash.apply null, values
      equal expectedHash, builtHash

  test 'Hashchange event', ->
    stop Object.keys(examples).length
    hash.on 'change', (data) ->
      ok 1 # TODO: check for correct values (`data`)
      start()
    for url, expected of examples
      newHash = hash.createHash expected...
      window.location.hash = newHash