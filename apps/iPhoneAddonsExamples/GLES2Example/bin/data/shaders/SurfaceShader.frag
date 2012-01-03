
precision mediump float;

// Varyings
varying vec3 v_normal;


void main() 
{
	
	vec3 tmpCol = (v_normal + 1.0) / 2.0;

	gl_FragColor = vec4(tmpCol, 1.0);

}
