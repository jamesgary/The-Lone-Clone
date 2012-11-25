define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop'], ($, Playground, CanvasPainter, GameLoop) ->
  playing = false

  setUpGame = -> # do this once
    level = location.href.split('level=')[1] || 1
    Playground.startLevel(level)
    CanvasPainter.init(document.getElementById("my-canvas"))
    setUpLevel()
  setUpLevel = -> # do this for each level
    CanvasPainter.represent(Playground.drawables())
    playing = true
    Playground.onLevelWin(->
      $(".level-complete").show()
      playing = false
    )

  setUpInput = ->
    $('body').keyup((e) ->
      key = String.fromCharCode(e.which).toLowerCase()
      switch key
        when 'w' then Playground.stopCloningUp()
        when 'a' then Playground.stopCloningLeft()
        when 's' then Playground.stopCloningDown()
        when 'd' then Playground.stopCloningRight()
      e.stopPropagation()
    )
    $('body').keydown((e) ->
      key = String.fromCharCode(e.which).toLowerCase()
      if playing
        switch key
          when 'w' then Playground.cloningUp()
          when 'a' then Playground.cloningLeft()
          when 's' then Playground.cloningDown()
          when 'd' then Playground.cloningRight()
      else
        if key == ' '
          Playground.startNextLevel()
          setUpLevel()
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

