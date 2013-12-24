Expirable
=========

The Expirable module deactivates a `GameObject` after a specified duration.

The duration is specified in seconds. If -1 is
specified the object will have an unlimited duration.

This module is included by default in `GameObject`.

>     enemy = GameObject
>       duration: 5
>
>     enemy.include Expirable
>
>     enemy.I.active
>     # => true
>
>     5.times ->
>       enemy.update(1)
>
>     enemy.I.active
>     # => false

    Bindable = require "./bindable"
    {defaults} = require "../util"

    module.exports = (I={}, self=Bindable(I)) ->
      defaults I,
        duration: -1

      self.on "update", (dt) ->
        if I.duration != -1 && I.age >= I.duration
          I.active = false

      return self
