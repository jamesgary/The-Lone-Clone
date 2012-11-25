define ['lib/physics/physics', 'models/player', 'models/goal', 'lib/levelUtil'], (Physics, Player, Goal, LevelUtil) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10
  GOAL_RAD = .1

  startLevel: (@levelNumber) ->
    Physics.createWorld()
    @levelWinCallbacks = []
    @loadLevel()
    @addGoalListener()
  update: ->
    Physics.update()
    @player.update()
    clone.update() for clone in @player.clones
  onLevelWin: (f) ->
    @levelWinCallbacks.push(f)
  winLevel: -> # to be set in the controller
    callback() for callback in @levelWinCallbacks
  drawables: ->
    {
      staticRects: @static.rects
      staticPolygons: @static.polygons
      spikes: @static.spikes
      clones: @player.clones
      player: @player
      goal: @goal
    }

  ###########
  # private #
  ###########

  loadLevel: ->
    # levelData is a plain object
    levelData = LevelUtil.load(@levelNumber)
    @static = {}
    @static.rects = for rect in levelData.rects
      Physics.addStaticRect(rect)
    @static.polygons = for polygon in levelData.polygons
      Physics.addStaticPolygon(polygon)
    @static.spikes = for lines in levelData.spikes
      Physics.addStaticPolygon(lines)
    @player = new Player({ x: levelData.start.x, y: levelData.start.y })
    @goal   = new Goal(  { x: levelData.goal.x,  y: levelData.goal.y })
    @clones = []

  addGoalListener: ->
    self = this
    Physics.addListener((objA, objB) ->
      if objA && objB
        classA = objA.constructor.name
        classB = objB.constructor.name
        if classA == 'Player' || classB == 'Player'
          if classA == 'Goal' || classB == 'Goal'
            self.winLevel()
    )
