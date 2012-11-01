# Very basic event emitter.
#
# 1. initialize with the topics that can be subscribed to (eg. `new Emitter('foo', 'bar')`)
# 2. add events using `on('topic', cb)`
# 3. trigger events with `trigger('topic', arg1, arg2...)` (callbacks are called with `null` for `this`)
#
# Events can be removed via `off('topic', cb)` or offAll('topic').

define ->
  return class Emitter

    constructor: (args...) ->
      @topics = {}
      @topics[topic] = [] for topic in args

    on: (topic, callback) ->
      if typeof callback != 'function'
        throw new Error "Can't add callback to '#{topic}', '#{callback}' is not a function"
      else if topic not of @topics
        throw new Error "Can't add callback, '#{topic}' is not a topic"
      else if callback in @topics[topic]
        throw new Error "Can't add callback, already subscribed to '#{topic}'"
      else
        @topics[topic].push(callback)

    off: (topic, callback) ->
      if typeof callback != 'function'
        throw new Error "Can't remove callback from '#{topic}', '#{callback}' is not a function"
      else if topic not of @topics
        throw new Error "Can't remove callback, no such topic: '#{topic}'"
      else if callback not in @topics[topic]
        throw new Error "Can't remove callback, not subscribed to '#{topic}'"
      else
        @topics[topic].splice(@topics[topic].indexOf(callback), 1)

    offAll: (topic) ->
      removeAllCallbacks = (list, target) ->
        if target of list
          list[target] = []
        else
          throw new Error "Can't remove callbacks from non-existant topic '#{target}'"
      if topic?
        removeAllCallbacks(@topics, topic)
      else
        removeAllCallbacks(@topics, target) for target of @topics

    trigger: (topic, args...) ->
      if topic not of @topics
        throw new Error "Can't trigger event, no such topic: '#{topic}'"
      else
        callback.apply(null, args) for callback in @topics[topic]