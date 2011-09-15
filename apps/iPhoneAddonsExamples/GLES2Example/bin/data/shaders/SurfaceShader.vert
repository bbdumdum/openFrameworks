
precision highp float;
precision highp int;

// Attributes
attribute vec4 a_position;
attribute vec4 a_color;
attribute vec3 a_normal;
attribute vec4 a_texCoord0;


// Uniforms
uniform mat4 u_modelViewMatrix;
uniform mat4 u_modelViewProjectionMatrix;
uniform mat3 u_normalMatrix;

// Varyings
varying vec3 v_normal; // we pass along the attribute to the .frag as a varying



void main() 
{
	gl_Position = u_modelViewProjectionMatrix * a_position;
	
	v_normal = normalize(u_normalMatrix * a_normal);
}
