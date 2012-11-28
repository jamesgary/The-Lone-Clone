HIGHEST_LEVEL = 7
files = for i in [1..HIGHEST_LEVEL]
  "text!data/levels/#{i}.svg"

define files, (levels...) ->
  # return {rects: [...], polygons: [...], circles: [...], start, goal}
  load: (levelNum) ->
    level = {
      rects: []
      polygons: []
      circles: []
    }
    svgString = levels[levelNum - 1]
    @svg = (new DOMParser()).parseFromString(svgString, "text/xml")

    # these methods give back plain objects
    level.start     = @findStart()
    level.goal      = @findGoal()
    level.spikes    = @findSpikes()
    level.ghosts    = @findGhosts()
    level.movers    = @findMovers()
    level.platforms = @findPlatforms().concat(@findRectifiedPaths()).concat(@findPolygons())
    level.lavas     = @findLavas()
    level

  ###########
  # private #
  ###########

  findStart: ->
    for circle in @svg.getElementsByTagName('circle')
      if circle.style.fill == '#00ff00' # green is player
        return @locateCircle(circle)
  findGoal: ->
    for circle in @svg.getElementsByTagName('circle')
      if circle.style.fill == '#00ffff' # light blue is goal
        return @locateCircle(circle)
  findGhosts: ->
    ghosts = []
    for circle in @svg.getElementsByTagName('circle')
      if circle.style.fill == '#ff0000' # red is ghost
        ghosts.push(@locateCircle(circle))
    ghosts
  findPlatforms: ->
    polygons = []
    for rect in @svg.getElementsByTagName('rect')
      if @isPlatform(rect)
        polygons.push(@verticesFromRect(rect))
    polygons
  findMovers: ->
    polygons = []
    for rect in @svg.getElementsByTagName('rect')
      if @isMover(rect)
        polygons.push(@verticesFromRect(rect))
    polygons
  findLavas: ->
    polygons = []
    for rect in @svg.getElementsByTagName('rect')
      if @isLava(rect)
        polygons.push(@verticesFromRect(rect))
    polygons
  findRectifiedPaths: ->
    thickness = .1
    polygons = []
    for path in @svg.getElementsByTagName('path')
      if path.style.stroke == '#0000ff'
        coordinates = @getCoordinatesForPath(path)
        polygons = for i in [0...coordinates.length - 1]
          c1 = coordinates[i]
          c2 = coordinates[i + 1]
          # The dimensions of the line are:
          width = c2.x - c1.x
          height = c2.y - c1.y
          # To find the length of the line, use Pythagoras's theorem:
          length = Math.sqrt(Math.pow(width, 2) + Math.pow(height, 2))
          # Now the shifts:
          xS = (thickness * height / length)
          yS = (thickness * width / length)
          [
            { x: c1.x - xS, y: c1.y + yS }
            { x: c1.x + xS, y: c1.y - yS }
            { x: c2.x + xS, y: c2.y - yS }
            { x: c2.x - xS, y: c2.y + yS }
          ]
    polygons
  findPolygons: ->
    polygons = []
    for path in @svg.getElementsByTagName('path')
      if path.style.fill == '#00ff00'
        polygons.push(@getCoordinatesForPath(path))
    polygons
  findSpikes: ->
    spikes = []
    for path in @svg.getElementsByTagName('path')
      if (
        path.style.color  == '#ff00ff' ||
        path.style.stroke == '#ff00ff'
      )
        spikes.push(@getCoordinatesForPath(path))
    spikes

  locateCircle: (circle) ->
    # gotta transform *grumble grumble*
    attr = circle.getAttribute('transform') # <circle transform="translate(123,456)"/>
    regexForX = new RegExp("\\((.*),")
    regexForY = new RegExp(",(.*)\\)")
    x = regexForX.exec(attr)[1]
    y = regexForY.exec(attr)[1]
    {
      x: @scale(circle.cx.baseVal.value + x)
      y: @scale(circle.cy.baseVal.value + y)
    }
  verticesFromRect: (rect) ->
    x = @scale(rect.x.baseVal.value)
    y = @scale(rect.y.baseVal.value)
    w = @scale(rect.width.baseVal.value)
    h = @scale(rect.height.baseVal.value)
    vertices = []
    vertices[0] = { x: x,     y: y }
    vertices[1] = { x: x + w, y: y }
    vertices[2] = { x: x + w, y: y + h }
    vertices[3] = { x: x,     y: y + h }
    vertices

  isPlatform: (rect) ->
    !@isLava(rect) && !@isMover(rect)
  isMover: (rect) ->
    !@isLava(rect) && rect.id.indexOf('mover') == 0
  isLava: (rect) ->
    rect.style.fill == '#ff0000'

  getCoordinatesForPath: (path) ->
    d = path.getAttribute('d')
    if d.indexOf('M') == 0 # absolute move coordinates
      numbers = d.match(/(-?\d+\.?\d*)/g)
      for i in [0...numbers.length] by 2
        {
          x: @scale(parseFloat(numbers[i]))
          y: @scale(parseFloat(numbers[i + 1]))
        }
    else # relative
      numbers = for num in d.match(/(-?\d+\.?\d*)/g)
        @scale(parseFloat(num))
      currentPos = { x: numbers[0], y: numbers[1] }
      coordinates = [currentPos]
      for i in [2...numbers.length] by 2
        currentPos =
          x: currentPos.x + numbers[i]
          y: currentPos.y + numbers[i + 1]
        coordinates.push(currentPos)
      coordinates

  scale: (val) ->
    val / 30.0
