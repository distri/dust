require "../test_setup"

GameObject = require "../game_object"

describe "GameObject", ->

  test "()", ->
    gameObject = GameObject()
    ok gameObject

  test ".construct", ->
    gameObject = GameObject.construct
      name: "Gandalf"

    equals(gameObject.I.name, "Gandalf")

  test "construct invalid object", ->
    raises ->
      GameObject.construct
        class: "aaaaa"

  test "#closest", ->
    o = GameObject
      x: 0
      y: 0

    other = GameObject
      x: 1
      y: 1

    other2 = GameObject
      x: 10
      y: 10

    equals o.closest([]), null

    equals o.closest([other, other2]), other

  test "elapsedTime", ->
    gameObject = GameObject()

    timeStep = 33

    gameObject.bind "update", (t) ->
      equals t, timeStep

    gameObject.update(timeStep)

  test "[event] create", ->
    o = GameObject()

    called = 0

    o.bind "create", ->
      called += 1
      ok true, "created event is fired on create"

    o.create()
    o.create() # Make sure only fired once

    assert.equal called, 1

  test "[event] update", ->
    gameObject = GameObject()

    gameObject.bind "update", ->
      equals(gameObject.I.age, 0, 'Age should be 0 on first update')

    gameObject.trigger "update", 1

  test "[event] destroy", ->
    o = GameObject()

    called = 0

    o.bind "destroy", ->
      called += 1
      ok true, "destroyed event is fired on destroy"

    o.destroy()
    o.destroy() # Make sure it's not called twice

    assert.equal called, 1
