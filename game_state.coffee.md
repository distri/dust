GameState
=========

A game state is a set of objects in a particular configuration.

Events
------

`beforeAdd` is triggered before the object is created from the data and is passed
the data itself.

`afterAdd` is triggered after an object is added to the game state and is passed
the object that is added.

    {defaults} = require "./util"
    Bindable = require "./modules/bindable"
    GameObject = require "../../game_object"

    module.exports = (I={}, self=Bindable(I)) ->
      defaults I,
        objects: []

      queuedObjects = []

      self.extend 

The `add` method creates an object from data and adds it object to the game world.

Returns the added object.

You can add arbitrary `entityData` and the engine will make it into a `GameObject`

>     engine.add
>       x: 50
>       y: 30
>       color: "red"
>
>     player = engine.add
>       class: "Player"

        # TODO: Need some kind of object constructor registry to reconstitute game
        # objects from data
        add: (entityData) ->
          self.trigger "beforeAdd", entityData
    
          object = GameObject.construct entityData
          object.create()
    
          self.trigger "afterAdd", object
    
          if I.updating
            queuedObjects.push object
          else
            I.objects.push object
    
          return object

        objects: ->
          I.objects.copy()
    
      # Add events and methods here
      self.on "update", (elapsedTime) ->
        I.updating = true
    
        I.objects.invoke "trigger", "beforeUpdate", elapsedTime
    
        [toKeep, toRemove] = I.objects.partition (object) ->
          object.update(elapsedTime)
    
        I.objects.invoke "trigger", "afterUpdate", elapsedTime
    
        toRemove.invoke "trigger", "remove"
    
        I.objects = toKeep.concat(queuedObjects)
        queuedObjects = []
    
        I.updating = false

      self.include require "./modules/cameras"
      self.include require "./modules/save_state"

      return self
