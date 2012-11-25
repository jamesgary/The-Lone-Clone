define ['lib/physics/physics', 'models/player', 'models/goal', 'models/spikes', 'lib/levelUtil'], (Physics, Player, Goal, Spikes, LevelUtil) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10
  GOAL_RAD = .1

  startLevel: (@levelNumber) ->
    Physics.createWorld()
    @levelWinCallbacks = []
    @loadLevel()
  update: ->
    Physics.update()
    @player.update()
    clone.update() for clone in @player.clones
  drawables: ->
    {
      staticRects: @static.rects
      staticPolygons: @static.polygons
      spikes: @static.spikes
      clones: @player.clones
      player: @player
      goal: @goal
    }
  addListener: (f) ->
    Physics.addListener(f)

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
    @static.spikes = for spikeLine in levelData.spikes
      new Spikes(spikeLine)
    @player = new Player({ x: levelData.start.x, y: levelData.start.y })
    @goal   = new Goal(  { x: levelData.goal.x,  y: levelData.goal.y })
    @clones = []
