define ->
  listener = {}
  self = {}
  contactInteractions: (l) ->
    self = this
    listener = l
    @allInteractions

  ###########
  # private #
  ###########

  allInteractions: (objA, objB) ->
    self.playerTouchesGoal(objA, objB)
    self.playerTouchesSpikes(objA, objB)
    self.cloneTouchesSpikes(objA, objB)
    self.ghostsKillPlayer(objA, objB)

    isSolid = !(self.isGhost(objA, objB))
    return isSolid

  playerTouchesGoal: (objA, objB) ->
    [player, goal] = self.checkContact(objA, objB, 'Goal', 'Player')
    if player && goal
      listener.winLevel()

  playerTouchesSpikes: (objA, objB) ->
    [player, spikes] = self.checkContact(objA, objB, 'Player', 'Spikes')
    if player && spikes
      player.spike()
      listener.loseLevel()

  cloneTouchesSpikes: (objA, objB) ->
    [clone, spikes] = self.checkContact(objA, objB, 'Clone', 'Spikes')
    if clone && spikes
      clone.spike()

  ghostsKillPlayer: (objA, objB) ->
    [ghost, player] = self.checkContact(objA, objB, 'Ghost', 'Player')
    if ghost && player
      player.spook()
      listener.loseLevel()

  isGhost: (objA, objB) ->
    (
      (objA && objA.constructor.name == 'Ghost') ||
      (objB && objB.constructor.name == 'Ghost')
    )

  checkContact: (objA, objB, nameA, nameB) ->
    if objA && objB
      classA = objA.constructor.name
      classB = objB.constructor.name
      if classA == nameA && classB == nameB
        return [objA, objB]
      else if classA == nameB && classB == nameA
        return [objB, objA]
    [null, null]
