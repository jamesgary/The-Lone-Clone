define ['lib/physics/physics'], (Physics) ->
  class Polygon
    constructor: (polygonData) ->
      @physicalPolygon = Physics.addStaticPolygon(polygonData)
      @physicalPolygon.userdata = this
    transform: (shift) ->
      #t = @physicalPolygon.GetTransform()
      #t.position.x += shift.x if shift.x
      #t.position.y += shift.y if shift.y
      #@physicalPolygon.SetTransform(t)

      @physicalPolygon.SetLinearVelocity(x: shift.x || 0, y: shift.y || 0)
    vertices: ->
      pos = @physicalPolygon.GetTransform().position
      for vert in @physicalPolygon.GetFixtureList().GetShape().GetVertices()
        x: vert.x + pos.x
        y: vert.y + pos.y

    # NOTE: generally the top/left
    x: ->
      @vertices()[0].x
    y: ->
      @vertices()[0].y
