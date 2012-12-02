define ['jquery', 'models/playground', 'views/canvasPainter', 'lib/gameLoop', 'views/trippyBackground', 'lib/persistence', 'lib/sound'], ($, Playground, CanvasPainter, GameLoop, TrippyBackground, Persistence, Sound) ->
  playing = won = lost = false
  currentLevel = 1
  upKeyCodes       = [87, 38] # W, up
  leftKeyCodes     = [65, 37] # A, left
  downKeyCodes     = [83, 40] # S, down
  rightKeyCodes    = [68, 39] # D, right
  restartKeyCodes  = [82] # R
  pauseKeyCodes    = [80, 27] # P, esc
  continueKeyCodes = [32, 82] # spacebar, R

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
    if Playground.player.clonesLeft?
      $('.clonesLeftContainer').show()
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
      key = e.keyCode
      Playground.stopCloningUp()    if    upKeyCodes.indexOf(key) != -1
      Playground.stopCloningLeft()  if  leftKeyCodes.indexOf(key) != -1
      Playground.stopCloningDown()  if  downKeyCodes.indexOf(key) != -1
      Playground.stopCloningRight() if rightKeyCodes.indexOf(key) != -1
      e.stopPropagation()
    )
    $('body').keydown((e) ->
      key = e.keyCode
      if playing
        Playground.cloningUp()    if      upKeyCodes.indexOf(key) != -1
        Playground.cloningLeft()  if    leftKeyCodes.indexOf(key) != -1
        Playground.cloningDown()  if    downKeyCodes.indexOf(key) != -1
        Playground.cloningRight() if   rightKeyCodes.indexOf(key) != -1
        startLevel()              if restartKeyCodes.indexOf(key) != -1
        togglePause()             if   pauseKeyCodes.indexOf(key) != -1
      else
        if won && continueKeyCode.indexOf(key) != -1
          currentLevel += 1
          startLevel()
          $(".level-complete").fadeOut(200)
          playing = true
        else if lost
          if continueKeyCodes.indexOf(key) !=0
            startLevel()
            $(".level-fail").fadeOut(200)
            playing = true
      e.stopPropagation()
      e.preventDefault()
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
