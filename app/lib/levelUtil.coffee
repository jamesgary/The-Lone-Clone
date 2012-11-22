HIGHEST_LEVEL = 2
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
    svg = levels[levelNum - 1]
    svg = (new DOMParser()).parseFromString(svg, "text/xml")
    for rect in svg.getElementsByTagName('rect')
      level.rects.push(
        x: @scale(rect.x.baseVal.value)
        y: @scale(rect.y.baseVal.value)
        w: @scale(rect.width.baseVal.value)
        h: @scale(rect.height.baseVal.value)
      )
    for circle in svg.getElementsByTagName('circle')
      console.log(circle)
      if circle.style.fill == '#00ff00' # green is player
        # gotta transform *grumble grumble*
        attr = circle.getAttribute('transform') # <circle transform="translate(123,456)"/>
        regexForX = new RegExp("\\((.*),")
        regexForY = new RegExp(",(.*)\\)")
        x = regexForX.exec(attr)[1]
        y = regexForY.exec(attr)[1]
        level.start = {
          x: @scale(circle.cx.baseVal.value + x)
          y: @scale(circle.cy.baseVal.value + y)
        }
      if circle.style.fill == '#00ffff' # light blue is goal
        # gotta transform *grumble grumble*
        attr = circle.getAttribute('transform') # <circle transform="translate(123,456)"/>
        regexForX = new RegExp("\\((.*),")
        regexForY = new RegExp(",(.*)\\)")
        x = regexForX.exec(attr)[1]
        y = regexForY.exec(attr)[1]
        level.goal = {
          x: @scale(circle.cx.baseVal.value + x)
          y: @scale(circle.cy.baseVal.value + y)
        }
    level

  ###########
  # private #
  ###########

  scale: (val) ->
    val / 30.0
