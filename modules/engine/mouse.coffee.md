Mouse
=====

This module sets up the mouse inputs for each engine update.

See also [Keyboard](./keyboard)

Usage
-----

The global mouseDown property lets your query the status of mouse buttons.

>     if mouseDown.left
>       moveLeft()
>
>     if mouseDown.right
>       attack()

The global mousePressed property lets your query the status of mouse buttons.
However, unlike mouseDown it will only trigger the first time the button
pressed.

>     if mousePressed.left
>       moveLeft()
>
>     if mousePressed.right
>       attack()

Implementation
--------------

    window.mouseDown = {}
    window.mousePressed = {}
    window.mouseReleased = {}
    window.mousePosition = Point(0, 0)

    prevButtonsDown = {}

    buttonNames =
      1: "left"
      2: "middle"
      3: "right"

    buttonName = (event) ->
      buttonNames[event.which]

    $(document).bind "mousemove", (event) ->
      # Position relative to canvas element
      offset = $("canvas").offset() or {left: 0, top: 0}

      mousePosition.x = event.pageX - offset.left
      mousePosition.y = event.pageY - offset.top

      return

    $(document).bind "mousedown", (event) ->
      mouseDown[buttonName(event)] = true

      return

    $(document).bind "mouseup", (event) ->
      mouseDown[buttonName(event)] = false

      return

    window.updateMouse = ->
      window.mousePressed = {}
      window.mouseReleased = {}

      for button, value of mouseDown
        mousePressed[button] = value unless prevButtonsDown[button]

      for button, value of mouseDown
        mouseReleased[button] = !value if prevButtonsDown[button]

      prevButtonsDown = {}
      for button, value of mouseDown
        prevButtonsDown[button] = value

    module.exports = (I={}, self) ->
      self.on "beforeUpdate", ->
        updateMouse?()

      return self

TODO
----

- Integrate with TouchCanvas rather than global mouse handling
