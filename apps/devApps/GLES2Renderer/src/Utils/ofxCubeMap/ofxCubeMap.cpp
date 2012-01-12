
#include "ofxCubeMap.h"

//--------------------------------------------------------------
// these should all be the same size and all power of two
void ofxCubeMap::loadImages( string pos_x, string pos_y, string pos_z, string neg_x,string neg_y,string neg_z)
{	
	
	// We don't want the texture border hack to be on
	bool wantsTextureBorderHack = false;
	if( ofGetTextureEdgeHackEnabled() ) {
		wantsTextureBorderHack = true;
		ofDisableTextureEdgeHack();
		cout << "ofxCubeMap:loadImages (string version), disabled texture hack, re-enabling when done." << endl;
	}
	
	
	ofImage images[6];	
	bool loaded1 = images[0].loadImage(pos_x);
	bool loaded2 = images[1].loadImage(pos_y);
	bool loaded3 = images[2].loadImage(pos_z);
	bool loaded4 = images[3].loadImage(neg_x);
	bool loaded5 = images[4].loadImage(neg_y);
	bool loaded6 = images[5].loadImage(neg_z);
	
	if( loaded1 && loaded2 && loaded3 && loaded4 && loaded5 && loaded6 ) {}
	else { ofLogError() << "ofxCubeMap: failed to load one of the cubemaps!"; }
	
	loadFromOfImages(images[0],
					 images[1],
					 images[2],
					 images[3],
					 images[4],
					 images[5]);
	
	if( wantsTextureBorderHack ) {
		ofEnableTextureEdgeHack();
	}
	
}

//--------------------------------------------------------------
void ofxCubeMap::loadFromOfImages( ofImage pos_x, ofImage pos_y, ofImage pos_z, ofImage neg_x, ofImage neg_y,ofImage neg_z)
{	
	
	//_ofEnable( GL_TEXTURE_CUBE_MAP_SEAMLESS );
	
	//create a texture object
	glGenTextures(1, &textureObject);
	glBindTexture(GL_TEXTURE_CUBE_MAP, textureObject);
	
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
#ifndef TARGET_OPENGLES	
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE); // GL_TEXTURE_WRAP_R is not in the ES2 header, hmm..
#endif
	
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);	
	
	
	unsigned char * data_px, * data_nx, * data_py, * data_ny, * data_pz, * data_nz;
	
	const int img_size = pos_x.getWidth();
	
	cout << "ofxCubeMap::loadFromOfImages, img_size: " << img_size << "  bpp: " << pos_x.bpp << endl;
	
	data_px = new unsigned char [img_size * img_size * 3];
	data_py = new unsigned char [img_size * img_size * 3];
	data_pz = new unsigned char [img_size * img_size * 3];
	
	data_nx = new unsigned char [img_size * img_size * 3];
	data_ny = new unsigned char [img_size * img_size * 3];
	data_nz = new unsigned char [img_size * img_size * 3];
	
	data_px = pos_x.getPixels();
	data_py = pos_y.getPixels();
	data_pz = pos_z.getPixels();	
	
	data_nx = neg_x.getPixels();
	data_ny = neg_y.getPixels();	
	data_nz = neg_z.getPixels();

	
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_px); // positive x
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_py); // positive y
	glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_pz); // positive z	
	
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_nx); // negative x
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_ny); // negative y
	glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGB, img_size, img_size, 0, GL_RGB, GL_UNSIGNED_BYTE, data_nz); // negative z

	
	/*
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_px); // positive x
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_nx); // negative x
	
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_py); // positive y
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_ny); // negative y
	
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_pz); // positive z	
	glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, 0,0, img_size, img_size, GL_RGB, GL_UNSIGNED_BYTE, data_nz); // negative z
	
	_ofDisable( GL_TEXTURE_2D );*/
	
}
