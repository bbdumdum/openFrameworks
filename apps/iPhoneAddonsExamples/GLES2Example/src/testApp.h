#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "Utils/ShaderBlurES2.h"

#include "Math/AMathHelpers.h"


class testApp : public ofxiPhoneApp 
{
	
public:

	void setup();
	void update();
	void draw();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);

	void checkGlError(GLenum errorCode, const char *file, const unsigned int line);
	
	int drawMode;
	int drawModeAmount;	
	
	ofFbo screenFBO;	
				
	ofTrueTypeFont  franklinBook14;
	
	ofLight		pointLight;
	ofMaterial	material;	

	ofShader surfaceShader;	
	ofShader fullScreenShader;
	
	ofImage bgImage;
	
};

