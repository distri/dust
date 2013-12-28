Keyboard
========

This module sets up the keyboard inputs for each engine update.

See also [Mouse](./mouse)

Usage
-----

The global `keydown` property lets your query the status of keys.

>     if keydown.left
>       moveLeft()
>
>     if keydown.a or keydown.space
>       attack()
>
>     if keydown.return
>       confirm()
>
>     if keydown.esc
>       cancel()

The global `justPressed` property lets your query the status of keys. However,
unlike keydown it will only trigger once for each time the key is pressed.

>     if justPressed.left
>       moveLeft()
>
>     if justPressed.a or justPressed.space
>       attack()
>
>     if justPressed.return
>       confirm()
>
>     if justPressed.esc
>       cancel()

Implementation
--------------

    window.keydown = {}
    window.justPressed = {}
    window.justReleased = {}

    prevKeysDown = {}

    keyName = (event) ->
      jQuery.hotkeys.specialKeys[event.which] ||
      String.fromCharCode(event.which).toLowerCase()

    $(document).bind "keydown", (event) ->
      key = keyName(event)
      keydown[key] = true

    $(document).bind "keyup", (event) ->
      key = keyName(event)
      keydown[key] = false

    updateKeys = () ->
      window.justPressed = {}
      window.justReleased = {}
      keydown.any = false

      for key, value of keydown
        justPressed[key] = value and !prevKeysDown[key]
        justReleased[key] = !value and prevKeysDown[key]

        justPressed.any = true if (justPressed[key] || mousePressed?.left || mousePressed?.right)
        keydown.any = true if (value || mouseDown?.left || mouseDown?.right)

      prevKeysDown = {}
      for key, value of keydown
        prevKeysDown[key] = value

    module.exports = (I={}, self) ->
      self.on "beforeUpdate", ->
        updateKeys()

      return self

TODO
----

- Get rid of jQuery dependency, consolidate with hotkeys lib
