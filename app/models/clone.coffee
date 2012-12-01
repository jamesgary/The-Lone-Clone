define ['lib/physics/circle'], (Circle) ->
  CLONE_START_RAD = .2
  CLONE_GROW_RATE = .05

  class Clone extends Circle
    constructor: (circleData, parent) ->
      @parentRad = parent.r()
      circleData.r = CLONE_START_RAD * @parentRad
      super(circleData)

    spike: ->
      @spiked = @dead = true
      @freeze()
    melt: ->
      @melted = @dead = true

    update: ->
      super()
      unless @dead
        @grow()

    ###########
    # private #
    ###########

    grow: ->
      r = @r()
      if r < @parentRad
        newRad = r + CLONE_GROW_RATE
        newRad = @parentRad if newRad > @parentRad
        @r(newRad)
