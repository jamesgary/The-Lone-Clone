define ['lib/physics/circle', 'models/clone', 'jquery'], (Circle, Clone, $) ->
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
    melt: ->
      @melted = @dead = true
    update: ->
      super()
      unless @dead
        @stamina++
        if (
          @stamina >= COOLDOWN_REQUIRED &&
          (!@clonesLeft? || @clonesLeft > 0)
        ) && (
          @cloningRight ||
          @cloningLeft  ||
          @cloningDown  ||
          @cloningUp
        )
          @makeClone()
    displayClonesLeftInit: ->
      if @clonesLeft?
        $('.clonesLeft').show()
        @displayClonesLeft()
      else
        $('.clonesLeft').hide()

    ###########
    # private #
    ###########

    displayClonesLeft: ->
      $('.clonesLeft').text(@clonesLeft) # TODO I'm lazy
    makeClone: ->
      @clonesLeft--
      @stamina = 0
      x = @x()
      y = @y()
      x += PLAYER_RAD if @cloningRight
      x -= PLAYER_RAD if @cloningLeft
      y += PLAYER_RAD if @cloningDown
      y -= PLAYER_RAD if @cloningUp
      @clones.push(new Clone({ x: x, y: y }, this))
      @displayClonesLeft()
