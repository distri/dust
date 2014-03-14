Util
====

    module.exports =
      approach: (current, target, amount) ->
        (target - current).clamp(-amount, amount) + current

Apply a stylesheet idempotently.

      applyStylesheet: (style, id="primary") ->
        styleNode = document.createElement("style")
        styleNode.innerHTML = style
        styleNode.id = id

        if previousStyleNode = document.head.querySelector("style##{id}")
          previousStyleNode.parentNode.removeChild(prevousStyleNode)

        document.head.appendChild(styleNode)

      defaults: (target, objects...) ->
        for object in objects
          for name of object
            unless target.hasOwnProperty(name)
              target[name] = object[name]

        return target

      extend: (target, sources...) ->
        for source in sources
          for name of source
            target[name] = source[name]

        return target
