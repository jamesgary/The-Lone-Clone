define ['lib/physics/polygon'], (Platform) ->
  SPEED = 3

  class Mover extends Platform
    update: ->
      if @rising && @y() < @minHeight
        @rising = false
      else if !@rising && @y() > @maxHeight
        @rising = true

      if @rising
        @transform({y: -SPEED})
      else
        @transform({y: SPEED})
