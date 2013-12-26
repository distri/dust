require "../test_setup"

GameState = require "../game_state"

describe "GameState", ->
  it "should be legit", ->
    assert GameState()
