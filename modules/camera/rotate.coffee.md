Rotate
======

Add rotation to cameras.

Included in [Camera](../camera) by default.

    {defaults} = require "../../util"

    module.exports = (I, self) ->
      defaults I,
        rotation: 0

      self.transformFilterChain (transform) ->
        transform.rotate(I.rotation, self.position())

      self.attrAccessor "rotation"

      self.extend
        rotate: (amount) ->
          self.rotation(I.rotation + amount)
