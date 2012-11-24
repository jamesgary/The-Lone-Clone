define ['lib/physics/physics', 'lib/levelUtil'], (Physics, levelUtil) ->
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
  currentCooldown: 0

  init: ->
    @levelWinCallbacks = []
    @startLevel(1)
  startLevel: (@levelNumber) ->
    Physics.createWorld()
    levelData = levelUtil.load(@levelNumber)
    @static = {}
    @static.rects = for rect in levelData.rects
      Physics.addStaticRect(rect)
    @static.polygons = for polygon in levelData.polygons
      Physics.addStatic(polygon)
    @spikes = for lines in levelData.spikes
      Physics.addStatic(lines)
    @player = Physics.addCircle({ x: levelData.start.x, y: levelData.start.y, r: PLAYER_RAD })
    @player.name = 'player'
    @goal = Physics.addStaticCircle({ x: levelData.goal.x, y: levelData.goal.y, r: GOAL_RAD })
    @goal.name = 'goal'
    @addGoalListener()
    @clones = []
  restart: ->
    @init()
  startNextLevel: ->
    @startLevel(@levelNumber + 1)

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

  getStatic: ->
    @static
  getPlayer: ->
    @player
  getClones: ->
    @clones
  getGoal: ->
    @goal
  getSpikes: ->
    @spikes
  onLevelWin: (f) ->
    @levelWinCallbacks.push(f)
  winLevel: -> # to be set in the controller
    callback() for callback in @levelWinCallbacks

  ###########
  # private #
  ###########

  addGoalListener: ->
    self = this
    Physics.addListener((objA, objB) ->
      if objA && objB
        if objA.name == 'player' || objB.name == 'player'
          if objA.name == 'goal' || objB.name == 'goal'
            console.log "winnnnnnn"
            self.winLevel()
    )

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
