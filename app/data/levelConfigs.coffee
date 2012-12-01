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
        numClones: 10
        tweak: (world) ->
          for m in world.movers
            m.minHeight = 2
            m.maxHeight = 11
      else
        {}
