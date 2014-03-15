Camera
======

    Bindable = require "./bindable"
    {defaults} = require "../util"

    Camera = (I={}, self=Bindable(I)) ->

      defaults I,
        screen: # Screen Coordinates
          x: 0
          y: 0
          width: 1024
          height: 576
        deadzone: Point(0, 0) # Screen Coordinates
        zoom: 1
        transform: Matrix()
        velocity: Point(0, 0)
        maxSpeed: 750
        t90: 2 # Time in seconds for camera to move 90% of the way to the target

      # World Coordinates
      I.x ?= I.screen.width/2
      I.y ?= I.screen.height/2

      I.cameraBounds ?= I.screen

      currentType = "centered"
      currentObject = null

      objectFilters = []
      transformFilters = []

      focusOn = (object, elapsedTime) ->
        dampingFactor = 2

        #TODO: Different t90 value inside deadzone?

        c = elapsedTime * 3.75 / I.t90
        if c >= 1
          # Spring is configured to be too intense, just snap to target
          self.position(target)
          I.velocity = Point(0, 0)
        else
          objectCenter = object.center()

          target = objectCenter

          delta = target.subtract(self.position())

          force = delta.subtract(I.velocity.scale(dampingFactor))
          self.position(self.position().add(I.velocity.scale(c).clamp(I.maxSpeed)))
          I.velocity = I.velocity.add(force.scale(c))

      followTypes =
        centered: (object, elapsedTime) ->
          I.deadzone = Point(0, 0)

          focusOn(object, elapsedTime)

        topdown: (object, elapsedTime) ->
          helper = Math.max(I.screen.width, I.screen.height) / 4

          I.deadzone = Point(helper, helper)

          focusOn(object, elapsedTime)

        platformer: (object, elapsedTime) ->
          width = I.screen.width / 8
          height = I.screen.height / 3

          I.deadzone = Point(width, height)

          focusOn(object, elapsedTime)

      self.extend
        follow: (object, type="centered") ->
          currentObject = object
          currentType = type

        objectFilterChain: (fn) ->
          objectFilters.push fn

        transformFilterChain: (fn) ->
          transformFilters.push fn

        screenToWorld: (point) ->
          self.transform().inverse().transformPoint(point)

      self.attrAccessor "transform"

      self.on "afterUpdate", (elapsedTime) ->
        if currentObject
          followTypes[currentType](currentObject, elapsedTime)

        # Hard clamp camera to world bounds
        I.x = I.x.clamp(I.cameraBounds.x + I.screen.width/2, I.cameraBounds.x + I.cameraBounds.width - I.screen.width/2)
        I.y = I.y.clamp(I.cameraBounds.y + I.screen.height/2, I.cameraBounds.y + I.cameraBounds.height - I.screen.height/2)

        I.transform = Matrix.translate(I.screen.width/2 - I.x.floor(), I.screen.height/2 - I.y.floor())

      self.on "draw", (canvas, objects) ->
        # Move to correct screen coordinates
        canvas.withTransform Matrix.translate(I.screen.x, I.screen.y), (canvas) ->
          canvas.clip(0, 0, I.screen.width, I.screen.height)

          objects = objectFilters.pipeline(objects)
          transform = transformFilters.pipeline(self.transform().copy())

          canvas.withTransform transform, (canvas) ->
            self.trigger "beforeDraw", canvas
            objects.invoke "draw", canvas

      self.on "overlay", (canvas, objects) ->
        canvas.withTransform Matrix.translate(I.screen.x, I.screen.y), (canvas) ->
          canvas.clip(0, 0, I.screen.width, I.screen.height)
          objects = objectFilters.pipeline(objects)

          objects.invoke "trigger", "overlay", canvas

      self.include require "./age"
      self.include require "./bounded"

      # The order of theses includes is important for
      # the way in wich they modify the camera view transform

      for module in Camera.defaultModules
        self.include module

      return self

    Camera.defaultModules = [
      "z_sort"
      "shake"
      "zoom"
      "rotate"
      "flash"
      "fade"
      "transition"
    ].map (name) ->
      require "./camera/#{name}"

    module.exports = Camera
