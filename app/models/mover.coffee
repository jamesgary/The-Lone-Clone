define ['lib/physics/polygon'], (Platform) ->
  SPEED = .05

  class Mover extends Platform
    # FIXME These rules will have to be on a per-level basis
    update: ->
      if @rising && @y() < 2
        @rising = false
      else if !@rising && @y() > 11
        @rising = true

      if @rising
        @transform({y: -SPEED})
      else
        @transform({y: SPEED})
