requirejs.config({
  # Lots of helpful options here: http://requirejs.org/docs/api.html#config
  paths:
    jquery: 'vendor/jquery-1.8.2'
    box2d: 'vendor/Box2dWeb-2.1.a.3'
})

require ['controller'], (Controller) ->
  Controller.setup()
