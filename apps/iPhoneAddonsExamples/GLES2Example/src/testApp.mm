
#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup()
{
	
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);		
	
	ofSetLogLevel( OF_LOG_VERBOSE );
		
	ofSetGlobalAmbientColor( ofColor( 40.0f, 40.0f, 40.0f) );		
	
	// Set up properties for a light	
	pointLight.setAmbientColor( ofFloatColor( 0.0f, 0.0f, 0.0f) );
	pointLight.setDiffuseColor( ofFloatColor( 1.0f, 1.0f, 1.0f) );
	pointLight.setSpecularColor(ofFloatColor( 0.5f, 0.5f, 0.5f) );
	pointLight.setPointLight();
	
		
	// make a shiny green material
	material.setDiffuseColor(ofFloatColor(0.0f, 1.0f, 0.0f, 1.0f));			
	material.setSpecularColor(ofFloatColor(1.0f, 1.0f, 1.0f, 1.0f));	
	material.setShininess( 127 );

	franklinBook14.loadFont("frabk.ttf", 14);
	franklinBook14.setLineHeight(18.0f);
	franklinBook14.setLetterSpacing(1.037);	
		
	// Set up a screen sized FBO
	ofFbo::Settings tmpScreenFBOSettings = ofFbo::Settings(); 
	tmpScreenFBOSettings.width  =  ofGetWidth();
	tmpScreenFBOSettings.height =  ofGetHeight();	
	tmpScreenFBOSettings.useDepth = true;
	tmpScreenFBOSettings.useStencil = false;
	tmpScreenFBOSettings.internalformat = GL_RGB;
	screenFBO.allocate( tmpScreenFBOSettings ); 	
	
	bgImage.loadImage("bg.jpg");
	
	fullScreenShader.load( "shaders/FullScreenShader" );
	surfaceShader.load( "shaders/SurfaceShader" ); 
	
	drawMode = 0;
	drawModeAmount = 3;
	
	mouseX = 400;
	mouseY = 400;	
	
	ofGetGLES2Context()->glFrontFace( GL_CW ); 	// OF currently uses a different polygon winding than default OpenGL
	
	ofLightingModel(GL_SMOOTH);					// We want per pixel lighting.		
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
}



//--------------------------------------------------------------
void testApp::update()
{	
	
	// move the light around
	float radius = 80.0f; 
	ofVec3f center(0.0f,0.0f, 0);		
	pointLight.setPosition( cos(ofGetElapsedTimef()*1.2f) * radius * 2 + center.x, 
						    sin(ofGetElapsedTimef()*1.1f) * radius * 2 + center.y, 
						   -cos(ofGetElapsedTimef()*0.9f) * radius * 2 + center.z ); 
	
	
	
}

//--------------------------------------------------------------
void testApp::draw()
{
	
	float screenWidth  = ofGetWidth();
	float screenHeight = ofGetHeight();	
	
	checkGlError( glGetError(), __FILE__, __LINE__ );

	screenFBO.begin();	
	
		ofClear( 0.0f, 0.0f, 0.0f, 255.0f );

		bgImage.draw(0.0f, 0.0f); 					// Draw the BG image onto the background FBO

		ofEnableDepthTest();
		
		_ofEnable( GL_CULL_FACE );					// Turn on face culling, check Graphics.h for "semi private" underscore functions 

		ofPushMatrix();
		
			// set the camera 
			ofTranslate( screenWidth/2.0f, screenHeight/2.0f, -200  );	
			ofRotate(-mouseX, 0, 1, 0);				
			ofRotate(-mouseY, 1, 0, 0);	
			
			ofEnableLighting();
		
			pointLight.enable();	
			pointLight.setPosition( pointLight.getPosition() );	// Lighting position has to be set when you have the matrix you want, this forces a call to onPositionChanged
		
			material.begin();	
		
			if( drawMode > 0 ) surfaceShader.begin();

				// draw some objects to the FBO
				ofCylinder( ofPoint( -300.0f, 0.0f, 0.0f ), 40.0f, 100.0f );
				ofCone( ofPoint( -150.0f, 0.0f, 0.0f ), 40.0f, 100.0f );	
				ofSphere( ofPoint( 0.0f, 0.0f, 0.0f ), 60.0f );		
				ofTorus( ofPoint( 150.0f, 0.0f, 0.0f ), 70.0f, 20.0f );		
				ofCapsule( ofPoint( 300.0f, 0.0f, 0.0f ), 40.0f, 100.0f );

			if( drawMode > 0 ) surfaceShader.end();	
	
			material.end();
			pointLight.disable();
			ofDisableLighting();		
			pointLight.draw();						// draw the light now that we have lighting off, but still have the camera matrix we lit the objects with	
		
		ofPopMatrix();
	
	screenFBO.end();	
	
	_ofDisable( GL_CULL_FACE );
	
	ofDisableDepthTest();		
	
	// Draw the FBO to screen with a fullscreen shader if desired
	ofSetColor(255,255,255, 255);	

	if( drawMode == 2 ) {
		fullScreenShader.begin();
		fullScreenShader.setUniform1f("u_time", ofGetElapsedTimef() );
			screenFBO.draw(0.0f, 0.0f );
		fullScreenShader.end();			
	}
	else {
		screenFBO.draw(0.0f, 0.0f);	
	}	

	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	string tmpStr = "fps: " + ofToString(ofGetFrameRate(), 2);
  	ofSetColor(0, 0, 0); 		ofDrawBitmapString(tmpStr, 21, 26,0);
    ofSetColor(255, 255, 255); 	ofDrawBitmapString(tmpStr, 20, 25,0);	
}


//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){

}


//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}


//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	
	drawMode++;
	if( drawMode >= drawModeAmount ) { drawMode = 0; }
}


//--------------------------------------------------------------
// A bit of error checking never hurts
//
void testApp::checkGlError(GLenum errorCode, const char *file, const unsigned int line)
{
	if (errorCode != GL_NO_ERROR)
	{
		std::string errorString;
		switch (errorCode) {
			case GL_INVALID_ENUM:
				errorString = "GL_INVALID_ENUM, enum argument out of range.";
				break;
			case GL_INVALID_VALUE:
				errorString = "GL_INVALID_VALUE, numeric argument out of range";
				break;
			case GL_INVALID_OPERATION:
				errorString = "GL_INVALID_OPERATION, operation illegal in current state";
				break;
			case GL_STACK_OVERFLOW:
				errorString = "GL_STACK_OVERFLOW, command would cause a stack overﬂow";
				break;
			case GL_STACK_UNDERFLOW:
				errorString = "GL_STACK_UNDERFLOW, command would cause a stack underﬂow";
				break;
			case GL_OUT_OF_MEMORY:
				errorString = "GL_OUT_OF_MEMORY, not enough memory left to execute command";
				break;
#ifdef OPENGLES_VERSION_2				
			case GL_INVALID_FRAMEBUFFER_OPERATION:
				errorString = "GL_INVALID_FRAMEBUFFER_OPERATION, framebuffer is incomplete";
				break;
#endif				
			default:
				errorString = "Unknown GL error";
				break;
		}
		
		cout << "** " << file << " " << line << " GL_ERROR: " << errorCode << " " << errorString << " **" << endl;
		//LOG_DEBUG_MESSAGE(file, line, OpenGLESString("GL ERROR: ") + errorCode + " " + errorString);
	}
}

