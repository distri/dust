Fade
====

The `Fade` module provides convenience methods for accessing common Engine.Flash presets.

Camera Effects
--------------
[Flash](./flash)

    {defaults} = require "../../util"

    module.exports = (I={}, self) ->
      fadeInDefaults =
        alpha: 0
        color: 'black'
        duration: 30

      fadeOutDefaults =
        alpha: 1
        color: 'transparent'
        duration: 30

      configureFade = (duration, color, alpha) ->
        I.flashDuration = duration
        I.flashCooldown = duration
        I.flashColor = Color(color)
        I.flashTargetAlpha = alpha

      self.extend

Methods
-------

`fadeIn` provides a convenient way to set the flash effect instance variables. This provides a shorthand for fading the screen in
from a given color over a specified duration.

>     engine.fadeIn()
>     # => Sets the effect variables to their default state. This will the screen to go from black to transparent over the next 30 frames.
>
>     engine.fadeIn('blue', 50)
>     # => This effect will start off blue and fade to transparent over 50 frames.

@param {Number} [duration=30] How long the effect lasts
@param {Color} [color="black"] The color to fade from

        fadeIn: (options={}) ->
          {alpha, color, duration} = defaults(options, fadeInDefaults)

          configureFade(duration, color, alpha)

`fadeOut` provides convenient way to set the flash effect instance variables. This provides a shorthand for fading
the screen to a given color over a specified duration.

>     camera.fadeOut()
>     # => Sets the effect variables to their default state. This will the screen to fade from ransparent to black over the next 30 frames.
>
>     camera.fadeOut
>       color: blue
>       duration: 30
>     # => This effect will start off transparent and change to blue over 50 frames.

@param {Number} [duration=30] How long the effect lasts
@param {Color} [color="transparent"] The color to fade to

        fadeOut: (options={}) ->
          {alpha, color, duration} = defaults(options, fadeOutDefaults)

          configureFade(duration, color, alpha)
