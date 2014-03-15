Finder
======

    Finder = require "finder"

    module.exports = (I={}, self) ->
      finder = Finder()

      self.extend
        find: (selector) ->
          finder.find self.objects(), selector

        first: (selector) ->
          self.find(selector).first()
