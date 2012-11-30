# Album ID: 12779
#   http://freemusicarchive.org/api/get/albums.xml?album_title=Dalia&artist_handle=Pietnastka
define ['jquery', 'jplayer', 'lib/persistence'], ($, jPlayer_unused, Persistence) ->
  PLAYLIST = [
    #{ downloadId: '8a28decd088d2c4f5c137f9dec27c681009861cf', title: 'Dalia' }
    #{ downloadId: '4880b2a7edfb912da28f36cffb2ea3079371f84c', title: 'School Boy' }
    #{ downloadId: 'a0e77805a538a4b75b47f1bf122ac1cdd629d6f2', title: 'Dice' }
    #{ downloadId: '7c94fde6b8b4bed429fa0d4d7d244c08338f75b6', title: 'Pietnastka' }
    #{ downloadId: 'a3c031436146d2beb6c0b71b88fb370bdeb0c473', title: 'Salto' }
    #{ downloadId: '9d80cc91f222143eb8f56181574ff7017e1a642c', title: 'Czterdziesci Cztery' }
    { downloadId: 'd7ab5e5bbd99a63bcb5a1e5772235bdad33d5cb1', title: 'Noakowski' }
    { downloadId: '176a10763ed04d45c5c5cfcaf285b4646e0bdca5', title: 'Podchody' }
    { downloadId: '63641d806456a06e74791eb12a4854b407838e7a', title: 'Keymonica' }
    { downloadId: 'e62ecdc6b3cd78aac79e2e10bff2d2238d3c3205', title: 'Superator' }
    { downloadId: 'a629096dcdd16dca737a6f1aedfa2ee54f5b724c', title: 'Tape Eater' }
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
    "http://freemusicarchive.org/music/download/#{ @currentSong().downloadId }"
  currentSong: ->
    PLAYLIST[@currentIndex]
  advanceTrack: ->
    @currentIndex++
    @currentIndex = 0 if @currentIndex >= PLAYLIST.length
