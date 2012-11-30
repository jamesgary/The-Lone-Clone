define ['lib/webgl' ], (webgl) ->
  setup: (canvas) ->
    try
      webgl.initGl(canvas)
      webgl.addVertexShaders(["""
  attribute vec3 position;

  void main() {
      gl_Position = vec4(position, 1.0);
  }
      """])
      #webgl.addFragmentShaders(console.log ["#ifdef GL_ES\n
      stationaryColor = Math.floor(Math.random() * 3)
      webgl.addFragmentShaders(["#ifdef GL_ES\n
  precision mediump float;\n
#endif\n

  uniform float time;
  uniform vec2 resolution;

  void main( void ) {

    vec2 position = gl_FragCoord.xy / resolution.xy;

    float t = time + 500.0;
    float color = 0.0;
    color += sin( position.x * cos( t / #{ @rand(20) + 10 } ) * #{ @rand(100) + 5 } ) + cos( position.y * cos( t / #{ @rand(40) + 5 } ) * #{ @rand(100) + 5 } );
    color += sin( position.y * sin( t / #{ @rand(20) + 10 } ) * #{ @rand(100) + 5 } ) + cos( position.x * sin( t / #{ @rand(40) + 5 } ) * #{ @rand(100) + 5 } );
    color += sin( position.x * sin( t / #{ @rand(20) + 10 } ) * #{ @rand(100) + 5 } ) + sin( position.y * sin( t / #{ @rand(40) + 5 } ) * #{ @rand(100) + 5 } );
    color *= sin( t / #{ @rand(10) + 10 } ) * 0.9;

    float r = abs(sin(color + t / #{ @rand(5) + 1 } ) * #{ @rand(.5) + 1 });
    float g = abs(sin(color + t / #{ @rand(5) + 1 } ) * #{ @rand(.5) + 1 });
    float b = abs(sin(color + t / #{ @rand(5) + 1 } ) * #{ @rand(.5) + 1 });
    if (#{ stationaryColor == 0 }) { r = color; }
    if (#{ stationaryColor == 1 }) { g = color; }
    if (#{ stationaryColor == 2 }) { b = color; }
    gl_FragColor = vec4( vec3( r, g, b ), 1.0 );

  }
      "])
      @setDimensions(600, 400)
      @start()
    catch error
      console.log "WebGL error: #{error}"
  start: ->
    webgl.animate()
  pause: ->
    webgl.pause()
  setDimensions: (width, height) ->
    webgl.setDimensions(width, height)
  setMouse: (x, y) ->
    webgl.setMouse(x, y)
  reset: ->
    webgl.reset()

  ###########
  # private #
  ###########

  rand: (num) -> # a little loggy
    num = Math.pow(Math.random() * num, .9)
    "#{num}".substring(0, 5)
  numBetween: (min, max) ->
    min + (Math.random() * (max - min))
