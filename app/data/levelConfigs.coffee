define ->
  configFor: (levelNum) ->
    switch(levelNum)
      when 7
        {
          tweak: (world) ->
            for m in world.movers
              m.minHeight = 2
              m.maxHeight = 11
        }
      when 11
        {
          numClones: 9
          tweak: (world) ->
            for m in world.movers
              m.minHeight = 2
              m.maxHeight = 11
        }
      else
        {}
