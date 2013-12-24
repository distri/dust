require "../../test_setup"

Clamp = require "../../modules/clamp"

describe "Clamp", ->

  test "#clamp", ->
    o = Clamp
      x: 1500
  
    max = 100
  
    o.clamp
      x:
        min: 0
        max: max

    o.trigger "afterUpdate"
  
    equals o.I.x, max
