GameObject = require "../../game_object"
Camera = require "../../modules/camera"

describe "Camera", ->

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

  test "create", ->
    ok Camera()
  
  test "follow", ->
    object = GameObject()
    camera = Camera()
    dt = 1/60

    camera.follow(object)
    camera.trigger "afterUpdate", dt

    transform = camera.I.transform
    assert transform.tx?, "tx exists: #{transform.tx}"
    assert transform.ty?, "ty exists: #{transform.ty}"

  test "overlay", ->
    object = GameObject()

    called = 0
    object.bind 'overlay', ->
      ok true
      called += 1

    canvas = MockCanvas()

    camera = Camera()

    camera.trigger 'overlay', canvas, [object]

    assert.equal called, 1

  test "zoom", ->
    camera = Camera()

    camera.zoom(2)

    assert.equal camera.zoom(), 2

    camera.zoomOut(0.5)

    assert.equal camera.zoom(), 1

  test "shake", ->
    camera = Camera()

    camera.shake
      duration: 1
      intensity: 10

    assert.equal camera.I.shakeCooldown, 1, "Should set shake duration"
    assert.equal camera.I.shakeIntensity, 10, "Should set intensity"

    camera.trigger "draw", MockCanvas(), []
