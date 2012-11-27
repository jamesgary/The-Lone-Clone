define ['lib/physics/physics'], (Physics) ->
  class Polygon
    constructor: (polygonData) ->
      @physicalPolygon = Physics.addStaticPolygon(polygonData)
      @physicalPolygon.userdata = this
    x: (newX) ->
      if newX
        @physicalPolygon.SetPosition({ x: newX, y: @y()})
      else
        @physicalPolygon.GetPosition().x
    y: (newY) ->
      if newY
        @physicalPolygon.SetPosition({ y: newY, x: @x() })
      else
        @physicalPolygon.GetPosition().y
    vertices: ->
      @physicalPolygon.GetFixtureList().GetShape().GetVertices()
