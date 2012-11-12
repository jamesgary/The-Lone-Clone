define ->
  scale = 30
  init: (@canvas) ->
    @ctx = @canvas.getContext('2d')
    @playerImg = new Image()
    @playerImg.src= 'assets/images/player.png'
    @cloneImg = new Image()
    @cloneImg.src= 'assets/images/clone.png'
  represent: (@pg) ->
  paint: ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @ctx.fillStyle = "rgb(10, 200, 10)"
    @paintStaticRects(s) for s in @pg.getStatics()
    @paintClones(@pg.getClones())
    @paintPlayer(@pg.getPlayer())

  ###########
  # private #
  ###########

  paintStaticRects: (rect) ->
    @ctx.fillRect(@scale(rect.x), @scale(rect.y), @scale(rect.w), @scale(rect.h))
  paintStatic: (points) ->
    console.log points
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

  paintObject: (object, image) ->
    @ctx.save()
    @ctx.translate(@scale(object.x()), @scale(object.y()))
    @ctx.rotate(object.a())
    r = @scale(object.r())
    @ctx.drawImage(image, -r, -r, 2*r, 2*r)
    @ctx.restore()
  scale: (num) ->
    num * scale
