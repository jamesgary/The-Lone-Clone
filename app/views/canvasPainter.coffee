define ->
  scale = 30
  init: (@canvas) ->
    @ctx = @canvas.getContext('2d')
    @playerImg = new Image()
    @playerImg.src= 'assets/images/player.png'
    @cloneImg = new Image()
    @cloneImg.src= 'assets/images/clone.png'
    @time = 0
  represent: (@pg) ->
  paint: ->
    @time++
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @ctx.fillStyle = "rgb(10, 200, 10)"
    @paintStaticRects(s) for s in @pg.getStatics()
    @paintClones(@pg.getClones())
    @paintPlayer(@pg.getPlayer())
    @paintGoal(@pg.getGoal())

  ###########
  # private #
  ###########

  paintStaticRects: (rect) ->
    @ctx.fillRect(@scale(rect.x), @scale(rect.y), @scale(rect.w), @scale(rect.h))
  paintStatic: (points) ->
    @ctx.beginPath()
    @ctx.moveTo(@scale(points[0].x), @scale(12 - points[0].y))
    for point in points
      @ctx.lineTo(@scale(point.x), @scale(13 - point.y))
    @ctx.lineTo(@scale(points[0].x), @scale(13 - points[0].y))
    @ctx.closePath()
    @ctx.fill()
    #@ctx.stroke()

  paintClones: (clones) ->
    @paintObject(clone, @cloneImg) for clone in clones

  paintPlayer: (player) ->
    @paintObject(player, @playerImg)

  paintGoal: (goal) ->
    @ctx.beginPath()
    #console.log( @scale(goal.x()), @scale(goal.y()), @scale(goal.r()))

    x = @scale(goal.x())
    y = @scale(goal.y())
    r = @scale(goal.r())


    glow = (Math.abs(Math.sin(@time / 15)) * 3) + 1
    grd = @ctx.createRadialGradient(x, y, r, x, y, r + (r * glow))
    #grd.addColorStop(0, 'rgba(1.0, 1.0, 1.0, 1.0)')
    #grd.addColorStop(1, 'rgba(1.0, 1.0, 1.0, 0.0)')
    grd.addColorStop(0.0, 'rgba(255, 255, 255, 1.0)')
    grd.addColorStop(0.2, 'rgba(255, 255, 255, 0.9)')
    grd.addColorStop(0.4, 'rgba(255, 255, 255, 0.2)')
    grd.addColorStop(1.0, 'rgba(255, 255, 255, 0.0)')

    @ctx.arc(x, y, r + (r * glow), 0, 2 * Math.PI, false)
    @ctx.fillStyle = grd
    @ctx.fill()

    #@ctx.fillStyle = 'white'
    #@ctx.fill()
    #@ctx.lineWidth = 1
    #@ctx.strokeStyle = 'green'
    #@ctx.stroke()

  paintObject: (object, image) ->
    @ctx.save()
    @ctx.translate(@scale(object.x()), @scale(object.y()))
    @ctx.rotate(object.a())
    r = @scale(object.r())
    @ctx.drawImage(image, -r, -r, 2*r, 2*r)
    @ctx.restore()
  scale: (num) ->
    num * scale
