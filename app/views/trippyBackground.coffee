#define ['lib/webgl', 'text!./frag.glsl', 'text!./vert.glsl' ], (webgl, fragShader, vertShader) ->
define ['lib/webgl' ], (webgl) ->
  setup: (canvas) ->
    webgl.initGl(canvas)
    webgl.addVertexShaders(["""
attribute vec3 position;

void main() {
    gl_Position = vec4(position, 1.0);
}
    """])
    webgl.addFragmentShaders(["""
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}
    """])
    @setDimensions(600, 400)
    @start()
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
  fullScreen: ->
    webgl.fullScreen()
  setCellColor: (r, g, b) ->
    webgl.setVar('cellColor', @glslRgb(r, g, b))
  setPixelSize: (pixelSize) ->
    webgl.setPixelSize(pixelSize)
  setMinLiveNeighborRule: (num) ->
    webgl.setVar('minLiveNeighborRule', num)
  setMaxLiveNeighborRule: (num) ->
    webgl.setVar('maxLiveNeighborRule', num)
  setMinDeadNeighborRule: (num) ->
    webgl.setVar('minDeadNeighborRule', num)
  setMaxDeadNeighborRule: (num) ->
    webgl.setVar('maxDeadNeighborRule', num)
  cellColor: 'a8f565'

  ###########
  # private #
  ###########

  hexToGlslRgb: (hex) ->
    @glslRgb(
      parseInt(hex[0] + hex[1], 16),
      parseInt(hex[2] + hex[3], 16),
      parseInt(hex[4] + hex[5], 16)
    )

  glslRgb: (r, g, b) ->
    [r / 255.0, g / 255.0, b / 255.0, 1.0]
