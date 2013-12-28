Zoom
====

Adds zoom in and out to cameras.

Included in [Camera](../camera) by default.

    {defaults} = require "../../util"

    module.exports = (I={}, self) ->
      defaults I,
        maxZoom: 10
        minZoom: 0.1
        zoom: 1

      self.attrAccessor "zoom"

      self.transformFilterChain (transform) ->
        transform.scale(I.zoom, I.zoom, self.position())

      clampZoom = (value) ->
        value.clamp(I.minZoom, I.maxZoom) 

      self.extend
        zoomIn: (percentage) ->
          self.zoom clampZoom(I.zoom * (1 + percentage)) 

        zoomOut: (percentage) ->
          self.zoom clampZoom(I.zoom * (1 - percentage))
