
precision mediump float;

// Varyings
varying vec4 v_texCoord0;

// Uniforms
uniform sampler2D u_texture0Sampler;

uniform float u_pixelSizeX;
uniform float u_pixelSizeY;
uniform float u_blurAmnt;


void main( void )
{  
	vec2 st = v_texCoord0.st;
	
	vec4 color = vec4( 0.0, 0.0, 0.0, 0.0 );
	
	float extra = u_pixelSizeY * u_blurAmnt;
	
	color		+= 1.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * 4.0));
	color		+= 2.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * 3.0));
	color		+= 3.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * 2.0));
	color		+= 4.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * 1.0));	
		
	color		+= 5.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra) );
	
	color		+= 4.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * -1.0));
	color		+= 3.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * -2.0));
	color		+= 2.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * -3.0));
	color		+= 1.0 * texture2D(u_texture0Sampler, st + vec2(0.0, extra * -4.0));
	
	color /= 25.0;
	gl_FragColor = color;
}