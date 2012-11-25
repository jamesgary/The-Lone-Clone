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

  checkContact: (objA, objB, nameA, nameB) ->
    if objA && objB
      classA = objA.constructor.name
      classB = objB.constructor.name
      if classA == nameA && classB == nameB
        return [objA, objB]
      else if classA == nameB && classB == nameA
        return [objB, objA]
    [null, null]
