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
      init: (externalRequire) ->
        Engine = require "./engine"

        if externalRequire
          {width, height} = externalRequire "/pixie"

        canvas = TouchCanvas
          width: width
          height: height

        $("body").append $ "<div>",
          class: "main center"

        $(".main").append canvas.element()

        engine = Engine
          canvas: canvas

        engine.start()

        object = engine.add
          class: "GameObject"
          x: 100
          y: 100
          color: "red"
          width: 50
          height: 50
          speed: 30

        engine.on "update", ->
          if mousePosition?
            object.follow(mousePosition)

          if keydown.a
            engine.camera().transition()

    module.exports.init(require)
