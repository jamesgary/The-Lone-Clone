define ['models/world'], (World) ->
  PLAYER_RAD = .5
  CLONE_START_RAD = .2 * PLAYER_RAD
  CLONE_GROW_RATE = .05
  COOLDOWN = 10

  init: ->
    @startLevel(1)
  startLevel: (@levelNumber) ->
    World.startLevel(@levelNumber)
  restart: ->
    @startLevel(@levelNumber)
  startNextLevel: ->
    @startLevel(@levelNumber + 1)
  update: ->
    World.update()
  onLevelWin: (f) -> # to be set in the controller
    World.onLevelWin(f)
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

  ###########
  # private #
  ###########

  #addGoalListener: ->
  #  self = this
  #  Physics.addListener((objA, objB) ->
  #    if objA && objB
  #      if objA.name == 'player' || objB.name == 'player'
  #        if objA.name == 'goal' || objB.name == 'goal'
  #          console.log "winnnnnnn"
  #          self.winLevel()
  #  )
