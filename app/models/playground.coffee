define ['lib/physics'], (Physics) ->
  init: (canvas) ->
    Physics.setupCanvas(canvas)
    Physics.createGround() # pass in some json data
    Physics.generateObjects()
    Physics.go()
