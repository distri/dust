engine = require("/engine")()
GameObject = require "/game_object"

describe "engine", ->
  it "should register constructors", ->
    engine.register "Duder", GameObject

  it "should be able to add objects registered by constructors", ->
    engine.add "Duder"

  it "should throw an error when trying to register a non-function", ->
    assert.throws ->
      engine.register "Duder"

  it "should throw an error when trying to create from an unregistered constructor", ->
    assert.throws ->
      engine.add "NotRegistered"
