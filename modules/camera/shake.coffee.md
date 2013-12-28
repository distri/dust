Shake
=====

Adds screen shake to cameras.

    {approach, defaults} = require "../../util"

    module.exports = (I={}, self) ->
      defaults I,
        shakeIntensity: 20
        shakeCooldown: 0

      defaultParams =
        duration: 0.3
        intensity: 20

      self.on "afterUpdate", (dt) ->
        I.shakeCooldown = approach(I.shakeCooldown, 0, dt)

      self.transformFilterChain (transform) ->
        if I.shakeCooldown > 0
          transform.tx += Random.signed(I.shakeIntensity)
          transform.ty += Random.signed(I.shakeIntensity)

        return transform

      self.extend
        shake: (options={}) ->
          {duration, intensity} = defaults(options, defaultParams)

          I.shakeCooldown = duration
          I.shakeIntensity = intensity

          return self
