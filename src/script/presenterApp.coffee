# Presenter view app

define ['app', 'jquery'], (App, $) ->

  return class PresenterApp extends App


    constructor: (defaults, options) ->
      super(defaults)
      @setOptions(options)


    #
    setOptions: (options) ->