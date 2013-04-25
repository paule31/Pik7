# Iframe
# ======

# Controls one frame from the outside, abstracting away the manual handling of
# load and control events.

define ['lib/emitter', 'jquery'], (Emitter, $) -> return class Iframe extends Emitter


  # Store frame and window references, call `super` from the Emitter class and
  # kick off the init process
  constructor: (frame) ->
    @frame = $(frame).first()
    if @frame.length == 0 then throw new Error "Iframe error: frame #{frame} not found"
    @window = @frame[0].contentWindow
    super('load')
    @initFrame()


  # Dispatch load events in the frame to self
  initFrame: ->
    @frame.load =>
      # Some web servers like the static node server don't treat relative urls
      # right if the refering page's url is a directory without a closing slash
      # (eg. `/presentations/Pik`). To help with this we add a closing slash to
      # all paths that might need one.
      href = @window.location.href
      isPresentation = typeof @window.Pik != 'undefined'
      hasFileName = href.lastIndexOf('.') != -1
      hasClosingSlash = href[href.length - 1] == '/'
      if hasFileName || hasClosingSlash
        @trigger('load', @window.location.href) if @window.Pik?
      else
        if isPresentation
          @do('file', href += '/')


  # Trigger `action` with `arg` on the frames `Pik` object
  do: (action, arg) ->
    if action == 'file'
      @window.location.href = arg if arg != @window.location.toString()
    else if @window.Pik?
      if action == 'slide'
        @window.Pik.goTo(arg)
      if action == 'hidden'
        @window.Pik.setHidden(arg)


  getNumSlides: -> @window.Pik.numSlides if @window.Pik?