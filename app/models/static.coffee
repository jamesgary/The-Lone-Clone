define ['lib/physics'], (Physics) ->
  # for now, these are all rectangles
  new: (params) ->
    x: params.x
    y: params.y
    h: params.h
    w: params.w
