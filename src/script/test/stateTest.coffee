require ['lib/state'], (State) ->

  defaults = {
    file: 'foo/bar.htm'
    slide: 23
    hidden: no
    numSlides: 42
  }

  test 'Throw when attempting to init with incomplete defaults', ->
    raises -> new State { file: 'asdf', slide: 42, hidden: yes }

  test 'Throw when attempting to init with phoney default values', ->
    raises -> new State { file: 'asdf', slide: 42, hidden: undefined, numSlides: 1337 }

  test 'Init and getters', ->
    state = new State defaults
    strictEqual state.get('file'), defaults.file
    strictEqual state.get('slide'), defaults.slide
    strictEqual state.get('hidden'), defaults.hidden
    strictEqual state.get('numSlides'), defaults.numSlides

  test 'Regular setters', ->
    expected = {
      file: 'narf/moo.htm'
      slide: 12
      hidden: yes
    }
    state = new State defaults
    state.set { file: expected.file }
    state.set { slide: expected.slide }
    state.set { hidden: expected.hidden }
    strictEqual state.get('file'), expected.file
    strictEqual state.get('slide'), expected.slide
    strictEqual state.get('hidden'), expected.hidden

  test 'Limit valid slide number ranges', ->
    state = new State defaults
    state.set { slide: -1 }
    strictEqual state.get('slide'), 0
    state.set { slide: 9000 }
    strictEqual state.get('slide'), defaults.numSlides - 1

  test 'Throw when attempting to change numSlides', ->
    state = new State defaults
    raises -> state.set { numSlides: 1337 }