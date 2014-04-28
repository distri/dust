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

  test "flash", ->
    camera = Camera()

    camera.flash
      duration: 1

    camera.trigger "afterUpdate", 0.5

    assert.equal camera.I.flashAlpha, 0.5, "flash alpha (#{camera.I.flashAlpha}) should be 0.5"

  test "shake", ->
    camera = Camera()

    camera.shake
      duration: 1
      intensity: 10

    assert.equal camera.I.shakeCooldown, 1, "Should set shake duration"
    assert.equal camera.I.shakeIntensity, 10, "Should set intensity"

    camera.trigger "draw", MockCanvas(), []
