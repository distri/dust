Movable
=======

The Movable module automatically updates the position and velocity of
GameObjects based on the velocity and acceleration.

It is included in `GameObject` by default.

>     player = GameObject
>       x: 0
>       y: 0
>       velocity: Point(0, 0)
>       acceleration: Point(1, 0)
>       maxSpeed: 2
>
>     # => `velocity is {x: 0, y: 0} and position is {x: 0, y: 0}`
>
>     player.update(1)
>     # => `velocity is {x: 1, y: 0} and position is {x: 1, y: 0}`
>
>     player.update(1)
>     # => `velocity is {x: 2, y: 0} and position is {x: 3, y: 0}`
>
>     # we've hit our maxSpeed so our velocity won't increase
>     player.update(1)
>     # => `velocity is {x: 2, y: 0} and position is {x: 5, y: 0}`

    {defaults} = require "../util"

    module.exports = (I={}, self) ->
      defaults I,
        acceleration: Point(0, 0)
        velocity: Point(0, 0)

      # Force acceleration and velocity to be Points
      # Useful when reloading data from JSON
      I.acceleration = Point(I.acceleration.x, I.acceleration.y)
      I.velocity = Point(I.velocity.x, I.velocity.y)

      self.attrReader "velocity", "acceleration"

      # Handle multi-include
      self.off ".Movable"

      self.on 'update.Movable', (dt) ->
        I.velocity = I.velocity.add(I.acceleration.scale(dt))

        if I.maxSpeed?
          currentSpeed = I.velocity.magnitude()
          if currentSpeed > I.maxSpeed
            I.velocity = I.velocity.scale(I.maxSpeed / currentSpeed)

        I.x += I.velocity.x * dt
        I.y += I.velocity.y * dt
