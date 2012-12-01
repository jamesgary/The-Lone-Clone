define ['models/world', 'models/interactions'], (World, Interactions) ->
  startLevel: (levelNumber) ->
    @paused = false
    @levelWinCallbacks = []
    @levelLoseCallbacks = []
    World.startLevel(levelNumber)
    World.setListeners(Interactions.preCollision(this), Interactions.postCollision(this))
    @player = World.player # TODO i'm lazy
  update: ->
    unless @paused
      World.update()
  onLevelWin: (f) -> # to be set in the controller
    @levelWinCallbacks.push(f)
  onLevelLose: (f) -> # to be set in the controller
    @levelLoseCallbacks.push(f)
  winLevel: ->
    f() for f in @levelWinCallbacks
  loseLevel: ->
    f() for f in @levelLoseCallbacks
  drawables: ->
    World.drawables()
  togglePause: ->
    @paused = !@paused

  cloningUp       : -> World.player.cloningUp    = true
  cloningLeft     : -> World.player.cloningLeft  = true
  cloningDown     : -> World.player.cloningDown  = true
  cloningRight    : -> World.player.cloningRight = true
  stopCloningUp   : -> World.player.cloningUp    = false
  stopCloningLeft : -> World.player.cloningLeft  = false
  stopCloningDown : -> World.player.cloningDown  = false
  stopCloningRight: -> World.player.cloningRight = false
