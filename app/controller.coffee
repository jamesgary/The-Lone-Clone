define ['jquery', 'models/playground'], ($, playground) ->
  setup: ->
    $('document').ready ->
      playground.init(document.getElementById("canvas"))
      #playground.init()
