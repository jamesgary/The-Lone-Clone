define ['lib/physics/physics'], (Physics) ->
  init: (canvas) ->
    Physics.createWorld()
    @ground = Physics.addStatic({ x: 1, y: 12, w: 18, h: 1 })
    @player = Physics.addCircle({ x: 10, y: 5, r: 1 })
    @physicalClones = []
    @clones = []

  update: ->
    Physics.update()
  cloneUp:    -> @makeClone('u')
  cloneDown:  -> @makeClone('d')
  cloneLeft:  -> @makeClone('l')
  cloneRight: -> @makeClone('r')

  getStatics: ->
    [@ground]
  getPlayer: ->
    @player
  getClones: ->
    @clones

  ###########
  # private #
  ###########

  makeClone: (dir) ->
    x = @player.x()
    y = @player.y()
    r = @player.r()
    switch dir
      when 'u' then y -= r
      when 'd' then y += r
      when 'l' then x -= r
      when 'r' then x += r
    @clones.push(Physics.addCircle({ x: x, y: y, r: r }))
