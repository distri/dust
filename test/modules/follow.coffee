require "../../test_setup"

GameObject = require "../../game_object"

describe "Follow", ->

  test "should set the correct velocity", ->
    player = GameObject
      x: 50
      y: 50
      width: 10
      height: 10

    enemy = GameObject
      x: 0
      y: 50
      widht: 10
      height: 10
      speed: 1

    enemy.follow(player)

    ok enemy.I.velocity.equal(Point(1, 0)), 'enemy should head toward player with a velocity Point(1, 0)'

    rightEnemy = GameObject
      x: 100
      y: 50
      width: 10
      height: 10
      speed: 1

    rightEnemy.follow(player)

    ok rightEnemy.I.velocity.equal(Point(-1, 0)), 'rightEnemy should head toward player with a velocity Point(-1, 0)'
