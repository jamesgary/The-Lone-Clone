HIGHEST_LEVEL = 4
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
    #svgString = levels[levelNum - 1]
    svgString = levels[4 - 1] # FIXME TESTING
    @svg = (new DOMParser()).parseFromString(svgString, "text/xml")

    # these methods give back plain objects
    level.start    = @findStart()
    level.goal     = @findGoal()
    level.rects    = @findRects()
    level.spikes   = @findSpikes()
    level.polygons = @findRectifiedPaths()
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
  findRects: ->
    for rect in @svg.getElementsByTagName('rect')
      {
        x: @scale(rect.x.baseVal.value)
        y: @scale(rect.y.baseVal.value)
        w: @scale(rect.width.baseVal.value)
        h: @scale(rect.height.baseVal.value)
      }
  findRectifiedPaths: ->
    thickness = .1
    polygons = []
    for path in @svg.getElementsByTagName('path')
      if path.style.color != '#ff00ff'
        d = path.getAttribute('d')
        d = d.substr(1) # remove initial 'M'
        coordinates = d.split('L')
        coordinates = for string in coordinates
          s = string.split(' ')
          {
            x: @scale(s[0])
            y: @scale(s[1])
          }
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
  findSpikes: ->
    spikes = []
    for path in @svg.getElementsByTagName('path')
      if (
        path.style.color  == '#ff00ff' ||
        path.style.stroke == '#ff00ff'
      )
        # expecting one line: d="m 117,221 376,0"
        d = path.getAttribute('d')
        d = d.substr(2) # remove initial 'm '
        d = d.split(' ')
        d = for dd in d
          dd.split(',')
        x  = parseInt d[0][0]
        y  = parseInt d[0][1]
        dx = parseInt d[1][0]
        dy = parseInt d[1][1]
        spikes.push([
          {
            x: @scale(x)
            y: @scale(y)
          },
          {
            x: @scale(x + dx)
            y: @scale(y + dy)
          }
        ])
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

  scale: (val) ->
    val / 30.0
