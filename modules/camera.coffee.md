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
        zoom: 1
        transform: Matrix()

      # World Coordinates
      I.x ?= I.screen.width/2
      I.y ?= I.screen.height/2

      objectFilters = []
      transformFilters = []

      self.extend
        objectFilterChain: (fn) ->
          objectFilters.push fn

        transformFilterChain: (fn) ->
          transformFilters.push fn

        screenToWorld: (point) ->
          self.transform().inverse().transformPoint(point)

      self.attrAccessor "transform"

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
      "fade"
      "flash"
      "transition"
    ].map (name) ->
      require "./camera/#{name}"

    module.exports = Camera
