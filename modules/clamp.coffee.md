Clamp
=====

The `Clamp` module provides helper methods to clamp object properties. 

This module is included by default in `GameObject`

    Bindable = require "./bindable"
    {defaults, extend} = require "../util"

    module.exports = (I={}, self=Bindable(I)) ->
      defaults I,
        clampData: {}

      self.on "afterUpdate", ->
        for property, data of I.clampData
          I[property] = I[property].clamp(data.min, data.max)
    

      self.extend

`clamp` keeps an object's attributes within a given range.

Example: Player's health will be within [0, 100] at the end of every update

>     player.clamp
>       health:
>         min: 0
>         max: 100

Example: Score can only be positive

>     player.clamp
>       score:
>         min: 0
  
        clamp: (data) ->
          extend(I.clampData, data)

Helper to clamp the `x` and `y` properties of the object to be within a given bounds.

        clampToBounds: (bounds) ->
          bounds ||= Rectangle x: 0, y: 0, width: App.width, height: App.height
  
          self.clamp
            x:
              min: bounds.x + I.width/2
              max: bounds.width - I.width/2
            y:
              min: bounds.y + I.height/2
              max: bounds.height - I.height/2
