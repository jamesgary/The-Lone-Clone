define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop', 'views/trippyBackground'], ($, Playground, CanvasPainter, GameLoop, TrippyBackground) ->
  playing = won = lost = false

  setUpGame = -> # do this once
    level = parseInt(location.href.split('level=')[1]) || 1
    Playground.startLevel(level)
    CanvasPainter.init(document.getElementById("foreground"))
    setUpLevel()
  setUpLevel = -> # do this for each level
    CanvasPainter.represent(Playground.drawables())
    playing = true
    won = lost = false
    Playground.onLevelWin(->
      $(".level-complete").show()
      playing = false
      won = true
    )
    Playground.onLevelLose(->
      $(".level-fail").show()
      playing = false
      lost = true
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
          if won
            Playground.startNextLevel()
            setUpLevel()
            $(".level-complete").hide()
            playing = true
          else if lost
            Playground.restart()
            setUpLevel()
            $(".level-fail").hide()
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
      $(".level-fail").hide()
      #showDiv('level-complete') # for testing
      TrippyBackground.setup(document.getElementById('background'))
