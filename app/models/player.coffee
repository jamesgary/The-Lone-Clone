define ['lib/physics/circle', 'models/clone'], (Circle, Clone) ->
  PLAYER_RAD = .5
  COOLDOWN_REQUIRED = 10

  class Player extends Circle
    constructor: (circleData) ->
      circleData.r = PLAYER_RAD
      super(circleData)
      @stamina = 0
      @clones = []
    spike: ->
      @spiked = @dead = true
      @freeze()
    spook: ->
      @spooked = @dead = true

    update: ->
      unless @dead
        @stamina++
        if (
          @stamina >= COOLDOWN_REQUIRED
        ) && (
          @cloningRight ||
          @cloningLeft  ||
          @cloningDown  ||
          @cloningUp
        )
          @makeClone()

    ###########
    # private #
    ###########

    makeClone: ->
      @stamina = 0
      x = @x()
      y = @y()
      x += PLAYER_RAD if @cloningRight
      x -= PLAYER_RAD if @cloningLeft
      y += PLAYER_RAD if @cloningDown
      y -= PLAYER_RAD if @cloningUp
      @clones.push(new Clone({ x: x, y: y }, this))
