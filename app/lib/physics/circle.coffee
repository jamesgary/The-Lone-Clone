define ['lib/physics/physics'], (Physics) ->
  class Circle
    constructor: (circleData) ->
      func = if circleData.isStatic then 'addStaticCircle' else 'addCircle'
      @physicalCircle = Physics[func](circleData)
      @physicalCircle.userdata = this
    x: (newX) ->
      if newX
        @physicalCircle.SetPosition({ x: newX, y: @y()})
      else
        @physicalCircle.GetPosition().x
    y: (newY) ->
      if newY
        @physicalCircle.SetPosition({ y: newY, x: @x() })
      else
        @physicalCircle.GetPosition().y
    a: (newA) ->
      if newA
        @physicalCircle.SetAngle(newA)
      else
        @physicalCircle.GetAngle()
    r: (newR) ->
      if newR
        @physicalCircle.GetFixtureList().GetShape().SetRadius(newR)
      else
        @physicalCircle.GetFixtureList().GetShape().GetRadius()
    freeze: ->
      Physics.freeze(@physicalCircle)
