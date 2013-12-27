Background
==========

This module clears or fills the canvas before drawing the scene. It also provides
support for drawing a sprite background.

It is included in Engine by default.

    {defaults} = require "../../util"

    module.exports = (I, self) ->
      defaults I,
        background: null
        backgroundColor: "#00010D"
        clear: false
    
      self.attrAccessor "clear", "backgroundColor"
      
      backgroundSprite = ->
        if I.background
          Sprite.loadByName I.background

      self.on "beforeDraw", ->
        if I.clear
          I.canvas.clear()
        else if sprite = backgroundSprite()
          sprite.fill(I.canvas, 0, 0, I.canvas.width(), I.canvas.height())
        else if I.backgroundColor
          I.canvas.fill(I.backgroundColor)

      return self
