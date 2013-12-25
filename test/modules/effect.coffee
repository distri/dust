require "../../test_setup"

GameObject = require "../../game_object"

describe "Effect", ->

  test "fadeOut", ->
    player = GameObject()
  
    fadedOut = false
  
    player.fadeOut 1, ->
      fadedOut = true
  
    player.trigger "update", 1
    player.trigger "afterUpdate", 1
  
    equals player.I.alpha, 0, "Player has faded out"
    ok fadedOut, "callback was called"
