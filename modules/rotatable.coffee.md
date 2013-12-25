Rotatable
=========

The Rotatable module rotates the object
based on its rotational velocity.

>     player = GameObject
>       x: 0
>       y: 0
>       rotationalVelocity: Math.PI / 64
>
>     player.I.rotation
>     # => 0
>
>     player.update(1)
>
>     player.I.rotation
>     # => 0.04908738521234052 # Math.PI / 64
>
>     player.update(1)
>
>     player.I.rotation
>     # => 0.09817477042468103 # 2 * (Math.PI / 64)

    {defaults} = require "../util"

    module.exports = (I={}, self) ->
      defaults I,
        rotation: 0
        rotationalVelocity: 0

      self.on 'update', (dt) ->
        I.rotation += I.rotationalVelocity * dt

      return self
