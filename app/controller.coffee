define ['jquery', 'models/playground'], ($, playground) ->
  setup: ->
    $('document').ready ->
      playground.init(document.getElementById("canvas"))
      $('body').keypress((e) ->
        key = String.fromCharCode(e.which)
        switch key
          when 'd' then playground.cloneRight()
        e.stopPropagation()
      )
