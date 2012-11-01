# Produces a function that can be used to force an aspect ration upon a dom node. In most
# cases the function should be used once after it's creation and then every time the
# container changes size.

define ['jquery'], ($) ->

  return (ratio, element, container = 'html', topMargin = true, fontSize = true, topMarginProperty = 'top') ->

    return ->

      size = {
        x: $(container).width()
        y: $(container).height()
      }
      newwidth  = Math.floor(if size.x > size.y * ratio then size.y * ratio else size.x)
      newheight = Math.floor(if size.x > size.y * ratio then size.y else size.x / ratio)

      styles = {
        'width'     : "#{newwidth}px"
        'height'    : "#{newheight}px"
      }

      if topMargin
        topmargin = Math.floor((size.y - newheight) / 2)
        styles[topMarginProperty] = "#{topmargin}px"

      if fontSize
        fontsize  = (newheight + newwidth) / 6.5
        styles['font-size'] = "#{fontsize}%"

      $(element).css(styles)