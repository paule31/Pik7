# Smart Emitters are used to connect many other emitters. Their `on()` and `trigger()`
# methods take an additional argument that identifies the emitter that is listening for
# or triggering events. This allows the Smart Emitter to not propagate events back to
# the objects that triggered them in the first place.

define ['lib/emitter'], (Emitter) ->

  compareArrays = (a, b) ->
    a.sort()
    b.sort()
    return false if a.length != b.length
    return false for val, idx in a when val != b[idx]
    return true

  class SmartEmitter extends Emitter

    # Add the callbacks to the topics and add the `__subscriber__` property
    # *afterwards*. This order allows `__super__.on` to deal with non-function
    # values for `callback` before any properties are added.
    on: (topic, subscriber, callback) ->
      super topic, callback
      callback.__subscriber__ = subscriber if subscriber?

    # Trigger all callbacks for the given topic if the callback's `__subscriber__`
    # property isn't equal to `caller`
    trigger: (topic, caller, args...) ->
      if caller?
        topics = {}
        for _topic, callbacks of @topics
          topics[_topic] = (cb for cb in callbacks when cb.__subscriber__ != caller)
      else
        topics = @topics
      args.unshift(topic)
      SmartEmitter.__super__.trigger.apply { topics }, args

    # Let this Smart Emitter listen on all events on another Emitter. The other
    # Emitter must have the exact same topics as the Smart Emitter vor this to work.
    onAll: (other) ->
      ownTopics = Object.keys(@topics)
      otherTopics = Object.keys(other.topics)
      if not compareArrays ownTopics, otherTopics
        throw new Error "Can't connect emitters; incompatible topic lists: [#{ownTopics}] and [#{otherTopics}]"
      self = this
      for topic, callbacks of @topics
        other.on topic, (args...) -> self.trigger topic, other, args...