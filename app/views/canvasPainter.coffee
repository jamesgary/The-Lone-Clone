define ->
  scale = 30
  init: (@canvas) ->
    @ctx = @canvas.getContext('2d')
    @playerImg = new Image()
    @playerImg.src= 'assets/images/player.png'
    @spikedPlayerImg = new Image()
    @spikedPlayerImg.src= 'assets/images/spiked_player.png'
    @cloneImg = new Image()
    @cloneImg.src= 'assets/images/clone.png'
    @time = 0
  represent: (@drawables) ->
  paint: ->
    @time++
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    @ctx.fillStyle = "rgb(10, 200, 10)"
    @paintSpikes(s) for s in @drawables.spikes
    @paintStaticRects(r) for r in @drawables.staticRects
    @paintStatic(s) for s in @drawables.staticPolygons
    @paintClones(@drawables.clones)
    @paintPlayer(@drawables.player)
    @paintGoal(@drawables.goal)
    @paintGhosts(@drawables.ghosts)

  ###########
  # private #
  ###########

  paintStaticRects: (rect) ->
    @ctx.fillRect(@scale(rect.x), @scale(rect.y), @scale(rect.w), @scale(rect.h))
  paintStatic: (polygon) ->
    first = polygon[0]
    @ctx.beginPath()
    @ctx.moveTo(@scale(first.x), @scale(first.y))
    for point in polygon
      @ctx.lineTo(@scale(point.x), @scale(point.y))
    @ctx.lineTo(@scale(first.x), @scale(first.y))
    @ctx.closePath()
    @ctx.fill()

  paintSpikes: (spikes) ->
    @ctx.lineWidth = 1
    @ctx.strokeStyle = 'white'
    spikeLength = 4
    space = 5

    x = @scale(spikes.x1)
    y = @scale(spikes.y1)
    endX = @scale(spikes.x2)
    endY = @scale(spikes.y2)

    dx = endX - x
    dy = endY - y

    @ctx.beginPath()
    # assuming it's left to right
    while(x <= endX && y <= endY)
      @ctx.moveTo(x - spikeLength, y + spikeLength)
      @ctx.lineTo(x + spikeLength, y - spikeLength)
      @ctx.moveTo(x - spikeLength, y - spikeLength)
      @ctx.lineTo(x + spikeLength, y + spikeLength)
      x += space
    @ctx.closePath()
    @ctx.stroke()

  paintClones: (clones) ->
    @paintObject(clone, @cloneImg) for clone in clones

  paintPlayer: (player) ->
    if player.dead
      @paintObject(player, @spikedPlayerImg)
    else
      @paintObject(player, @playerImg)

  paintGoal: (goal) ->
    @ctx.beginPath()

    x = @scale(goal.x())
    y = @scale(goal.y())
    r = @scale(goal.r())

    glow = (Math.abs(Math.sin(@time / 15)) * 3) + 1
    grd = @ctx.createRadialGradient(x, y, r, x, y, r + (r * glow))
    grd.addColorStop(0.0, 'rgba(255, 255, 255, 1.0)')
    grd.addColorStop(0.2, 'rgba(255, 255, 255, 0.9)')
    grd.addColorStop(0.4, 'rgba(255, 255, 255, 0.2)')
    grd.addColorStop(1.0, 'rgba(255, 255, 255, 0.0)')

    @ctx.arc(x, y, r + (r * glow), 0, 2 * Math.PI, false)
    @ctx.fillStyle = grd
    @ctx.fill()
  paintGhosts: (ghosts) ->
    for ghost in ghosts
      x = @scale(ghost.x())
      y = @scale(ghost.y())
      r = @scale(ghost.r())
      @ctx.beginPath()
      @ctx.arc(x, y, r, 0, 2 * Math.PI, false)
      @ctx.fillStyle = "rgba(255, 50, 50, 0.5)"
      @ctx.fill()


  paintObject: (object, image) ->
    @ctx.save()
    @ctx.translate(@scale(object.x()), @scale(object.y()))
    @ctx.rotate(object.a())
    r = @scale(object.r())
    @ctx.drawImage(image, -r, -r, 2*r, 2*r)
    @ctx.restore()
  scale: (num) ->
    num * scale
