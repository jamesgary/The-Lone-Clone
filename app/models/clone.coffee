define ['lib/physics'], (Physics) ->
  # for now, these are all circles
  new: (params) ->
    x: params.x
    y: params.y
    r: params.r
    a: params.a
    rTarget: params.rTarget
