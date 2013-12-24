require "../../test_setup"

GameObject = require "../../game_object"

describe "Expirable", ->

  test "objects become inactive after their duration", ->
    obj = GameObject
      duration: 5
  
    4.times ->
      obj.update(1)
      obj.trigger "afterUpdate", 1
  
    equals obj.I.active, true, "object is active until duration is exceeded"
  
    5.times ->
      obj.update(1)
      obj.trigger "afterUpdate", 1
  
    equals obj.I.active, false, "object is inactive after duration"
