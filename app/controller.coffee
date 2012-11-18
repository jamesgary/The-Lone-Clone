define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop'], ($, Playground, CanvasPainter, GameLoop) ->
  cloneUp = cloneLeft = cloneRight = cloneDown = false
  setup: ->
    self = this
    $('document').ready ->
      self.setUpGame()
      self.setUpInput()
      self.startGame()

  ###########
  # private #
  ###########

  setUpGame: ->
    Playground.init()
    CanvasPainter.init(document.getElementById("my-canvas"))
    CanvasPainter.represent(Playground)

  setUpInput: ->
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
    $('a.start').click ->
      $('.level-select').show()
      $('.container > div:not(.level-select)').hide()

  startGame: ->
    GameLoop.loop ->
      Playground.update()
      CanvasPainter.paint()
