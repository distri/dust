Flash
=====

The `Flash` module allows you to flash a color onscreen and then fade to transparent over a time period.
This is nice for lightning type effects or to accentuate major game events.

    {approach, defaults} = require "../../util"

    module.exports = (I, self) ->
      defaults I,
        flashAlpha: 0
        flashColor: "black"
        flashStart: 0
        flashEnd: 0

      defaultParams =
        color: 'white'
        duration: 0.3

      t = ->
        ((I.age - I.flashStart) / (I.flashEnd - I.flashStart)).clamp(0, 1)

      self.on 'afterUpdate', (dt) -> 
        I.flashAlpha = 1 - t()

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
          # => This flash effect will start off transparent and move toward red over 20 frames

      @name flash
      @methodOf Camera#
      @param {Color} [color="white"] The flash color
      @param {Number} [duration=12] How long the effect lasts
      ###
      self.extend
        flash: (options={}) ->
          defaults(options, defaultParams)
  
          {color, duration} = options

          I.flashColor = color
          I.flashStart = I.age
          I.flashEnd = I.flashStart + duration

          self
