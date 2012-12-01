define ['lib/physics/circle'], (Circle) ->
  GOAL_RAD = .01

  class Goal extends Circle
    constructor: (circleData) ->
      circleData.r = GOAL_RAD
      circleData.isStatic = true
      super(circleData)
