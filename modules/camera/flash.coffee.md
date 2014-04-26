Flash
=====

The `Flash` module allows you to flash a color onscreen and then fade to transparent over a time period.
This is nice for lightning type effects or to accentuate major game events.

    {approach, defaults} = require "../../util"

    module.exports = (I, self) ->
      defaults I,
        flashAlpha: 0
        flashColor: "black"
        flashDuration: 0.3
        flashCooldown: 0
        flashTargetAlpha: 0

      defaultParams =
        color: 'white'
        duration: 0.3
        targetAlpha: 0

      self.on 'afterUpdate', (dt) ->
        if I.flashCooldown > 0
          # TODO: Use a tween function alpha?
          I.flashAlpha = approach(I.flashAlpha, 0, dt / I.flashDuration)
          I.flashCooldown = approach(I.flashCooldown, 0, dt)

      self.on 'overlay', (canvas) ->
        # TODO: Canvas#withAlpha
        previousAlpha = canvas.globalAlpha()
        canvas.globalAlpha(I.flashAlpha)
        canvas.fill I.flashColor
        canvas.globalAlpha(previousAlpha)

      ###*
      A convenient way to set the flash effect instance variables. Alternatively, you can modify them by hand, but
      using Camera#flash is the suggested approach.

          camera.flash()
          # => Sets the flash effect variables to their default state. This will cause a white flash that will turn transparent in the next 12 frames.

          camera.flash
            color: 'green'
            duration: 30
          # => This flash effect will start off green and fade to transparent over 30 frames.

          camera.flash
            color: Color(255, 0, 0, 0)
            duration: 20
            targetAlpha: 1
          # => This flash effect will start off transparent and move toward red over 20 frames

      @name flash
      @methodOf Camera#
      @param {Color} [color="white"] The flash color
      @param {Number} [duration=12] How long the effect lasts
      @param {Number} [targetAlpha=0] The alpha value to fade to. By default, this is set to 0, which fades the color to transparent.
      ###
      flash: (options={}) ->
        defaults(options, defaultParams)

        {color, duration, targetAlpha} = options

        I.flashColor = Color(color)
        I.flashTargetAlpha = targetAlpha
        I.flashCooldown = duration
        I.flashDuration = duration

        self
