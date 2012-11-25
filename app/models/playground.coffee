define ['models/world', 'models/interactions'], (World, Interactions) ->
  startLevel: (@levelNumber) ->
    @levelWinCallbacks = []
    World.startLevel(@levelNumber)
    World.addListener(Interactions.contactInteractions(this))
  restart: ->
    @startLevel(@levelNumber)
  startNextLevel: ->
    @startLevel(@levelNumber + 1)
  update: ->
    World.update()
  onLevelWin: (f) -> # to be set in the controller
    @levelWinCallbacks.push(f)
  winLevel: ->
    f() for f in @levelWinCallbacks
  drawables: ->
    World.drawables()

  cloningUp       : -> World.player.cloningUp    = true
  cloningLeft     : -> World.player.cloningLeft  = true
  cloningDown     : -> World.player.cloningDown  = true
  cloningRight    : -> World.player.cloningRight = true
  stopCloningUp   : -> World.player.cloningUp    = false
  stopCloningLeft : -> World.player.cloningLeft  = false
  stopCloningDown : -> World.player.cloningDown  = false
  stopCloningRight: -> World.player.cloningRight = false
