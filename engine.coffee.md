Engine
======

The Engine controls the game world and manages game state. Once you
set it up and let it run it pretty much takes care of itself.

You can use the engine to add or remove objects from the game world.

There are several modules that can include to add additional capabilities
to the engine.

Events
------

The engine fires events that you  may bind listeners to. Event listeners
may be bound with `engine.on(eventName, callback)`

`beforeAdd` Observe or modify the entity data before it is added to the engine.

@param {Object} entityData

`afterAdd` Observe or configure a `GameObject` that has been added to the engine.

@param {GameObject} object The object that has just been added to the engine.

`update` Called when the engine updates all the game objects.

@param {Number} elapsedTime The time in seconds that has elapsed since the last update.

`afterUpdate` Called after the engine completes an update.

`beforeDraw` is called before the engine draws the game objects on the canvas. 
The current camera transform is applied.

@params {PixieCanvas} canvas A reference to the canvas to draw on.

`draw` is called after the engine draws on the canvas. The current camera transform is applied.

@params {PixieCanvas} canvas A reference to the canvas to draw on.

>     engine.bind "draw", (canvas) ->
>       # print some directions for the player
>       canvas.drawText
>         text: "Go this way =>"
>         x: 200
>         y: 200
  
`draw` is called after the engine draws.
  
The current camera transform is not applied. This is great for
adding overlays.

@params {PixieCanvas} canvas A reference to the canvas to draw on.

>     engine.bind "overlay", (canvas) ->
>       # print the player's health. This will be
>       # positioned absolutely according to the viewport.
>       canvas.drawText
>         text: "HEALTH:"
>         position: Point(20, 20)
>
>       canvas.drawText
>         text: player.health()
>         position: Point(50, 20)

Implementation
--------------

    {defaults} = require "./util"
    Bindable = require "./modules/bindable"

    Engine = (I={}, self=Bindable(I)) ->
      defaults I,
        FPS: 60
        paused: false
  
      frameAdvance = false
  
      running = false
      startTime = +new Date()
      lastStepTime = -Infinity
      animLoop = (timestamp) ->
        timestamp ||= +new Date()
        msPerFrame = (1000 / I.FPS)
  
        delta = timestamp - lastStepTime
        remainder = delta - msPerFrame
  
        if remainder > 0
          lastStepTime = timestamp - Math.min(remainder, msPerFrame)
          step()
  
        if running
          window.requestAnimationFrame(animLoop)
  
      update = (elapsedTime) ->
        self.trigger "beforeUpdate", elapsedTime
        self.trigger "update", elapsedTime
        self.trigger "afterUpdate", elapsedTime
  
      draw = ->
        return unless canvas = I.canvas
  
        self.trigger "beforeDraw", canvas
        self.trigger "draw", canvas
        self.trigger "overlay", canvas
  
      step = ->
        if !I.paused || frameAdvance
          elapsedTime = (1 / I.FPS)
          update(elapsedTime)
  
        draw()
  
      self.extend
        ###*
        Start the game simulation.
  
            engine.start()
  
        @methodOf Engine#
        @name start
        ###
        start: ->
          unless running
            running = true
            window.requestAnimationFrame(animLoop)
  
        ###*
        Stop the simulation.
  
            engine.stop()
  
        @methodOf Engine#
        @name stop
        ###
        stop: ->
          running = false
  
        ###*
        Pause the game and step through 1 update of the engine.
  
            engine.frameAdvance()
  
        @methodOf Engine#
        @name frameAdvance
        ###
        frameAdvance: ->
          I.paused = true
          frameAdvance = true
          step()
          frameAdvance = false
  
        ###*
        Resume the game.
  
            engine.play()
  
        @methodOf Engine#
        @name play
        ###
        play: ->
          I.paused = false
  
        ###*
        Toggle the paused state of the simulation.
  
            engine.pause()
  
        @methodOf Engine#
        @name pause
        @param {Boolean} [setTo] Force to pause by passing true or unpause by passing false.
        ###
        pause: (setTo) ->
          if setTo?
            I.paused = setTo
          else
            I.paused = !I.paused
  
        ###*
        Query the engine to see if it is paused.
  
            engine.pause()
  
            engine.paused()
            # true
  
            engine.play()
  
            engine.paused()
            # false
  
        @methodOf Engine#
        @name paused
        ###
        paused: ->
          I.paused
  
        ###*
        Change the framerate of the game. The default framerate is 60 fps.
  
            engine.setFramerate(60)
  
        @methodOf Engine#
        @name setFramerate
        ###
        setFramerate: (newFPS) ->
          I.FPS = newFPS
          self.stop()
          self.start()
  
        update: update
        draw: draw

      self.include require("./modules/age")

      Engine.defaultModules.each (module) ->
        self.include module

      self.trigger "init"
  
      return self

    Engine.defaultModules = [
      
    ].map ->

TODO: 

Include these modules

"Data"
"Keyboard"
"Mouse"
"Background"
"Delay"
"GameState"
"Selector"
"Collision"
"Tilemap"
"Levels"

    module.exports = Engine
