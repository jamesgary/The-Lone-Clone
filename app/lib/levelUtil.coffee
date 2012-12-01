# explicitly list levels due to limitations in the r.js optimizer's static analysis
# see http://requirejs.org/docs/optimization.html for more info
define [
  "text!data/levelMaps/1.svg"
  "text!data/levelMaps/2.svg"
  "text!data/levelMaps/3.svg"
  "text!data/levelMaps/4.svg"
  "text!data/levelMaps/5.svg"
  "text!data/levelMaps/6.svg"
  "text!data/levelMaps/7.svg"
  "text!data/levelMaps/8.svg"
  "text!data/levelMaps/9.svg"
  "text!data/levelMaps/10.svg"
  "text!data/levelMaps/11.svg"
  "text!data/levelMaps/12.svg"
  "text!data/levelMaps/13.svg"
  "text!data/levelMaps/14.svg"
  "text!data/levelMaps/15.svg"
  "text!data/levelMaps/16.svg"
], (levels...) ->
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
    level.texts     = @findTexts()
    level

  ###########
  # private #
  ###########

  findStart: ->
    for circle in @svg.getElementsByTagName('circle')
      if @isGreen(circle.style.fill)
        return @locateCircle(circle)
  findGoal: ->
    for circle in @svg.getElementsByTagName('circle')
      if @isLightBlue(circle.style.fill)
        return @locateCircle(circle)
  findGhosts: ->
    ghosts = []
    for circle in @svg.getElementsByTagName('circle')
      if @isRed(circle.style.fill)
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
      if @isBlue(path.style.stroke)
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
      if @isGreen(path.style.fill)
        polygons.push(@getCoordinatesForPath(path))
    polygons
  findSpikes: ->
    spikes = []
    for path in @svg.getElementsByTagName('path')
      if @isPink(path.style.color) ||
         @isPink(path.style.stroke)
        spikes.push(@getCoordinatesForPath(path))
    spikes
  findTexts: ->
    for text in @svg.getElementsByTagName('text')
      spans = for span in text.getElementsByTagName('tspan')
        span.textContent
      {
        x: @scale(text.x.baseVal.getItem(0).value)
        y: @scale(text.y.baseVal.getItem(0).value)
        text: spans.join('\n')
      }

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
    @isRed(rect.style.fill)

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

  # this sucks, but i'm up against a deadline
  isGreen:     (color) -> color == 'rgb(0, 255, 0)'   || color == '#00ff00'
  isLightBlue: (color) -> color == 'rgb(0, 255, 255)' || color == '#00ffff'
  isRed:       (color) -> color == 'rgb(255, 0, 0)'   || color == '#ff0000'
  isBlue:      (color) -> color == 'rgb(0, 0, 255)'   || color == '#0000ff'
  isPink:      (color) -> color == 'rgb(255, 0, 255)' || color == '#ff00ff'
