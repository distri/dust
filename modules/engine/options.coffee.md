Options
=======

Pauses the game and displays an options menu with a volume control when the
player presses escape.

Currently a little gross, but works well.

The global volume control comes from `Resource` which includes sounds and music.

    options = require("resource").Control

    options.volume.observe (newValue) ->
      console.log newValue

    template = require "/templates/options"

An engine assumes it is the only thing running within a document, so we just
append here to the DOM. Running the app in an iframe will sandbox this correctly
so we might as well pollute a little when it makes things much easier.

The challenge remains to think about hot-reloading, but the best way is probably
to save the data, burn down the iframe/window, and create a completele new one
then load the data back in.

    document.body.appendChild(template(options))

    module.exports = (I, self) ->
      optionsMenuShown = false

      $(document).on "keydown", null, "esc", ->
        optionsMenuShown = !optionsMenuShown

        self.pause(optionsMenuShown)

        $(".options").toggleClass "up", optionsMenuShown

        if !optionsMenuShown
          $(".options input").blur()
