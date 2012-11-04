define ['lib/physics'], (Physics) ->
  init: (canvas) ->
    Physics.setupCanvas(canvas)
    Physics.createGround() # pass in some json data
    Physics.createPlayer()
    #Physics.generateObjects()
    Physics.go()
  cloneRight: ->
    Physics.cloneRight()
