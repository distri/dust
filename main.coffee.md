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

    Engine = require "./engine"

    TouchCanvas = require "touch-canvas"

    applyStyleSheet = ->
      styleNode = document.createElement("style")
      styleNode.innerHTML = require "./style"
      styleNode.className = "dust"

      if previousStyleNode = document.head.querySelector("style.dust")
        previousStyleNode.parentNode.removeChild(prevousStyleNode)

      document.head.appendChild(styleNode)

    module.exports =
      init: (options={}) ->
        applyStyleSheet()

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

        engine = Engine
          canvas: canvas

        engine.start()

        return engine

      Engine: Engine
      GameObject: require "./game_object"
      GameState: require "./game_state"
      Sprite: require "sprite"
      Util: require "./util"
