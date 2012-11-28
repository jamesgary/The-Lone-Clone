define ['models/platform', 'lib/physics/physics'], (Polygon, Physics) ->
  class Spikes extends Polygon
    constructor: (lineData) ->
      @x1 = lineData[0].x
      @y1 = lineData[0].y
      @x2 = lineData[1].x
      @y2 = lineData[1].y
      @physicalPolygon = Physics.addStaticPolygon(lineData)
      @physicalPolygon.userdata = this
