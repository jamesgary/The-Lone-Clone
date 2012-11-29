define ['lib/physics/physics', 'models/player', 'models/goal', 'models/spikes', 'models/ghost', 'models/mover', 'models/platform', 'models/lava', 'lib/levelUtil', 'data/levelConfigs'], (Physics, Player, Goal, Spikes, Ghost, Mover, Platform, Lava, LevelUtil, LevelConfigs) ->
  startLevel: (@levelNumber) ->
    Physics.createWorld()
    @levelWinCallbacks = []
    @loadLevel()
    levelConfig = LevelConfigs.configFor(@levelNumber)
    levelConfig.tweak(this) if levelConfig.tweak
  update: ->
    Physics.update()
    @player.update()
    clone.update() for clone in @player.clones
    ghost.update() for ghost in @ghosts
    mover.update() for mover in @movers
  drawables: ->
    {
      platforms: @platforms
      movers:    @movers
      spikes:    @spikes
      clones:    @player.clones
      player:    @player
      goal:      @goal
      ghosts:    @ghosts
      lavas:     @lavas
    }
  setListeners: (preCollision, postCollision) ->
    Physics.setListeners(preCollision, postCollision)

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
    @lavas = for lava in levelData.lavas
      new Lava(lava)
