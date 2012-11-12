define ['lib/physics/physics', 'lib/levelUtil'], (Physics, levelUtil) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10

  # to be overwritten by controller
  cloneUp:    false
  cloneDown:  false
  cloneLeft:  false
  cloneRight: false
  currentCooldown: 0

  init: (canvas) ->
    Physics.createWorld()
    levelData = levelUtil.load(1) # load level 1
    @statics = for rect in levelData.rects
      Physics.addStaticRect(rect)
    @player = Physics.addCircle({ x: 10, y: 5, r: PLAYER_RAD })
    @clones = []

  update: ->
    @currentCooldown--
    @makeClone() if (@currentCooldown <= 0) && (@cloneRight || @cloneLeft || @cloneDown || @cloneUp)
    for clone in @clones
      r = clone.r()
      if r < PLAYER_RAD
        newRad = r + CLONE_GROW_RATE
        newRad = PLAYER_RAD if newRad > PLAYER_RAD
        clone.r(newRad)
    Physics.update()

  getStatics: ->
    @statics
  getPlayer: ->
    @player
  getClones: ->
    @clones

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
