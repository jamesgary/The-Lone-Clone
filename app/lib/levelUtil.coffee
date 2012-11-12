define ['text!data/levels/1.svg'], (level1) ->
  levels = [
    null # to skip level 0
    level1
  ]
  # return {rects: [...], polygons: [...], circles: [...]}
  load: (levelNum) ->
    level = {
      rects: []
      polygons: []
      circles: []
    }
    svg = levels[levelNum]
    svg = (new DOMParser()).parseFromString(svg, "text/xml")
    for rect in svg.getElementsByTagName('rect')
      level.rects.push(
        x: @scale(rect.x.baseVal.value)
        y: @scale(rect.y.baseVal.value)
        w: @scale(rect.width.baseVal.value)
        h: @scale(rect.height.baseVal.value)
      )
    window.level = level
    level

  scale: (val) ->
    val / 30.0

  # POOP BELOW

  # return {rects: [...], polygons: [...], circles: [...]}
  loadFromSomeOtherEditor: (levelNum) ->
    level = {
      rects: []
      polygons: []
      circles: []
    }
    levelData = levels[levelNum]
    regex = /^,?(\[.*\])/gm
    while shape = regex.exec(levelData)
      #order: x , y , height, width, rotation, isDynamic, shape, & vertices
      shape = JSON.parse(shape[1].replace(/'/g, '"'))
      x      = shape[0]
      y      = shape[1]
      height = shape[2]
      width  = shape[3]
      if shape[6] == 'SQUARE'
        rect = {
          x: 20 + x
          y: 20 - y
          h: height
          w: width
        }
        level.rects.push(rect)
    level

  # for physics body editor tool
  leadPBE: ->
    levelData = JSON.parse(levelData)
    @statics = for polygon in levelData.rigidBodies[0].polygons
      Physics.addStatic(polygon.reverse())
