define ->
  scale = 30
  init: (@canvas) ->
    @ctx = @canvas.getContext('2d')
  represent: (@pg) ->
  paint: ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @ctx.fillStyle = "rgb(10, 200, 10)"
    @paintStatic(s) for s in @pg.getStatics()
    @paintClones(@pg.getClones())
    @paintPlayer(@pg.getPlayer())

  ###########
  # private #
  ###########

  paintStatic: (sta) ->
    @ctx.fillRect(@scale(sta.x), @scale(sta.y), @scale(sta.w), @scale(sta.h))
  paintClones: (clones) ->
    @ctx.fillStyle = "rgb(150, 150, 100)"
    @paintCircle(clone) for clone in clones

  paintPlayer: (player) ->
    @ctx.fillStyle = "rgb(200, 200, 10)"
    @paintCircle(player)

  paintCircle: (circle) ->
    x = @scale(circle.x)
    y = @scale(circle.y)
    r = @scale(circle.r)
    a = circle.a
    @ctx.beginPath()
    @ctx.arc(x, y, r, 0, Math.PI*2, true)
    @ctx.closePath()
    @ctx.fill()

    @ctx.beginPath()
    @ctx.moveTo(x, y)
    @ctx.lineTo(x + @scale(Math.cos(a * circle.r)), y + @scale(Math.sin(a * circle.r)))
    @ctx.stroke()
  scale: (num) ->
    num * scale
