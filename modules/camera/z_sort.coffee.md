ZSort
=====

Sort objects by zIndex to draw them in the correct order.

Included in [Camera](../camera) by default.

    {defaults} = require "../../util"

    module.exports = (I={}, self) ->
      defaults I,
        zSort: true

      self.objectFilterChain (objects) ->
        if I.zSort
          objects.sort (a, b) ->
            a.I.zIndex - b.I.zIndex

        objects

      return self
