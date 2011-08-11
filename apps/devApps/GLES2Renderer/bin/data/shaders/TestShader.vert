
precision highp float;
precision highp int;

// Attributes
attribute vec4 a_position;
attribute vec4 a_color;
attribute vec3 a_normal;
attribute vec4 a_texCoord0;
//attribute vec4 a_texCoord1;
//attribute vec4 a_texCoord2;


// Uniforms
uniform mat4 u_modelViewMatrix;
uniform mat4 u_modelViewProjectionMatrix;



// Varyings
varying vec4 v_texCoord0; // we pass along the attribute to the .frag as a varying


// Shader constants
const int c_zero = 0;
const int c_one = 1;
const float c_zerof = 0.0;
const float c_onef = 1.0;

// Shader variables
vec3 normal;
vec4 vertexPositionInEye;


void main() 
{

	gl_Position = u_modelViewProjectionMatrix * a_position;
	
	v_texCoord0 = a_texCoord0; // pass the attribute along

}
