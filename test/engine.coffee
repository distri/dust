require "../test_setup"

Engine = require "../engine"

describe "Engine", ->

  MockCanvas = ->
    clear: ->
    context: ->
      beginPath: ->
      clip: ->
      rect: ->
    drawRect: ->
    fill: ->
    withTransform: (t, fn) ->
      fn(@)
    clip: ->
    globalAlpha: ->

  test "#play, #pause, and #paused", ->
    engine = Engine()

    equal engine.paused(), false
    engine.pause()
    equal engine.paused(), true
    engine.play()
    equal engine.paused(), false

    engine.pause()
    equal engine.paused(), true
    engine.pause()
    equal engine.paused(), false

    engine.pause(false)
    equal engine.paused(), false

    engine.pause(true)
    equal engine.paused(), true

  test "#save and #restore", ->
    engine = Engine()

    engine.add {}
    engine.add {}

    equals(engine.objects().length, 2)

    engine.saveState()

    engine.add {}

    equals(engine.objects().length, 3)

    engine.loadState()

    equals(engine.objects().length, 2)

  test "before add event", ->
    engine = Engine()

    engine.bind "beforeAdd", (data) ->
      equals data.test, "test"

    engine.add
      test: "test"

  test "#add", ->
    engine = Engine()

    assert engine.objects().length is 0

    engine.add "GameObject",
      test: true

    assert engine.objects().length is 1

  test "#add class name only", ->
    engine = Engine()

    assert engine.objects().length is 0
    engine.add "GameObject"
    assert engine.objects().length is 1

  test "zSort", ->
    engine = Engine
      canvas: MockCanvas()
      zSort: true

    n = 0
    bindDraw = (o) ->
      o.bind 'draw', ->
        n += 1
        o.I.drawnAt = n

    o2 = engine.add
      zIndex: 2
    o1 = engine.add
      zIndex: 1

    bindDraw(o1)
    bindDraw(o2)

    engine.frameAdvance()

    equals o1.I.drawnAt, 1, "Object with zIndex #{o1.I.zIndex} should be drawn first"
    equals o2.I.drawnAt, 2, "Object with zIndex #{o2.I.zIndex} should be drawn second"

  test "draw events", ->
    engine = Engine
      canvas: MockCanvas()
      backgroundColor: false

    calls = 0

    engine.bind "beforeDraw", ->
      calls += 1
      ok true

    engine.bind "draw", ->
      calls += 1
      ok true

    engine.frameAdvance()

    equals calls, 2

  test "Remove event", ->
    engine = Engine
      backgroundColor: false

    object = engine.add
      active: false

    called = 0
    object.bind "remove", ->
      called += 1
      ok true, "remove called"

    engine.frameAdvance()

    assert.equal called, 1

  test "#find", ->
    engine = Engine()

    engine.add
      id: "testy"

    engine.add
      test: true
    .attrReader "test"

    engine.add
      solid: true
      opaque: false
    .attrReader "solid", "opaque"

    equal engine.find("#no_testy").length, 0, "No object with id `no_testy`"
    equal engine.find("#testy").length, 1, "Object with id `testy`"
    equal engine.find(".test").length, 1, "Object with attribute `test`"
    equal engine.find(".solid=true").length, 1, "Object with attribute `solid` equal to true"
    equal engine.find(".opaque=false").length, 1, "Object with attribute `opaque` equal to false"

  test "#camera", ->
    engine = Engine()

    equal engine.camera(), engine.cameras().first()

  test "#collides", ->
    engine = Engine()

    engine.collides({x: 0, y: 0, width: 10, height: 10}, null)

  test "Integration", ->
    engine = Engine
      FPS: 30

    object = engine.add
      class: "GameObject"
      velocity: Point(30, 0)

    engine.frameAdvance()

    equals object.I.x, 1
    equals object.I.age, 1/30

  test "objectsUnderPoint", ->
    engine = Engine()

    object = engine.add
      x: 0
      y: 0
      width: 100
      height: 100

    equals engine.objectsUnderPoint(Point(0, 0)).length, 1
    equals engine.objectsUnderPoint(Point(300, 300)).length, 0

  # TODO: Maybe this should be a state stack and have pushState and popState
  # in addition to setState
  # TODO: This should be in GameStates test, not engine
  test "#setState"# TODO, ->
  ###
    engine = Engine()

    # TODO: Shouldn't need to use the GameState constructor itself
    nextState = GameState()

    engine.setState nextState

    # Test state change events
    engine.bind "stateEntered", ->
      ok true
    engine.bind "stateExited", ->
      ok true

    engine.update()

    equal engine.I.currentState, nextState
  ###
