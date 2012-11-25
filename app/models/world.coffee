define ['lib/physics/physics', 'models/player', 'models/goal', 'models/spikes', 'models/ghost', 'lib/levelUtil'], (Physics, Player, Goal, Spikes, Ghost, LevelUtil) ->
  startLevel: (@levelNumber) ->
    Physics.createWorld()
    @levelWinCallbacks = []
    @loadLevel()
  update: ->
    Physics.update()
    @player.update()
    clone.update() for clone in @player.clones
    ghost.update() for ghost in @ghosts
  drawables: ->
    {
      staticRects: @static.rects
      staticPolygons: @static.polygons
      spikes: @static.spikes
      clones: @player.clones
      player: @player
      goal: @goal
      ghosts: @ghosts
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
      polygon
    @static.spikes = for spikeLine in levelData.spikes
      new Spikes(spikeLine)
    @player = new Player({ x: levelData.start.x, y: levelData.start.y })
    @goal   = new Goal(  { x: levelData.goal.x,  y: levelData.goal.y })
    @ghosts = for ghost in levelData.ghosts
      new Ghost({ x: ghost.x,  y: ghost.y }, @player)
    @clones = []
