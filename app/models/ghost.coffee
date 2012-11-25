define ['lib/physics/circle'], (Circle) ->
  GHOST_RAD = .5
  SPEED = .05

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
