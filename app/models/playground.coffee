define ['models/world'], (World) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10
  GOAL_RAD = .1

  # to be overwritten by controller
  cloneUp:    false
  cloneDown:  false
  cloneLeft:  false
  cloneRight: false
  #currentCooldown: 0

  init: ->
    @startLevel(1)
  startLevel: (@levelNumber) ->
    @clones = 0
    World.startLevel(@levelNumber)
  restart: ->
    @startLevel(@levelNumber)
  startNextLevel: ->
    @startLevel(@levelNumber + 1)

  update: ->
    #@currentCooldown--
    @makeClone() if (@currentCooldown <= 0) && (@cloneRight || @cloneLeft || @cloneDown || @cloneUp)
    for clone in @clones
      r = clone.r()
      if r < PLAYER_RAD
        newRad = r + CLONE_GROW_RATE
        newRad = PLAYER_RAD if newRad > PLAYER_RAD
        clone.r(newRad)
    World.update()

  onLevelWin: (f) -> # to be set in the controller
    World.onLevelWin(f)
  winLevel: ->
    callback() for callback in @levelWinCallbacks
  drawables: ->
    World.drawables()

  ###########
  # private #
  ###########

  #addGoalListener: ->
  #  self = this
  #  Physics.addListener((objA, objB) ->
  #    if objA && objB
  #      if objA.name == 'player' || objB.name == 'player'
  #        if objA.name == 'goal' || objB.name == 'goal'
  #          console.log "winnnnnnn"
  #          self.winLevel()
  #  )

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
