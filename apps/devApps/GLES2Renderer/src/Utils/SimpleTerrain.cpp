//
//  SimpleTerrain.cpp
//  GLES2Renderer
//
//  Created by Andreas Muller on 31/08/2011.
//  Copyright 2011 Nanika. All rights reserved.
//

#include "SimpleTerrain.h"

//--------------------------------------------------------------
SimpleTerrain::SimpleTerrain(){
}

//--------------------------------------------------------------
SimpleTerrain::~SimpleTerrain(){
}

//--------------------------------------------------------------
void SimpleTerrain::setup( int _resX, int _resY, float _width, float _height ){

	resX = _resX;
	resY = _resY;
	spacingX = _width  / (resX-1);
	spacingY = _height / (resY-1);
	
	pointAmount = resX * resY;
	triangleAmount = ((resX-1) * (resY-1)) * 2;
	
	surfacePoints    = new ofVec3f[ pointAmount ];
	surfaceNormals   = new ofVec3f[ pointAmount ];
	surfaceTexCoords = new ofVec2f[ pointAmount ];	
	surfaceColors    = new ofFloatColor[ pointAmount ];	
	surfaceIndices   = new ofIndexType[ triangleAmount * 3 ];	
	
	indicesOfFacesThatRefVertex.resize( pointAmount );
	
	triangleNormals = new ofVec3f[ triangleAmount ];	
	
	int tmpIndex = 0;
	for( int i = 0; i < resY; i++){
		for( int j = 0; j < resX; j++){
			//cout << (j * spacingX) << ", " << (i * spacingY) << "         " << ( j / (resX-1.0f) ) << endl;			
			//float tmpX = (j * spacingX) - ( spacingX * (resX / 2));
			//float tmpZ = (i * spacingY) - ( spacingY * (resY / 2));
			float tmpX = (i * spacingX) - ( spacingX * (resX / 2));
			float tmpZ = (j * spacingY) - ( spacingY * (resY / 2));			
			surfacePoints[tmpIndex].set( tmpX, 0.0f, tmpZ );
			surfaceNormals[tmpIndex].set( 0.0, -1.0f, 0.0f );
			surfaceColors[tmpIndex].set( 1.0f, 1.0f, 1.0f );
			surfaceTexCoords[tmpIndex].set( j / (resX-1.0f), i / (resY-1.0f) );

			tmpIndex++;
		}
	}	
	
	tmpIndex = 0;
	for( int i = 0; i < resY-1; i++){
		for( int j = 0; j < resX-1; j++){
			
			int leftOffset		  = j + (i*resX);
			int rightOffset		  = leftOffset + 1;			
			
			int bottomLeftIndex   = leftOffset;
			int bottomRightIndex  = rightOffset;
			int topRightIndex	  = rightOffset + resX;
			int topLeftIndex	  = leftOffset  + resX;
			
			// triangle 1			
			surfaceIndices[(tmpIndex*3) + 0] = topRightIndex;
			surfaceIndices[(tmpIndex*3) + 1] = bottomLeftIndex;
			surfaceIndices[(tmpIndex*3) + 2] = bottomRightIndex;					
			tmpIndex++;
			
			// triangle 2			
			surfaceIndices[(tmpIndex*3) + 0] = topLeftIndex;
			surfaceIndices[(tmpIndex*3) + 1] = bottomLeftIndex;					
			surfaceIndices[(tmpIndex*3) + 2] = topRightIndex;			
			tmpIndex++;
		}
	}	
	

	for( int i = 0; i < triangleAmount; i++ ) {
		
		int index1 = surfaceIndices[(i*3) + 0];
		int index2 = surfaceIndices[(i*3) + 1];
		int index3 = surfaceIndices[(i*3) + 2];	
		
		indicesOfFacesThatRefVertex.at( index1 ).push_back( i );
		indicesOfFacesThatRefVertex.at( index2 ).push_back( i );
		indicesOfFacesThatRefVertex.at( index3 ).push_back( i );		
	}
	
}

//--------------------------------------------------------------
void SimpleTerrain::computeVertexNormals(){
	
	computeTriangleNormals();
	
	for( int i = 0; i < pointAmount; i++ )
	{
		ofVec3f tmp;
		for( unsigned int j = 0; j < indicesOfFacesThatRefVertex.at(i).size(); j++ )
		{
			tmp += triangleNormals[ indicesOfFacesThatRefVertex.at(i).at(j) ];
		}
		
		tmp /= indicesOfFacesThatRefVertex.at(i).size();
		
		
		//if( i == 15 ) cout << tmp << endl;
		
		surfaceNormals[i].set( tmp.x, tmp.y, tmp.z );
	}
	
}

//--------------------------------------------------------------
void SimpleTerrain::computeTriangleNormals(){
	
	ofVec3f tmpa, tmpb;
	
	for( int i = 0; i < triangleAmount; i++ ) {
		
		ofVec3f* v1 = &surfacePoints[ surfaceIndices[(i*3) + 0] ];
		ofVec3f* v2 = &surfacePoints[ surfaceIndices[(i*3) + 1] ];
		ofVec3f* v3 = &surfacePoints[ surfaceIndices[(i*3) + 2] ];	
		
		tmpb.x = v3->x - v2->x;
		tmpb.y = v3->y - v2->y;
		tmpb.z = v3->z - v2->z;		
		
		tmpa.x = v1->x - v2->x;
		tmpa.y = v1->y - v2->y;
		tmpa.z = v1->z - v2->z;		

		//if( i == 55 ) { cout << tmpa << endl; cout << tmpb << endl; cout << endl; }	
		//if( i == 55 ) { cout << v1 << endl; cout << v2 << endl;  cout << v3 << endl; cout << endl; }			
	
		tmpa.cross( tmpb );
		tmpa.normalize();
		
		//if( i == 55 ) { cout << tmpa << endl;  }
		
		triangleNormals[i].set( tmpa.x, tmpa.y, tmpa.z ); 
	}
}


/*
 surfaceGridX = 20;
 surfaceGridY = 20;
 surfaceSpacingX = 30.0f;
 surfaceSpacingY = 30.0f;	
 
 surfacePointAmount = surfaceGridX * surfaceGridY;
 surfaceTriangleAmount = ((surfaceGridX-1) * (surfaceGridY-1)) * 2;
 
 surfacePoints  = new ofVec3f[ surfaceGridX*surfaceGridY ];
 surfaceNormals = new ofVec3f[ surfaceGridX*surfaceGridY ];
 surfaceColors  = new ofFloatColor[ surfaceGridX*surfaceGridY ];	
 surfaceIndices = new ofIndexType[ surfaceTriangleAmount * 3 ];
 
 int tmpIndex = 0;
 for( int i = 0; i < surfaceGridY; i++){
 for( int j = 0; j < surfaceGridX; j++){
 float tmpX = (i * surfaceSpacingX) - ( surfaceSpacingX * (surfaceGridX / 2));
 float tmpZ = (j * surfaceSpacingY) - ( surfaceSpacingY * (surfaceGridY / 2));
 surfacePoints[tmpIndex].set( tmpX, 0.0f, tmpZ );
 surfaceNormals[tmpIndex].set( 0.0, -1.0f, 0.0f );
 surfaceColors[tmpIndex].set( 1.0f, 1.0f, 1.0f );
 tmpIndex++;
 }
 }
 
 tmpIndex = 0;
 for( int i = 0; i < surfaceGridY-1; i++){
 //tmpIndex = i * surfaceGridX;
 for( int j = 0; j < surfaceGridX-1; j++){
 
 int leftOffset		  = j + (i*surfaceGridX);
 int rightOffset		  = leftOffset + 1;			
 
 int bottomLeftIndex   = leftOffset;
 int bottomRightIndex  = rightOffset;
 int topRightIndex	  = rightOffset + surfaceGridX;
 int topLeftIndex	  = leftOffset  + surfaceGridX;
 
 // triangle 1			
 surfaceIndices[(tmpIndex*3) + 0] = topRightIndex;
 surfaceIndices[(tmpIndex*3) + 1] = bottomLeftIndex;
 surfaceIndices[(tmpIndex*3) + 2] = bottomRightIndex;					
 tmpIndex++;
 
 // triangle 2			
 surfaceIndices[(tmpIndex*3) + 0] = topLeftIndex;
 surfaceIndices[(tmpIndex*3) + 1] = bottomLeftIndex;					
 surfaceIndices[(tmpIndex*3) + 2] = topRightIndex;			
 tmpIndex++;
 }
 }	
 
 surfaceVbo.setVertexData(surfacePoints,  surfaceGridX*surfaceGridY, GL_DYNAMIC_DRAW );	
 surfaceVbo.setColorData(surfaceColors,   surfaceGridX*surfaceGridY, GL_DYNAMIC_DRAW );
 surfaceVbo.setVertexData(surfacePoints,  surfaceGridX*surfaceGridY, GL_DYNAMIC_DRAW );	
 surfaceVbo.setNormalData(surfaceNormals, surfaceGridX*surfaceGridY, GL_DYNAMIC_DRAW );	
 
 surfaceVbo.setIndexData(surfaceIndices,  surfaceTriangleAmount*3, GL_DYNAMIC_DRAW );
 */
