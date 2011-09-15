
precision mediump float;

// Varyings
varying vec4 v_texCoord0;

// Uniforms
uniform float u_time;
uniform sampler2D u_texture0Sampler;

#define PI 3.1415926535897932384626433832795

void main() 
{
	vec4 color = vec4(1.0,1.0,1.0,1.0);
	
	float tmpVal = (cos( u_time ) + 1.0) * 0.5;
	

	//  pixelation shader
//	float pixelSize = tmpVal * 0.2;
//	float dx = pixelSize; //pixel_w*(1./rt_w);
//	float dy = pixelSize; //pixel_h*(1./rt_h);	
//	vec2 coord = vec2(dx*floor(v_texCoord0.x/dx), dy*floor(v_texCoord0.y/dy));
//	color = texture2D(u_texture0Sampler, coord);

	// wWve shader
//	vec2 p = -1.0 + 2.0 * v_texCoord0.xy;
//	float len = length(p);
//	vec2 uv = v_texCoord0.xy + (p/len)*cos(len*12.0-u_time*4.0)*0.03;
//	color = texture2D(u_texture0Sampler,uv);

	
	// From http://www.everyday3d.com/j3d/demo/009_BasicFilter.html
	float m1 = sin(u_time * 3.0 + v_texCoord0.y * 16.0) * cos(u_time * 2.0 + v_texCoord0.x * 10.0) * 0.02;

	vec4 a = texture2D(u_texture0Sampler, v_texCoord0.xy + m1 * 0.5);
	vec4 b = texture2D(u_texture0Sampler, v_texCoord0.xy + m1);
	vec4 c = texture2D(u_texture0Sampler, v_texCoord0.xy + m1 * 1.5);
	color = vec4(a.r, b.g, c.b, 1.0);

	gl_FragColor = color;
}
