define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop', 'views/trippyBackground', 'lib/persistence', 'lib/sound'], ($, Playground, CanvasPainter, GameLoop, TrippyBackground, Persistence, Sound) ->
  playing = won = lost = false
  currentLevel = 1

  setUpGame = -> # do this once
    currentLevel = parseInt(location.href.split('level=')[1]) || 1
    CanvasPainter.init(
      document.getElementById("canvas1")
      document.getElementById("canvas2")
      document.getElementById("canvas3")
      document.getElementById("canvas4")
    )
  startLevel = -> # do this for each level
    Playground.startLevel(currentLevel)
    CanvasPainter.represent(Playground.drawables())
    playing = true
    won = lost = false
    $('.popup').fadeOut(200)
    Playground.onLevelWin(->
      unless won # unless you already won
        newLevelsCompleted = (Persistence.get('levelsCompleted') || []).concat(currentLevel)
        Persistence.set('levelsCompleted', newLevelsCompleted)
        $(".level-complete").show()
        playing = false
        won = true
    )
    Playground.onLevelLose(->
      $(".level-fail").fadeIn(1000)
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
          when 'r' then startLevel()
          when 'p' then togglePause()
        if e.keycode == 27 # esc
          togglePause()
      else
        if won && key == ' '
          currentLevel += 1
          startLevel()
          $(".level-complete").fadeOut(200)
          playing = true
        else if lost
          if key == ' ' || key == 'r'
            startLevel()
            $(".level-fail").fadeOut(200)
            playing = true
      e.stopPropagation()
      e.preventDefault() if key == ' '
    )
    $('a.start').click ->
      showLevelSelect()
    $('.level').click ->
      currentLevel = $(this).data().level
      startLevel()
      showDiv('playground')
    $('a.credits').click ->
      showDiv('credits')
    $('a.resume').click ->
      togglePause()
    $('a.restart').click ->
      startLevel()
    $('a.level-select').click ->
      showLevelSelect()

  startGame = ->
    GameLoop.loop ->
      Playground.update()
      CanvasPainter.paint()

  showDiv = (div) ->
    $(".#{div}").fadeIn(200)
    $(".gameContainer > div:not(.#{div}):not(.audioManager)").fadeOut(200)

  showLevelSelect = ->
    completedLevels = Persistence.get('levelsCompleted') || []
    # reset all first
    for levelDiv in $('.level')
      $levelDiv = $(levelDiv)
      $levelDiv.removeClass('available')
    for levelDiv in $('.level')
      $levelDiv = $(levelDiv)
      levelNum = $levelDiv.data('level')
      if completedLevels.indexOf(levelNum) != -1
        $levelDiv.addClass('done')
        $levelDiv.addClass('available')
        $(".level[data-level=#{levelNum - 1}]").addClass('available')
        $(".level[data-level=#{levelNum + 1}]").addClass('available')
        $(".level[data-level=#{levelNum + 10}]").addClass('available')
        $(".level[data-level=#{levelNum - 10}]").addClass('available')
    $(".level[data-level=1]").addClass('available') # 1st level always available
    showDiv('level-select')

  togglePause = ->
    Playground.togglePause()
    if Playground.paused
      $('.popup.paused').fadeIn(200)
    else
      $('.popup.paused').fadeOut(200)

  setup: ->
    $('document').ready ->
      TrippyBackground.setup(document.getElementById('trippyBackground'))
      Sound.start()
      setUpGame()
      setUpInput()
      startGame()

      # these are just for testing
      #
      #showLevelSelect()
      #showDiv('level-select') # for testing

      showDiv('playground') # for testing
      startLevel()
