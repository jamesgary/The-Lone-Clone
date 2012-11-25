define ['lib/physics/physics', 'models/player', 'models/goal', 'lib/levelUtil'], (Physics, Player, Goal, levelUtil) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10
  GOAL_RAD = .1

  startLevel: (@levelNumber) ->
    Physics.createWorld()
    @levelWinCallbacks = []
    @loadAssets()
  restart: ->
    @init()
  startNextLevel: ->
    @startLevel(@levelNumber + 1)
  update: ->
    Physics.update()
    @player.update()
    #clone.update() for clone in @clones
  onLevelWin: (f) ->
    @levelWinCallbacks.push(f)
  winLevel: -> # to be set in the controller
    callback() for callback in @levelWinCallbacks
  drawables: ->
    {
      staticRects: @static.rects
      staticPolygons: @static.polygons
      spikes: @static.spikes
      clones: @clones
      player: @player
      goal: @goal
    }

  ###########
  # private #
  ###########

  loadAssets: ->
    # levelData is a plain object
    levelData = levelUtil.load(@levelNumber)
    @static = {}
    @static.rects = for rect in levelData.rects
      Physics.addStaticRect(rect)
    @static.polygons = for polygon in levelData.polygons
      Physics.addStaticPolygon(polygon)
    @static.spikes = for lines in levelData.spikes
      Physics.addStaticPolygon(lines)
    @player = new Player({ x: levelData.start.x, y: levelData.start.y })
    @goal   = new Goal(  { x: levelData.goal.x,  y: levelData.goal.y })
    @addGoalListener()
    @clones = []

  addGoalListener: ->
    self = this
    Physics.addListener((objA, objB) ->
      if objA && objB
        if objA.name == 'player' || objB.name == 'player'
          if objA.name == 'goal' || objB.name == 'goal'
            console.log "winnnnnnn"
            self.winLevel()
    )
