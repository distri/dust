Bounded
=======

TODO: Maybe rename this Geometry?

    Collision = require "../lib/collision"

The Bounded module is used to provide basic data about the
location and dimensions of the including object. This module is included
by default in `GameObject`.

>     player = GameObject
>       x: 10
>       y: 50
>       width: 20
>       height: 20
>       other: "stuff"
>       more: "properties"
>
>     player.position()
>     # => {x: 10, y: 50}

    {defaults} = require "../util"

    module.exports = (I={}, self=Core(I)) ->
      defaults I,
        x: 0
        y: 0
        width: 8
        height: 8
        collisionMargin: Point(0, 0)

      self.extend

Get the object closest to this one.

        closest: (selector) ->
          if typeof selector is "string"
            selector = engine.find(selector)
          else
            selector = [].concat(selector)

          position = self.position()

          selector.sort (a, b) ->
            Point.distanceSquared(position, a.position()) - Point.distanceSquared(position, b.position())
          .first()

Distance between two objects. Proxies to Point.distance.
In order for this to work, `otherObj` must have a
position method.

>     player = GameObject
>       x: 50
>       y: 50
>       width: 10
>       height: 10
>
>     enemy = GameObject
>       x: 110
>       y: 120
>       width: 7
>       height: 20
>
>     player.distance(enemy)
>     # => 92.19544457292888

        distance: (otherObj) ->
          Point.distance(self.position(), otherObj.position())

The position of this game object. By default it is the center.

>     player = GameObject
>       x: 50
>       y: 40
>
>     player.position()
>     # => {x: 50, y: 40}

        position: (newPosition) ->
          if newPosition?
            I.x = newPosition.x
            I.y = newPosition.y
          else
            Point(I.x, I.y)

        changePosition: (delta) ->
          I.x += delta.x
          I.y += delta.y

          self

Does a check to see if this object is overlapping with the bounds passed in.

>     player = GameObject
>       x: 4
>       y: 6
>       width: 20
>       height: 20
>
>     player.collides({x: 5, y: 7, width: 20, height: 20})
>     # => true

        collides: (bounds) ->
          Collision.rectangular(self.bounds(), bounds)

This returns a modified bounds based on the collision margin.
The area of the bounds is reduced if collision margin is positive
and increased if collision margin is negative.

>     player = GameObject
>       collisionMargin:
>         x: -2
>         y: -4
>       x: 50
>       y: 50
>       width: 20
>       height: 20
>
>     player.collisionBounds()
>     # => {x: 38, y: 36, height: 28, width: 24}
>
>     player.collisionBounds(10, 10)
>     # => {x: 48, y: 46, height: 28, width: 24}

        collisionBounds: (xOffset, yOffset) ->
          bounds = self.bounds(xOffset, yOffset)

          bounds.x += I.collisionMargin.x
          bounds.y += I.collisionMargin.y
          bounds.width -= 2 * I.collisionMargin.x
          bounds.height -= 2 * I.collisionMargin.y

          return bounds

Returns infomation about the location of the object and its dimensions with optional offsets.

>     player = GameObject
>       x: 3
>       y: 6
>       width: 2
>       height: 2
>
>     player.bounds()
>     # => {x: 3, y: 6, width: 2, height: 2}
>
>     player.bounds(7, 4)
>     # => {x: 10, y: 10, width: 2, height: 2}

        bounds: (xOffset, yOffset) ->
          center = self.center()

          x: center.x - I.width/2 + (xOffset || 0)
          y: center.y - I.height/2 + (yOffset || 0)
          width: I.width
          height: I.height

The centeredBounds method returns infomation about the center
of the object along with the midpoint of the width and height.

>     player = GameObject
>       x: 3
>       y: 6
>       width: 2
>       height: 2
>
>     player.centeredBounds()
>     # => {x: 4, y: 7, xw: 1, yw: 1}

        centeredBounds: () ->
          center = self.center()

          x: center.x
          y: center.y
          xw: I.width/2
          yw: I.height/2


The center method returns the {@link Point} that is
the center of the object.

>     player.center()
>     # => {x: 30, y: 35}

        center: (newCenter) ->
          self.position(newCenter)

Return the circular bounds of the object. The circle is
centered at the midpoint of the object.

>     player.circle()
>     # => {radius: 5, x: 50, y: 50}

        circle: () ->
          circle = self.center()
          circle.radius = I.radius || I.width/2 || I.height/2

          return circle
