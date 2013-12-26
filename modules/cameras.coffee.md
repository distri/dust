Cameras
=======

The Cameras module is included in `GameState` by default.

    Bindable = require "./bindable"
    Camera = require "./camera"

    module.exports = (I={}, self=Bindable()) ->
      cameras = [Camera()]
    
      self.on 'update', (elapsedTime) ->
        self.cameras().invoke 'trigger', 'update', elapsedTime
    
      self.on 'afterUpdate', (elapsedTime) ->
        self.cameras().invoke 'trigger', 'afterUpdate', elapsedTime
    
      self.on 'draw', (canvas) ->
        self.cameras().invoke 'trigger', 'draw', canvas, self.objects()
    
      self.on 'overlay', (canvas) ->
        self.cameras().invoke 'trigger', 'overlay', canvas, self.objects()
    
      self.extend
        addCamera: (data) ->
          cameras.push(Camera(data))

Returns the array of camera objects or sets them if an argument is passed in.

        cameras: (newCameras) ->
          if newCameras
            cameras = newCameras

            return self
          else
            return cameras
