Effect
======

A collection of effects to make your game juicy.

It is included in `GameObject` by default.

    module.exports = (I={}, self) ->

`fadeOut` provides a convenient way to fade out this object over time.

Time to fade out in seconds. The optional second prameter is the function to
execute when fade out completes.

Fade the player object out over the next 2 seconds.

>     player.fadeOut 2

Fade out and then destroy.

>     player.fadeOut, 0.25, ->
>       self.destroy()

      self.extend
        fadeOut: (duration=1, complete) ->
          self.tween duration,
            alpha: 0
            complete: complete
