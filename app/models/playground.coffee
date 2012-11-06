define ['lib/physics'], (Physics) ->
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
    @player.refresh()
  getClones: ->
    clone.refresh() for clone in @clones

  ###########
  # private #
  ###########

  makeClone: (dir) ->
    p = @getPlayer()
    x = p.x
    y = p.y
    switch dir
      when 'u' then y -= p.r
      when 'd' then y += p.r
      when 'l' then x -= p.r
      when 'r' then x += p.r
    @clones.push(Physics.addCircle({ x: x, y: y, r: p.r }))
  #simplify: (circle) ->
  #  window.ccc = circle
  #  # hey, this is the wrong place to do it, fyi FIXME
  #  pos = circle.GetPosition()
  #  Clone.new({
  #    x: pos.x
  #    y: pos.y
  #    r: circle.GetFixtureList().GetShape().GetRadius()
  #    a: circle.GetAngle()
  #  })
