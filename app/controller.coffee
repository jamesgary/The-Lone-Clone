define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop'], ($, Playground, CanvasPainter, GameLoop) ->
  cloneUp = cloneLeft = cloneRight = cloneDown = false
  setup: ->
    $('document').ready ->
      Playground.init()
      CanvasPainter.init(document.getElementById("my-canvas"))
      CanvasPainter.represent(Playground)

      $('body').keyup((e) ->
        key = String.fromCharCode(e.which).toLowerCase()
        switch key
          when 'w' then Playground.cloneUp    = false
          when 'a' then Playground.cloneLeft  = false
          when 's' then Playground.cloneDown  = false
          when 'd' then Playground.cloneRight = false
        e.stopPropagation()
      )

      $('body').keydown((e) ->
        key = String.fromCharCode(e.which).toLowerCase()
        switch key
          when 'w' then Playground.cloneUp    = true
          when 'a' then Playground.cloneLeft  = true
          when 's' then Playground.cloneDown  = true
          when 'd' then Playground.cloneRight = true
        e.stopPropagation()
      )

      GameLoop.loop ->
        Playground.update()
        CanvasPainter.paint()
