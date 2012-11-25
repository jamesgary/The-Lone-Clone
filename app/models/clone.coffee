define ->

  grow: ->
    r = clone.r()
    if r < PLAYER_RAD
      newRad = r + CLONE_GROW_RATE
      newRad = PLAYER_RAD if newRad > PLAYER_RAD
      clone.r(newRad)
