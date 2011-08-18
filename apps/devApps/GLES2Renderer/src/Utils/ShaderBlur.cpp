/*
 *  ShaderBlur.cpp
 *  openFrameworks
 *
 *  Created by theo on 17/10/2009.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "shaderBlur.h"

//--------------------------------------------------------------
ShaderBlur::ShaderBlur()
{
	clearColor.set( 0, 0, 0, 255 );	
}

//--------------------------------------------------------------
ShaderBlur::~ShaderBlur()
{
}

//--------------------------------------------------------------
void ShaderBlur::setup(int fboW, int fboH){	
	
	clearColor.set(0,0,0,255);
	
	ofFbo::Settings tmpSettings = ofFbo::Settings(); 
	tmpSettings.width  = fboW;
	tmpSettings.height = fboH;	
	tmpSettings.useDepth = true;
	tmpSettings.internalformat = GL_RGB;
	
	fbo1.allocate(tmpSettings); //(fboW, fboH, GL_RGB);
	
	// second FBO does not need a depth buffer
	tmpSettings.useDepth = false;
	
	fbo2.allocate(tmpSettings); //(fboW, fboH, GL_RGB);	
	
	fbo1.begin(); ofClear(0,0,0,255); fbo1.end();
	fbo2.begin(); ofClear(0,0,0,255); fbo2.end();	
		
	shaderH.load("shaders/simpleBlurHorizontal.vert", "shaders/simpleBlurHorizontal.frag");
	shaderV.load("shaders/simpleBlurVertical.vert",   "shaders/simpleBlurVertical.frag");	
	
	ofTextureData texDat = fbo1.getTextureReference().getTextureData();

	pixelSizeX = 1.0f / texDat.tex_w;
	pixelSizeY = 1.0f / texDat.tex_h;	
	
	noPasses = 1;
	blurDistance = 1.1;
}

//--------------------------------------------------------------
void ShaderBlur::beginRender()
{
	fbo1.begin();
	ofClear( clearColor.r ,clearColor.g,clearColor.b,clearColor.a);	
}

//--------------------------------------------------------------
void ShaderBlur::endRender()
{
	fbo1.end();
}

//--------------------------------------------------------------
void ShaderBlur::setBlurParams(int numPasses, float blurDist){
	noPasses		= ofClamp(numPasses, 1, 100000);
	blurDistance	= blurDist;
}

//--------------------------------------------------------------
void ShaderBlur::performBlur()
{
	ofFbo * src, * dst;	
	src = &fbo1;
	dst = &fbo2;
	
	for(int i = 0; i < noPasses; i++)
	{
		//float blurPer =  blurDistance * ofMap(i, 0, noPasses, 1.0/noPasses, 1.0);
		
		//first the horizontal shader, X
		shaderH.begin();
		shaderH.setUniform1f("u_pixelSizeX", pixelSizeX);			
		shaderH.setUniform1f("u_blurAmnt", blurDistance);		
		
		dst->begin();
		ofClear(0,0,0,255);
		
			src->draw(0, 0);
				
		dst->end();
		
		shaderH.end();		
		
				
		//now the vertical shader, Y
		shaderV.begin();	
		shaderV.setUniform1f("u_pixelSizeY", pixelSizeY);		
		shaderV.setUniform1f("u_blurAmnt", blurDistance);		
		
		src->begin();
		ofClear(0,0,0,255);
		
			dst->draw(0,0);
		
		src->end();
		
		shaderV.end();		
	}		
}


//--------------------------------------------------------------
void ShaderBlur::draw(float x, float y )
{
	fbo1.draw(x, y, fbo1.getWidth(), fbo1.getHeight() );	
}


//--------------------------------------------------------------
void ShaderBlur::draw(float x, float y, float w, float h)
{
	fbo1.draw(x, y, w, h);	
}



