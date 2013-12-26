SaveState
=========

The `SaveState` module provides methods to save and restore the current game state.

It is included in `GameState` by default

    {extend} = require "/util"

    module.exports = (I={}, self=Core(I)) ->
      savedState = null

Methods
-------

      self.extend

`saveState` saves the current game state and returns a JSON object representing 
that state.

@returns {Array} An array of the instance data of all objects in the game state

>     engine.on 'update', ->
>       if justPressed.s
>         engine.saveState()

        saveState: ->
          savedState = I.objects.map (object) ->
            extend({}, object.I)

Loads the game state passed in, or the last saved state, if any.

@param [newState] An array of object instance data to load.

>     engine.on 'update', ->
>       if justPressed.l
>         # loads the last saved state
>         engine.loadState()
>  
>       if justPressed.o
>         # removes all game objects, then reinstantiates 
>         # them with the entityData passed in
>         engine.loadState([{x: 40, y: 50, class: "Player"}, {x: 0, y: 0, class: "Enemy"}, {x: 500, y: 400, class: "Boss"}])

        loadState: (newState) ->
          if newState ||= savedState
            I.objects.invoke "trigger", "remove"
            I.objects = []

            newState.each (objectData) ->
              self.add extend({}, objectData)

Reloads the current game state, useful for hotswapping code.

        reload: ->
          oldObjects = I.objects
          I.objects = []
      
          oldObjects.each (object) ->
            object.trigger "remove"
      
            self.add object.I

          return self
