define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop'], ($, Playground, CanvasPainter, GameLoop) ->
  setup: ->
    $('document').ready ->
      Playground.init()
      CanvasPainter.init(document.getElementById("my-canvas"))
      CanvasPainter.represent(Playground)

      $('body').keypress((e) ->
        key = String.fromCharCode(e.which)
        switch key
          when 'w' then Playground.cloneUp()
          when 'a' then Playground.cloneLeft()
          when 's' then Playground.cloneDown()
          when 'd' then Playground.cloneRight()
        e.stopPropagation()
      )

      GameLoop.loop ->
        Playground.update()
        CanvasPainter.paint()
