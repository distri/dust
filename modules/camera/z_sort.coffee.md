ZSort
=====

Sort objects by zIndex.

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
