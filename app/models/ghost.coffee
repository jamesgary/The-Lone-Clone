define ['lib/physics/circle'], (Circle) ->
  GHOST_RAD = .2 # a little smaller than player since it collides early
  SPEED = .04

  class Ghost extends Circle
    constructor: (circleData, @target) ->
      circleData.r = GHOST_RAD
      circleData.isStatic = true
      super(circleData)

    update: ->
      @chaseTarget()

    ###########
    # private #
    ###########

    chaseTarget: ->
      targetX = @target.x()
      targetY = @target.y()
      x = @x()
      y = @y()
      dx = targetX - x
      dy = targetY - y
      radians = Math.atan2(dx, dy)
      xSpeed = Math.sin(radians) * SPEED
      ySpeed = Math.cos(radians) * SPEED
      @x(x + xSpeed)
      @y(y + ySpeed)
