Registry
========

The registry maps class names to constructors so that data can be reconstituted.

    registry = {}

    defaultConstructor = GameObject = require "./game_object"

    module.exports = Registry =
      register: (name, constructor) ->
        throw "Constructor must be a function" unless typeof constructor is "function"

        if registry[name]?
          console.warn "Overwriting constructor: #{name}"

        registry[name] = constructor

      construct: (entityData) ->
        {class:className} = entityData

        if className?
          if constructor = registry[className]
            constructor(entityData)
          else
            throw "Unregistered constructor: #{className}"
        else
          defaultConstructor(entityData)

    Registry.register "GameObject", GameObject
