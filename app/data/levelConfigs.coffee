define ->
  configFor: (levelNum) ->
    switch(levelNum)
      when 6
        {
          tweak: (world) ->
            for m in world.movers
              m.minHeight = 2
              m.maxHeight = 11
        }
      else
        {}
