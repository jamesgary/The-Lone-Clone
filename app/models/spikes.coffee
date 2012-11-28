define ['lib/physics/physics'], (Physics) ->
  class Spikes
    constructor: (lineData) ->
      @x1 = lineData[0].x
      @y1 = lineData[0].y
      @x2 = lineData[1].x
      @y2 = lineData[1].y
      @physicalLine = Physics.addStaticLine(lineData)
      @physicalLine.userdata = this
