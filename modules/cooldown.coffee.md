Cooldown
========

The `Cooldown` module provides a declarative way to manage cooldowns type changes
to an objects properties.

Example: Health regeneration

Player's health will approach target of `100` by `1` unit every second of elapsed
game time.

>     player = GameObject
>       health: 50
>
>     player.cooldown "health",
>       target: 100
>
>     elapsedTime = 1
>     player.update(elapsedTime)
>
>     player.I.health
>     # => 51

Example: Rate of fire timeout

By default the cooldown approaches the target of `0` by `1` unit each second.

>     player = GameObject()
>     player.cooldown "shootTimer"
>     player.I.shootTimer = 10 # => Pew! Pew!
>
>     player.update(elapsedTime)
>
>     player.I.shootTimer # => 9

Example: Turbo cooldown

>     # Turbo Cooldown
>     player = GameObject()
>
>     # turboTimer starts at 1000
>     # and approaches 12 by 5 each second
>     player.cooldown "turboTimer",
>       approachBy: 5
>       target: 12
>
>     player.I.turboTimer = 1000
>
>     player.update(elapsedTime)
>
>     player.I.turboTimer # => 995

    Bindable = require "./bindable"
    {approach, defaults} = require "../util"

    module.exports = (I={}, self=Bindable(I)) ->
      defaults I,
        cooldowns: {}

      self.on "update", (dt) ->
        for name, cooldownOptions of I.cooldowns
          {approachBy, target} = cooldownOptions

          I[name] = approach(I[name], target, approachBy * dt)

      self.extend
        cooldown: (name, options={}) ->
          {target, approachBy} = options

          target ?= 0
          approachBy ?= 1

          I[name] ?= 0

          # Set the cooldown data
          I.cooldowns[name] = {
            target
            approachBy
          }

          return self
