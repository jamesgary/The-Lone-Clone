define ['lib/physics/circle'], (Circle) ->
  PLAYER_RAD = .5
  COOLDOWN = 10

  class Player extends Circle
    constructor: (circleData) ->
      circleData.r = PLAYER_RAD
      super(circleData)

    update: ->
      #@currentCooldown--
      #@makeClone() if (@currentCooldown <= 0) && (@cloneRight || @cloneLeft || @cloneDown || @cloneUp)
      #@makeClone()

    ###########
    # private #
    ###########

    makeClone: ->
      @currentCooldown = COOLDOWN
      x = @player.x()
      y = @player.y()
      r = CLONE_START_RAD
      x += PLAYER_RAD if @cloneRight
      x -= PLAYER_RAD if @cloneLeft
      y += PLAYER_RAD if @cloneDown
      y -= PLAYER_RAD if @cloneUp
      @clones.push(Physics.addCircle({ x: x, y: y, r: r }))
