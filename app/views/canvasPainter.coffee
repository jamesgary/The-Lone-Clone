define ->
  scale = 30
  widthPad = 20
  heightPad = 5
  textSize = 24
  lineHeight = 30
  init: (canvas1, canvas2, canvas3, canvas4) ->
    self = this
    @time = 0
    @canvasWidth  = canvas1.width
    @canvasHeight = canvas1.height
    @ctx1 = canvas1.getContext('2d')
    @ctx2 = canvas2.getContext('2d')
    @ctx3 = canvas3.getContext('2d')
    @ctx4 = canvas4.getContext('2d')

    @playerImg = new Image()
    @playerImg.src= 'assets/images/player.png'
    @cloneImg = new Image()
    @cloneImg.src= 'assets/images/clone.png'
    @spikedPlayerImg = new Image()
    @spikedPlayerImg.src= 'assets/images/spiked_player.png'
    @spikedCloneImg = new Image()
    @spikedCloneImg.src= 'assets/images/spiked_clone.png'
    @platformImg = new Image()
    @platformImg.src= 'assets/images/platform2.png'
    @ghostImage = new Image()
    @ghostImage.src= 'assets/images/ghost.png'

    @imagesToLoad = [
      @playerImg
      @cloneImg
      @spikedPlayerImg
      @spikedCloneImg
      @platformImg
      @ghostImage
    ]
    @totalImagesLoaded = 0
    for image in @imagesToLoad
      orig = image.onload
      image.onload = ->
        self.totalImagesLoaded++
        if this.src.indexOf('assets/images/platform2.png') >= 0
          self.platformPattern = self.ctx3.createPattern(this, 'repeat')
  represent: (@drawables) ->
    # reverse hierarchy (STATIC IS CAPS)
    #
    # 1
    # - SPIKES
    # 2
    # - players, clones
    # - movers
    # - goal
    # - lava
    # 3
    # - PLATFORMS
    # - TEXT
    # 4
    # - ghosts
    if @drawables
      # draw static items once
      @ctx = @ctx1
      @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)
      @paintSpikes(@drawables.spikes)

      @ctx = @ctx3
      @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)
      @paintPlatforms(@drawables.platforms)
      @paintTexts(@drawables.texts)

      # cache lava coordinates
      for lava in @drawables.lavas
        lava.minX = lava.minY = 9000 # nothing is over 9000!
        lava.maxX = lava.maxY = 0
        for vertex in lava.vertices()
          lava.maxX = vertex.x if vertex.x > lava.maxX
          lava.minX = vertex.x if vertex.x < lava.minX
          lava.maxY = vertex.y if vertex.y > lava.maxY
          lava.minY = vertex.y if vertex.y < lava.minY
        lava.minX = @scale(lava.minX)
        lava.minY = @scale(lava.minY)
        lava.maxX = @scale(lava.maxX)
        lava.maxY = @scale(lava.maxY)
        lava.drawingWidth = lava.maxX - lava.minX
        lava.drawingHeight = lava.maxY - lava.minY
  paint: ->
    if @drawables && @staticsPainted
      @time++

      @ctx = @ctx2
      @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)
      @paintPlayer(@drawables.player)
      @paintClones(@drawables.clones)
      @paintMovers(@drawables.movers) if @drawables.movers
      @paintGoal(@drawables.goal)
      @paintLavas(@drawables.lavas) if @drawables.lavas

      @ctx = @ctx4
      @ctx.clearRect(0, 0, @canvasWidth, @canvasHeight)
      @paintGhosts(@drawables.ghosts) if @drawables.ghosts
    else
      if @totalImagesLoaded == @imagesToLoad.length
        @staticsPainted = true
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
    #@paintPolygons(lavas)
    for lava in lavas
      grd = @ctx.createLinearGradient(0,lava.minY,0,lava.maxY)
      grd.addColorStop(0.0, 'rgba(255, 0, 0, 0.0)')
      grd.addColorStop(0.3, 'rgba(255, 0, 0, 1.0)')
      @ctx.fillStyle = grd
      @ctx.fillRect(lava.minX, lava.minY, lava.drawingWidth, lava.drawingHeight)

      for i in [1..50]
        g = parseInt(255 * Math.random())
        a = Math.sqrt(Math.random())
        @ctx.fillStyle = "rgba(255, #{ g }, 0, #{ a })"
        randWidth  = (100 + lava.drawingWidth * Math.random()) / 10
        randHeight = lava.drawingHeight * Math.random()
        randX  = lava.minX + (lava.drawingWidth  * Math.random()) - (.5 * randWidth)
        randY  = lava.minY + (lava.drawingHeight * Math.random()) - (.5 * randHeight)
        @ctx.fillRect(randX, randY, randWidth, randHeight)

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
    @ctx.strokeStyle = 'gray'
    @ctx.fillStyle = 'white'
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

      xSpace = dx / numSpikes
      ySpace = dy / numSpikes
      for i in [0...numSpikes]
        x += xSpace
        y += ySpace
        @ctx.beginPath()
        @ctx.lineTo(x, y + spikeLength)
        @ctx.lineTo(x + spikeLength, y)
        @ctx.lineTo(x, y - spikeLength)
        @ctx.lineTo(x - spikeLength, y)
        @ctx.closePath()
        @ctx.fill()
        #@ctx.stroke()

  paintClones: (clones) ->
    for clone in clones
      if clone.dead
        @paintObject(clone, @spikedCloneImg)
      else
        @paintObject(clone, @cloneImg)

  paintPlayer: (player) ->
    if player.dead
      @paintObject(player, @spikedPlayerImg)
    else
      @paintObject(player, @playerImg)

  paintGoal: (goal) ->
    @ctx.beginPath()

    x = @scale(goal.x())
    y = @scale(goal.y())
    r = @scale(0.1)

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
    @ctx.globalAlpha = 0.7
    for ghost in ghosts
      w = @scale(ghost.r() * 7) + (3 * Math.sin(@time/10))
      h = @scale(ghost.r() * 7) + (3 * Math.cos(@time/10))
      x = @scale(ghost.x()) - (.5 * w)
      y = @scale(ghost.y()) - (.5 * h)
      @ctx.drawImage(@ghostImage, x, y, w, h)
    @ctx.globalAlpha = 1.0
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
