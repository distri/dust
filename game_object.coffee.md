GameObject
==========

The default base class for all objects you can add to the engine.

Events
------

GameObjects fire events that you may attach listeners to. Event listeners
are bound with `object.on(eventName, handler)`

`create` is triggered when the object is created.

`destroy` is triggered when object is destroyed.

Use the destroy event to add particle effects, play sounds, etc.

>     bomb.on 'destroy', ->
>       bomb.explode()
>       Sound.play "Kaboom"

`update` is triggered during every step of the game loop.

Check to see if keys are being pressed and change the player's velocity.

>     player.on 'update', ->
>       if keydown.left
>         player.velocity(Point(-1, 0))
>       else if keydown.right
>         player.velocity(Point(1, 0))
>       else
>         player.velocity(Point(0, 0))

Triggered when the object is removed from the engine. Use the remove event to
handle any clean up.

Destroyed objects are always removed, but removed objects may not necessarily have
been destroyed.

>     boss.bind 'remove', ->
>       unlockDoorToLevel2()

    {defaults} = require "./util"

    module.exports = GameObject = (I={}, self=Core(I)) ->
      defaults I,
        active: true
        created: false
        destroyed: false

      self.attrReader "id"

      self.extend
        class: ->
          I.class or "GameObject"

Update the game object. The engine calls this method.

        update: (elapsedTime) ->
          # TODO: Extract this I.active check out into an engine gameObject remove processor or something
          # TODO: Remove this method and only use events.
          if I.active
            self.trigger 'update', elapsedTime

          I.active

Triggers the create event if the object has not already been created. This method is called by the engine.

        create: ->
          self.trigger('create') unless I.created
          I.created = true

Destroys the object and triggers the destroyed event. Anyone can call this method.

        destroy: ->
          self.trigger('destroy') unless I.destroyed

          I.destroyed = true
          I.active = false

      GameObject.defaultModules.each (module) ->
        self.include module

      return self

    GameObject.defaultModules = [
      "bindable"
      "age"
      "bounded"
      "clamp"
      "cooldown"
      "drawable"
      "effect"
      "expirable"
      "follow"
      "meter"
      "movable"
      "rotatable"
      "timed_events"
      "tween"
    ].map (name) ->
      require "./modules/#{name}"

Construct an object instance from the given entity data.

    GameObject.construct = (entityData) ->
      if className = entityData.class
        if constructor = GameObject.registry[className]
          constructor(entityData)
        else
          throw "Unregistered constructor: #{className}"
      else
        GameObject(entityData)

    GameObject.registry =
      GameObject: GameObject
