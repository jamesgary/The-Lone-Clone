define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop'], ($, Playground, CanvasPainter, GameLoop) ->
  playing = cloneUp = cloneLeft = cloneRight = cloneDown = false

  setUpGame = ->
    Playground.init()
    CanvasPainter.init(document.getElementById("my-canvas"))
    CanvasPainter.represent(Playground.drawables())
    playing = true
    Playground.onLevelWin(->
      $(".level-complete").show()
      Playground.cloneUp    = false
      Playground.cloneLeft  = false
      Playground.cloneDown  = false
      Playground.cloneRight = false
      playing = false
    )

  setUpInput = ->
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
      if playing
        switch key
          when 'w' then Playground.cloneUp    = true
          when 'a' then Playground.cloneLeft  = true
          when 's' then Playground.cloneDown  = true
          when 'd' then Playground.cloneRight = true
      else
        if key == ' '
          Playground.startNextLevel()
          $(".level-complete").hide()
          playing = true
      e.stopPropagation()
    )
    $('a.start').click ->
      showDiv('level-select')
    $('.level').click ->
      levelNumber = $(this).data().level
      Playground.startLevel(levelNumber)
      showDiv('playground')

  startGame = ->
    GameLoop.loop ->
      Playground.update()
      CanvasPainter.paint()

  showDiv = (div) ->
    $(".#{div}").show()
    $(".container > div:not(.#{div})").hide()

  setup: ->
    $('document').ready ->
      setUpGame()
      setUpInput()
      startGame()
      #showDiv('level-select') # for testing
      showDiv('playground') # for testing
      $(".level-complete").hide()
      #showDiv('level-complete') # for testing

