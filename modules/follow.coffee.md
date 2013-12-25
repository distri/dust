Follow
======

The `Follow` module provides a simple method to set an object's
velocity so that it is moving towards another object.

The calculated direction is based on the position of each object.

This method relies on both objects having the `position` method.

This module is included in `GameObject` by default.

>     player = GameObject
>       x: 50
>       y: 50
>       width: 10
>       height: 10
>
>     enemy = GameObject
>       x: 100
>       y: 50
>       width: 10
>       height: 10
>       velocity: Point(0, 0)
>       speed: 2
>
>     # Make an enemy follow the player
>     enemy.follow(player)

    {defaults} = require "../util"

    module.exports = (I={}, self) ->
      defaults I,
        velocity: Point(0, 0)
        speed: 1

`follow` sets the velocity of this object to follow another object.

The velocity is in the direction of the player, with magnitude equal to
this object's speed.

>     enemy.follow(player)

Call this in an `update` listener to always follow a target object.

>    self.on "update", ->
>      self.follow(player)

      self.extend
        follow: (obj) ->
          if obj
            I.velocity = obj.position().subtract(self.position()).norm(I.speed)
