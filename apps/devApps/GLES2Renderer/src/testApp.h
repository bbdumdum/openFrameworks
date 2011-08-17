#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxAssimpModelLoader.h"

#include "ofGLES2Renderer.h"

#include "Math/AMathHelpers.h"


// Copy pasted some code from the net for sanity checking, temporarily need this.
typedef struct { float x,y; bool bBeingDragged; bool bOver; float radius; }draggableVertex;
typedef struct { GLfloat red, green, blue, alpha; } Color3D;
typedef struct { GLfloat x,y,z; } Vertex3D;
typedef struct { GLfloat x,y,z; } Vector3D;
#define Vector3DMake(x,y,z) (Vector3D)Vertex3DMake(x, y, z)
#define Vector3DSet(vector,x,y,z) Vertex3DSet(vector, x, y, z)
static inline GLfloat Vector3DMagnitude(Vector3D vector) { return sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));  }
static inline void Vector3DNormalize(Vector3D *vector)
{
	GLfloat vecMag = Vector3DMagnitude(*vector);
	if ( vecMag == 0.0 )
	{
		vector->x = 1.0;
		vector->y = 0.0;
		vector->z = 0.0;
        return;
	}
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
}
static inline Vector3D Vector3DMakeWithStartAndEndPoints(Vertex3D start, Vertex3D end)
{
	Vector3D ret;
	ret.x = end.x - start.x;
	ret.y = end.y - start.y;
	ret.z = end.z - start.z;
	Vector3DNormalize(&ret);
	return ret;
}
#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)
#define RANDOM_FLOAT_BETWEEN(x, y) (((float) rand() / RAND_MAX) * (y - x) + x)




class testApp : public ofxiPhoneApp 
{
	
public:
	void setup();
	void update();
	void draw();
	
	void drawScene();
	
	void debugDraw();
	
	void drawIcosahedron( float _scale );
	void drawCube( float _scale );
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);

	void checkGlError(GLenum errorCode, const char *file, const unsigned int line);
	
	ofFbo screenFBO;	
	
	ofShader testShader;
	
	ofMesh testMesh;
	
	ofImage testImage;
	ofImage testImage2;	
	
	ofImage testImageAlpha;		
	
	ofTrueTypeFont  franklinBook14;
	
	ofLight pointLight;
	ofLight spotLight;
	ofLight directionalLight;	
	bool bPointLight, bSpotLight, bDirLight;
	
	ofMaterial material;	
	
	int nCurveVertexes;
	draggableVertex curveVertices[7];
	draggableVertex bezierVertices[4];

	float appIphoneScale;
	
	//ofxAssimpModelLoader model;
	
	string typeStr;
	
	ofVboMesh mesh;
	ofPoint position;
	float normScale;
	ofPoint scale;
	ofPoint sceneCenter;
	ofTexture tex;
	ofLight	light;	
	
	int counter;

};


