require "../../test_setup"

Bounded = require "../../modules/bounded"

describe "Bounded", ->

  test 'it should have #distance', ->
    player = Bounded()

    ok player.distance

  test 'it should proxy #distance to Point.distance', ->
    player = Bounded
      x: 50
      y: 50
      width: 10
      height: 10

    enemy = Bounded
      x: 110
      y: 120
      width: 7
      height: 20

    equals player.distance(enemy), Point.distance(player.position(), enemy.position())

  test "#bounds returns correct x, y, width, height", ->
    x = 5
    y = 10
    width = 50
    height = 75

    obj = Bounded
      x: x
      y: y
      width: width
      height: height

    equals obj.bounds().x, x - width/2
    equals obj.bounds().y, y - height/2
    equals obj.bounds().width, width
    equals obj.bounds().height, height

  test "#centeredBounds returns correct x, y, xw, yx", ->
    x = -5
    y = 20

    obj = Bounded
      x: x
      y: y
      width: 100,
      height: 200

    bounds = obj.centeredBounds()

    equals bounds.x, x
    equals bounds.y, y
    equals bounds.xw, 100 / 2
    equals bounds.yw, 200 / 2

  test "#bounds(width, height) returns correct x, y", ->
    x = 20
    y = 10
    width = 15
    height = 25

    offsetX = 7.5
    offsetY = 12

    obj = Bounded
      x: x
      y: y
      width: width
      height: height

    bounds = obj.bounds(offsetX, offsetY)

    equals bounds.x, obj.center().x + offsetX - width/2
    equals bounds.y, obj.center().y + offsetY - height/2

  test "#center returns correct center point", ->
    obj = Bounded
      x: -5
      y: 20
      width: 10
      height: 60

    center = obj.center()

    ok center.equal(Point(-5, 20))
