define ->
  configFor: (levelNum) ->
    switch(levelNum)
      when 7
        tweak: (world) ->
          for m in world.movers
            m.minHeight = 2
            m.maxHeight = 11
      when 11
        numClones: 20
      when 12
        numClones: 3
      when 13
        numClones: 5
      when 14
        numClones: 30
        tweak: (world) ->
          for m in world.movers
            m.minHeight = 2
            m.maxHeight = 11
      when 15
        numClones: 40
      when 16
        numClones: 3
      when 17
        numClones: 15
      when 18
        numClones: 1
      when 19
        tweak: (world) ->
          for g in world.ghosts
            g.gigafy()
      when 20
        numClones: -1
      else
        {}
