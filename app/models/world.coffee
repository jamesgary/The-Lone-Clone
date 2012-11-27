define ['lib/physics/physics', 'models/player', 'models/goal', 'models/spikes', 'models/ghost', 'models/mover', 'models/platform', 'lib/levelUtil'], (Physics, Player, Goal, Spikes, Ghost, Mover, Platform, LevelUtil) ->
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
      platforms: @platforms
      movers: @movers
      spikes: @spikes
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
    @player = new Player({ x: levelData.start.x, y: levelData.start.y })
    @goal   = new Goal(  { x: levelData.goal.x,  y: levelData.goal.y })
    @platforms = for platform in levelData.platforms
      new Platform(platform)
    @spikes = for spikeLine in levelData.spikes
      new Spikes(spikeLine)
    @ghosts = for ghost in levelData.ghosts
      new Ghost({ x: ghost.x,  y: ghost.y }, @player)
    @movers = for mover in levelData.movers
      new Mover(mover)
