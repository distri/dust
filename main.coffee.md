Main
====

[Engine](./engine)
[GameObject](./game_object)

Modules
-------

- [Age](./modules/age)
- [Bindable](./modules/bindable)
- [Bounded](./modules/bounded)
- [Clamp](./modules/clamp)
- [Cooldown](./modules/cooldown)
- [Drawable](./modules/drawable)
- [Effect](./modules/effect)
- [Expirable](./modules/expirable)
- [Follow](./modules/follow)
- [Meter](./modules/meter)
- [Movable](./modules/movable)
- [Rotatable](./modules/rotatable)
- [Timed Events](./modules/timed_events)
- [Tween](./modules/tween)

    require "./setup"

    Engine = require "./engine"

    TouchCanvas = require "touch-canvas"

    {applyStylesheet, extend} = require "./util"

    module.exports =
      init: (options={}) ->
        applyStylesheet(require("./style"), "dust")

        {width, height} = options
        width ?= 640
        height ?= 480

        canvas = TouchCanvas
          width: width
          height: height

        $("body").append $ "<div>",
          class: "main center"

        $(".main").append(canvas.element())
        .css
          width: width
          height: height

        engine = Engine extend
          canvas: canvas
        , options

        engine.start()

        return engine

      Collision: require "/lib/collision"
      Engine: Engine
      GameObject: require "./game_object"
      GameState: require "./game_state"
      Resource: require "resource"
      Util: require "./util"

    # Demo game
    if PACKAGE.name is "ROOT"
      engine = module.exports.init()

      x = 320
      y = 460

      bullets = []

      engine.bind "update", ->
        if keydown.left
          x -= 5

        if keydown.right
          x += 5

        if keydown.space
          bullets.push
            x: x
            y: y
        
        bullets.forEach (b) ->
          b.y -= 10

        bullets = bullets.filter ({y}) ->
          y > -10

      engine.bind "draw", (canvas) ->
        canvas.drawCircle
          x: x
          y: y
          color: "blue"
          radius: 5

        bullets.forEach ({x, y}) ->
          canvas.drawCircle
            x: x
            y: y
            color: "white"
            radius: 2
