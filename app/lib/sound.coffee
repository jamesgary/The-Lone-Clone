define ['jquery', 'jplayer', 'lib/persistence'], ($, jPlayer_unused, Persistence) ->
  PLAYLIST = [
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_01_-_Dalia.mp3',              title: 'Dalia' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_02_-_School_Boy.mp3',         title: 'School Boy' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_03_-_Dice.mp3',               title: 'Dice' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_04_-_Pitnastka.mp3',          title: 'Pietnastka' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_05_-_Salto.mp3',              title: 'Salto' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_06_-_Czterdzieci_cztery.mp3', title: 'Czterdziesci Cztery' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_07_-_Noakowski.mp3',          title: 'Noakowski' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_08_-_Podchody.mp3',           title: 'Podchody' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_09_-_Keymonica.mp3',          title: 'Keymonica' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_10_-_Superator.mp3',          title: 'Superator' }
    { downloadUrl: 'https://s3.amazonaws.com/james_gary/Pietnastka_-_11_-_Tape_Eater.mp3',         title: 'Tape Eater' }
  ]

  start: ->
    self = this
    @currentIndex = 0
    $('.songTitle').text(@currentTitle())
    @init()
    @$player.bind($.jPlayer.event.ended, (e) ->
      self.advanceTrack()
      self.playSong()
    )
    @$player.bind($.jPlayer.event.pause, (e) -> 
      $('.songInfo').fadeOut(200)
      Persistence.set('mute', true)
    )
    @$player.bind($.jPlayer.event.play,  (e) -> 
      $('.songInfo').fadeIn(200)
      Persistence.set('mute', false)
    )

  ###########
  # private #
  ###########

  init: ->
    self = this
    @$player = $(".musicPlayer").jPlayer(
      cssSelectorAncestor: '.audioManager'
      cssSelector:
        play:  ".playing"
        pause: ".paused"
      loop: true
      preload: true
      supplied: "mp3"
      swfPath: "/assets/"
      ready: ->
        $(this).jPlayer("setMedia", { mp3: self.currentDownloadUrl() })
        unless Persistence.get('mute')
          $('.songInfo').show()
          self.playSong()
        $('.audioManager').slideDown(500)
    )
  playSong: ->
    @$player.
      jPlayer("setMedia", { mp3: @currentDownloadUrl() }).
      jPlayer('play')
    $('.songTitle').text(@currentTitle())
  currentTitle: ->
    @currentSong().title
  currentDownloadUrl: ->
    @currentSong().downloadUrl
  currentSong: ->
    PLAYLIST[@currentIndex]
  advanceTrack: ->
    @currentIndex++
    @currentIndex = 0 if @currentIndex >= PLAYLIST.length
