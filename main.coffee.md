Main
====

[Engine](./engine)
[GameObject](./game_object)

Modules
-------

[Age](./modules/age)
[Bindable](./modules/bindable)
[Bounded](./modules/bounded)
[Clamp](./modules/clamp)
[Cooldown](./modules/cooldown)
[Drawable](./modules/drawable)
[Effect](./modules/effect)
[Expirable](./modules/expirable)
[Follow](./modules/follow)
[Meter](./modules/meter)
[Movable](./modules/movable)
[Rotatable](./modules/rotatable)
[Timed Events](./modules/timed_events)
[Tween](./modules/tween)

    require "./setup"

    TouchCanvas = require "touch-canvas"

    module.exports =
      init: (require) ->
        {width, height} = require "/pixie"

        canvas = TouchCanvas
          width: width
          height: height

        $("body").append $ "<div>",
          class: "main center"

        $(".main").append canvas.element()

        canvas.fill("orange")
