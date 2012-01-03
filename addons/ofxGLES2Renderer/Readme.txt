
--------------------------------------------------------------------
            Openframeworks OpenGL ES 2.0 Renderer Readme.txt
--------------------------------------------------------------------


---- Why would I want to use OpenGL ES 2.0 on iOS or Android? -----

You can't use shaders otherwise!



---- Is it faster? ------------------------------------------------

It depends on how you use it, if you are using one of your custom shaders it will be as fast as your shader is.

If you are not using a custom shader, but you are letting gles2-bc (more on this later) emulate the fixed function pipeline for you, then every draw call, i.e when you call draw on an ofMesh or ofVBO or you call ofBox or ofLine has a cost involved where gles2-bc has to figure out what features you are using and build a shader that has those features. Most of the time this is cached already, but it's still more work than a fixed function renderer will do.

The post-iPhone2G devices already do this behind the scenes when you are using them in ES 1.1 mode, but this is obviously very optimised. 

So you'll want to do as few draw calls as possible, which the iOS documentation already recommends for you in ES 1.1 mode. See "OpenGL ES 1.1 on the PowerVR SGX" on:
http://developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/OpenGLESPlatforms/OpenGLESPlatforms.html

It will also run slower in the Simulator than it does on actual hardware.


--------------------------------------------------------------------
How the Openframeworks ES 2.0 renderer works
--------------------------------------------------------------------

The first thing to know about OpenGL ES 2.0 is:
http://d1xzuxjlafny7l.cloudfront.net/wp-content/uploads/2011/05/OpenGL-ES-2-Comic.jpg

To draw a red triangle in ES 2.0 you will need to set up a vertex shader that transforms your vertices properly and a fragment shader that turns it red, and a vertex array to send the vertex data for drawing, it ends up being quite a lot of code.

To provide compatibility with OpenGL ES 1.1 the ofGLES2Renderer uses a library called gles2-bc writen by Johannes Vuorinen.

More on gles2-bc here:
http://code.google.com/p/gles2-bc/
http://www.johannesvuorinen.com/stuff/cost_efficient_development_with_various_opengles_apis_-_Johannes_Vuorinen.pdf

All the standard OF drawing commands work, ofCircle, ofBox, and using an ofMesh ofVbo, etc etc. 

The goal is that it should "just work" if you are not calling GL commands directly, but are using the OF objects like ofShader, ofFbo, etc

If you want to get fancy, or if you want to try out some code from a tutorial, you need to get a reference to the gles2-bc object using ofGetGLES2Context(), then you can call any OpenGL function and gles2-bc gets a chance to set the states it needs, etc to generate the right shader for you.

It would look something like:

	ofGetGLES2Context()->glMatrixMode(GL_MODELVIEW);
	ofGetGLES2Context()->glEnable(GL_LIGHTING);
	ofGetGLES2Context()->glEnable(GL_LIGHT0);


***** Calling ES 1.1 commands normally will result in a crash. *****



---- What are the limitations? ------------------------------------

gles2bc provides emulation for most of the ES 1.1 functionality missing in ES 2.0, but some things to note are:

- flat shading is not supported (glShadeModel(GL_FLAT))
- glPointSize is not supported
- various glGet* functions are not supported
- glColorPointer supports only GL_FLOAT type
- Maximum of 3 simultaneous texture units are supported
- Maximum of 3 simultaneous lights are supported

But please note that these are just limitations of the gles2-bc ES 1.1 emulation, you are free to write a custom shader that supports 10 lights or blends 20 textures together in one draw call if you so desire.

Regarding flat shading from the gles2-bc PDF: "OpenGL ES 2.0 does not have an option to not interpolate varyings which makes flat shading inefficient to implement". "One possible method to implement ﬂat shading is to set normals for each vertex multiple times depending on the number of triangles it belongs. "

But on the bright side gles2-bc does per-pixel lighting if you call: 
ofLightingModel(GL_SMOOTH);

Pretty neato.


--------------------------------------------------------------------
Attributes and uniforms that are automatically set
--------------------------------------------------------------------

To make life a little easier for people writing custom shaders ofxGLES2Renderer sets a few attributes and uniforms for you if you have defined them in your shader.


---- Attributes ---------------------------------------------------

If you include the definitions for any of these attributes in your shader and your vertex data has these, they will be automatically populated:

attribute vec4 a_position;			
attribute vec4 a_color;				
attribute vec3 a_normal;			
attribute vec4 a_texCoord0;			
	
Please note that the attributes are only set if your vertex array or VBO included these things in the first place.


---- Uniforms -----------------------------------------------------

These matrices are also set automatically if you define them in your shader:


uniform mat4 u_modelViewMatrix; 

	The modelview matrix			


uniform mat4 u_modelViewProjectionMatrix; 

	Is the same as:
	gl_ProjectionMatrix * gl_ModelViewMatrix;

	Either of which don't exist as built in GLSL variables in ES 2.0.

	In desktop GLSL you can do:
	gl_Position = ftransform() 

	Which is the same as: 
	gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;

	And in our case:
	gl_Position = u_modelViewProjectionMatrix * a_position;
	


uniform mat3 u_normalMatrix;
	
	The gl_Normal matrix



--------------------------------------------------------------------
When things do not work.
--------------------------------------------------------------------


