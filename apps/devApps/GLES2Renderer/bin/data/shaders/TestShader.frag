
precision mediump float;

// Varyings
varying vec4 v_texCoord0;

// Uniforms
uniform float u_time;

uniform sampler2D u_texture0Sampler;


// Shader constants
const int c_zero = 0;
const int c_one = 1;
const float c_zerof = 0.0;
const float c_onef = 1.0;

#define PI 3.1415926535897932384626433832795

void main() 
{
	
	vec4 color;
	
	float tmpVal = (cos( u_time ) + 1.0) * 0.5;
	
	//color = vec4( tmpVal, 1.0-tmpVal, 1.0-tmpVal, 1.0 ); // just show some colour

	//color = texture2D(u_texture0Sampler, v_texCoord0.xy); // texture mapping

	// try a pixelation shader
//	float pixelSize = tmpVal * 0.2;
//	float dx = pixelSize; //pixel_w*(1./rt_w);
//	float dy = pixelSize; //pixel_h*(1./rt_h);	
//	vec2 coord = vec2(dx*floor(v_texCoord0.x/dx), dy*floor(v_texCoord0.y/dy));
//	color = texture2D(u_texture0Sampler, coord);

	// wave shader
	vec2 p = -1.0 + 2.0 * v_texCoord0.xy;
	float len = length(p);
	vec2 uv = v_texCoord0.xy + (p/len)*cos(len*12.0-u_time*4.0)*0.03;
	color = texture2D(u_texture0Sampler,uv);

	gl_FragColor = color;
}
