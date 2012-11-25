define ['lib/physics/physics'], (Physics) ->
  class Circle
    constructor: (circleData) ->
      trimmedData =
        x: circleData.x
        y: circleData.y
        r: circleData.r
      func = if circleData.isStatic then 'addStaticCircle' else 'addCircle'
      @physicalCircle = Physics[func](trimmedData)
      @physicalCircle.userdata = this
    x: (newX) ->
      if newX
        @physicalCircle.SetPosition({ x: newX })
      else
        @physicalCircle.GetPosition().x
    y: (newY) ->
      if newY
        @physicalCircle.SetPosition({ y: newY })
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

