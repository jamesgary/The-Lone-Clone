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

  allInteractions: (a, b) ->
    self.playerTouchesGoal(a, b)
    self.playerTouchesSpikes(a, b)
    self.cloneTouchesSpikes(a, b)
    self.ghostsSpookPlayer(a, b)
    self.lavaMeltsPlayer(a, b)
    self.lavaMeltsClone(a, b)

    return self.isSolid(a, b)

  playerTouchesGoal: (a, b) ->
    [player, goal] = self.checkContact(a, b, 'Goal', 'Player')
    if player && goal
      listener.winLevel()

  playerTouchesSpikes: (a, b) ->
    [player, spikes] = self.checkContact(a, b, 'Player', 'Spikes')
    if player && spikes
      player.spike()
      listener.loseLevel()

  cloneTouchesSpikes: (a, b) ->
    [clone, spikes] = self.checkContact(a, b, 'Clone', 'Spikes')
    if clone && spikes
      clone.spike()

  ghostsSpookPlayer: (a, b) ->
    [ghost, player] = self.checkContact(a, b, 'Ghost', 'Player')
    if ghost && player
      player.spook()
      listener.loseLevel()
  lavaMeltsPlayer: (a, b) ->
    [lava, player] = self.checkContact(a, b, 'Lava', 'Player')
    if lava && player
      player.melt()
      listener.loseLevel()
  lavaMeltsClone: (a, b) ->
    [lava, clone] = self.checkContact(a, b, 'Lava', 'Clone')
    if lava && clone
      clone.melt()

  isSolid: (a, b) ->
    !(
      self.isGhost(a, b) ||
      self.isLava(a, b) ||
      self.isMelted(a, b)
    )
  isGhost: (a, b) ->
    (
      (a && a.constructor.name == 'Ghost') ||
      (b && b.constructor.name == 'Ghost')
    )
  isLava: (a, b) ->
    (
      (a && a.constructor.name == 'Lava') ||
      (b && b.constructor.name == 'Lava')
    )
  isMelted: (a, b) ->
    (
      (a && a.melted) ||
      (b && b.melted)
    )

  checkContact: (a, b, nameA, nameB) ->
    if a && b
      classA = a.constructor.name
      classB = b.constructor.name
      if classA == nameA && classB == nameB
        return [a, b]
      else if classA == nameB && classB == nameA
        return [b, a]
    [null, null]
