define ->
  scale = 30
  widthPad = 20
  heightPad = 5
  textSize = 24
  lineHeight = 30
  init: (@bgCanvas, @fgCanvas) ->
    self = this
    @bg = @bgCanvas.getContext('2d')
    @fg = @fgCanvas.getContext('2d')
    @playerImg = new Image()
    @playerImg.src= 'assets/images/player.png'
    @spikedPlayerImg = new Image()
    @spikedPlayerImg.src= 'assets/images/spiked_player.png'
    @cloneImg = new Image()
    @cloneImg.src= 'assets/images/clone.png'
    @platformImg = new Image()
    @platformImg.src= 'assets/images/platform2.png'
    @time = 0
    @imagesToLoad = [
      @playerImg
      @spikedPlayerImg
      @cloneImg
      @platformImg
    ]
    @totalImagesLoaded = 0
    for image in @imagesToLoad
      orig = image.onload
      image.onload = ->
        self.totalImagesLoaded++
        if this.src.indexOf('assets/images/platform2.png') >= 0
          self.platformPattern = self.bg.createPattern(this, 'repeat')
  represent: (@drawables) ->
    if @drawables
      @ctx = @bg
      # draw static items once
      @bg.clearRect(0, 0, @bgCanvas.width, @bgCanvas.height)
      @paintSpikes(@drawables.spikes)
      @paintPlatforms(@drawables.platforms)
      @paintTexts(@drawables.texts)
      @ctx = @fg
  paint: ->
    if @drawables && @foregroundPainted
      @time++
      @ctx.clearRect(0, 0, @bgCanvas.width, @bgCanvas.height)
      @paintMovers(@drawables.movers) if @drawables.movers
      @paintClones(@drawables.clones)
      @paintPlayer(@drawables.player)
      @paintLavas(@drawables.lavas) if @drawables.lavas # shit.
      @paintGoal(@drawables.goal)
      @paintGhosts(@drawables.ghosts) if @drawables.ghosts
    else
      if @totalImagesLoaded == @imagesToLoad.length
        @foregroundPainted = true
      @represent(@drawables) # just to make sure

  ###########
  # private #
  ###########

  paintPlatforms: (platforms) ->
    @ctx.lineWidth = 0
    @ctx.strokeStyle = 'rgba(100, 100, 100, 0)'
    @ctx.fillStyle = @platformPattern || 'rgb(50,50,50)'
    @paintPolygons(platforms)

  paintLavas: (lavas) ->
    @ctx.fillStyle = "rgb(255, 0, 0)"
    @paintPolygons(lavas)

  paintMovers: (movers) ->
    @ctx.fillStyle = "rgb(200, 200, 200)"
    @paintPolygons(movers)

  paintPolygons: (polygons) ->
    for polygon in polygons
      firstVertex = polygon.vertices()[0]
      @ctx.beginPath()
      @ctx.moveTo(@scale(firstVertex.x), @scale(firstVertex.y))
      for vertex in polygon.vertices()
        @ctx.lineTo(@scale(vertex.x), @scale(vertex.y))
      @ctx.closePath()
      @ctx.stroke()
      @ctx.fill()


  paintSpikes: (allSpikes) ->
    @ctx.lineWidth = 1
    @ctx.strokeStyle = 'white'
    spikeLength = 10
    space = 20
    for spikes in allSpikes
      x = @scale(spikes.x1)
      y = @scale(spikes.y1)
      endX = @scale(spikes.x2)
      endY = @scale(spikes.y2)

      dx = endX - x
      dy = endY - y
      length = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
      numSpikes = 1 + (length / space)

      @ctx.beginPath()
      xSpace = dx / numSpikes
      ySpace = dy / numSpikes
      for i in [0...numSpikes]
        x += xSpace
        y += ySpace
        @ctx.moveTo(x - spikeLength, y + spikeLength)
        @ctx.lineTo(x + spikeLength, y - spikeLength)
        @ctx.moveTo(x - spikeLength, y - spikeLength)
        @ctx.lineTo(x + spikeLength, y + spikeLength)
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
    @ctx.fillStyle = "rgba(255, 50, 50, 0.5)"
    for ghost in ghosts
      x = @scale(ghost.x())
      y = @scale(ghost.y())
      r = @scale(ghost.r())
      @ctx.beginPath()
      @ctx.arc(x, y, r, 0, 2 * Math.PI, false)
      @ctx.fill()
  paintTexts: (texts) ->
    @ctx.font = "#{ textSize }px sans-serif"
    for text in texts
      x = @scale(text.x)
      y = @scale(text.y)
      textLines = text.text.split('\n')

      # draw containing box, find width
      maxWidth = 0
      for textLine in textLines
        width = @ctx.measureText(textLine)
        maxWidth = width.width if width.width > maxWidth
      @ctx.fillStyle = "rgba(0, 0, 0, .7)"
      @ctx.fillRect(
        x - widthPad,
        y - lineHeight - heightPad,
        maxWidth + (widthPad * 2),
        (30 * (textLines.length - 1)) + (lineHeight * 1.5) + (heightPad * 2)
      )

      # draw actual text
      yShift = 0
      @ctx.fillStyle = "rgba(255, 255, 255, 1.0)"
      for textLine in textLines
        @ctx.fillText(textLine, @scale(text.x), @scale(text.y) + yShift)
        yShift += lineHeight

  paintObject: (object, image) ->
    @ctx.save()
    @ctx.translate(@scale(object.x()), @scale(object.y()))
    @ctx.rotate(object.a())
    r = @scale(object.r())
    @ctx.drawImage(image, -r, -r, 2*r, 2*r)
    @ctx.restore()
  scale: (num) ->
    num * scale
