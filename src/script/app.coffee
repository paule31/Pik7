define ['lib/controller', 'lib/iframe'], (Controller, Iframe) ->

  return class App

    constructor: ->
      @iframe = new Iframe 'iframe'
