//
//  SimpleTerrain.h
//  GLES2Renderer
//
//  Created by Andreas Muller on 31/08/2011.
//  Copyright 2011 Nanika. All rights reserved.
//

#include "ofMain.h"

#pragma once

class SimpleTerrain
{
public:
	
	SimpleTerrain();
	~SimpleTerrain();
	
	void setup( int _resX, int _resY, float _width, float _height );
	
	void computeVertexNormals();

	int resX;
	int resY;
	float spacingX;
	float spacingY;	
	
	int pointAmount;	
	int triangleAmount;
	

	ofVec3f* 		surfacePoints;
	ofVec3f* 		surfaceNormals;
	ofFloatColor* 	surfaceColors;
	ofVec2f* 		surfaceTexCoords;
	ofIndexType* 	surfaceIndices;

	ofVec3f* 		triangleNormals;	
	
	vector< vector<int> > indicesOfFacesThatRefVertex;
	
private:	
	
	void computeTriangleNormals();
};

