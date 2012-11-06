define ->
  class Circle
    constructor: (@physicalCircle) ->
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
