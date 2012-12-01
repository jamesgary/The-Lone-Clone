define ['lib/physics/circle'], (Circle) ->
  DEFAULT_GHOST_RAD = .2 # a little smaller than player since it collides early
  DEFAULT_SPEED = .04

  class Ghost extends Circle
    constructor: (circleData, @target) ->
      @speed = DEFAULT_SPEED
      circleData.r = DEFAULT_GHOST_RAD
      circleData.isStatic = true
      super(circleData)

    update: ->
      @chaseTarget()

    gigafy: -> # make a gigaghost #TODO this ain't the right way
      @r(.5)
      @speed = .01

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
      xSpeed = Math.sin(radians) * @speed
      ySpeed = Math.cos(radians) * @speed
      @x(x + xSpeed)
      @y(y + ySpeed)
