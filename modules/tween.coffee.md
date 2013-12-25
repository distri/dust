Tween
=====

The `Tween` module provides a method to tween object properties.

    {defaults, extend} = require "../util"

    Easing = require "../lib/easing"

    module.exports = (I={}, self) ->
      defaults I,
        activeTweens: {}

      self.on "update", (elapsedTime) ->
        t = I.age + elapsedTime

        for property, data of I.activeTweens
          {start, end, startTime, endTime, duration, easing} = data

          delta = end - start

          if t >= endTime
            I[property] = end
            I.activeTweens[property].complete?()
            delete I.activeTweens[property]
          else
            if typeof easing is "string"
              easingFunction = Easing[easing]
            else
              easingFunction = easing

            I[property] = start + delta * easingFunction((t - startTime) / duration)

Modify the object's properties over time.

Duration How long (in frames) until the object's properties reach their final values.
The second prameter is which properties to tween. 

Set the `easing` property to specify the easing function.

>     player.tween 3,
>       x: 50
>       y: 50
>       easing: "quadratic"

>     player.tween 3,
>       x: 150
>       y: 150
>       complete: ->
>         player.dance()

      self.extend
        tween: (duration, properties) ->
          properties = extend({}, properties) # Make a local copy

          easing = properties.easing || "linear"
          complete = properties.complete

          delete properties.easing
          delete properties.complete

          for property, target of properties
            I.activeTweens[property] =
              complete: complete
              end: target
              start: I[property]
              easing: easing
              duration: duration
              startTime: I.age
              endTime: I.age + duration
