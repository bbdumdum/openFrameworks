#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxAssimpModelLoader.h"

#include "Utils/ShaderBlurES2.h"
#include "Utils/SimpleTerrain.h"

#include "Math/AMathHelpers.h"
#include "Math/PerlinNoise.h"


// Copy pasted some code from the net for sanity checking, temporarily need this.
typedef struct { float x,y; bool bBeingDragged; bool bOver; float radius; } draggableVertex;
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

#define GRID_WIDTH  16
#define GRID_HEIGHT 16
#define LENGTH		2 * 8

#define NUM_PTS			10000
#define WORM_LEN		5500
#define	NUM_PARTICLES	50000
#define	NUM_BILLBOARDS	1000



class testApp : public ofxiPhoneApp 
{
	
public:
	void setup();
	void update();
	void draw();

	void drawSceneModel();	
	void drawSceneVBO();
	void drawSceneVBOTest2();	
	void drawSceneSimple();
	void drawSceneLightingTest();
	void drawSceneLightingCubeGridTest();	
	void drawSceneCustomShaderForVBOTest();

	//void drawSceneEasycamTest();
	
	void ofGenerateSphereMesh( ofMesh& _mesh, float _radius, int _numRings = 16, int _numSegments = 16 );
	void ofGenerateTorusMesh( ofMesh& _mesh, float _radius, float _sectionRadius, int _numSegSection = 16, int _numSegCircle = 16 );	
	void ofGenerateConeMesh( ofMesh& _mesh, float _radius, float _height, int _numSegBase = 16, int _numSegHeight = 16 );		
	
	void debugDraw();
	
	void drawIcosahedron( float _scale );
	void drawCube( float _scale );
	
	void initVBOTest2();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);

	void checkGlError(GLenum errorCode, const char *file, const unsigned int line);
	
	ofFbo screenFBO;	
	
#ifdef OPENGLES_VERSION_2	
	ofShader testShader;
	ofShader testSurfaceShader;	
	ShaderBlurES2 shaderBlur;
#endif	
	ofMesh testMesh;
	
	ofImage testImage;
	ofImage testImage2;	
	
	ofImage testImageAlpha;		
	
	ofImage debugTextureImage;			
		
	ofTrueTypeFont  franklinBook14;
	
	ofLight pointLight;
	//ofLight spotLight;
	//ofLight directionalLight;	
	bool bPointLight, bSpotLight, bDirLight;
	
	ofMesh sphereMesh;
	ofMesh torusMesh;	
	ofMesh coneMesh;	
	
	ofMaterial material;	
	
	int nCurveVertexes;
	draggableVertex curveVertices[7];
	draggableVertex bezierVertices[4];

	float appIphoneScale;
	
	ofxAssimpModelLoader* model;
	float animationTime;
	
	std::string typeStr;

	// ------------------------------------	
	/*int cubeAmount;
	ofVec3f* cubePositions;	
	ofVec3f* cubeRotations;		
	float* cubeSizes*/;
	
	// ------------------------------------
	
	SimpleTerrain testTerrain;
	ofVbo surfaceVbo;
	
	SimpleTerrain testDistortedTerrain;	
	PerlinNoise terrainNoise;
	ofVbo distortedTerrainVbo;
	
	
	int surfaceGridX;
	int surfaceGridY;
	float surfaceSpacingX;
	float surfaceSpacingY;	
	int surfacePointAmount;	
	int surfaceTriangleAmount;
	ofVec3f* surfacePoints;
	ofVec3f* surfaceNormals;
	ofFloatColor* surfaceColors;
	ofIndexType* surfaceIndices;
	
	// ------------------------------------	
	ofVboMesh mesh;
	ofPoint position;
	float normScale;
	ofPoint scale;
	ofPoint sceneCenter;
	ofTexture tex;
	ofLight	light;	
	
	int counter;

	// ------------------------------------
	// For VBO test 2
	int			vboMode;
	ofVec2f		cameraRotation;	
	
	// particles
	int			particleCount;
	ofVec2f		particlePos[NUM_PARTICLES];
	ofVec2f		particleVel[NUM_PARTICLES];
	ofFloatColor		particleColor[NUM_PARTICLES];
	float		particleTime[NUM_PARTICLES];
	ofVbo		particleVbo;
	
	// the stars
	ofVbo		ptsVbo;
	ofVec3f		pts[NUM_PTS];
	ofFloatColor		color[NUM_PTS];
	float	    fadeSpeed[NUM_PTS];
	bool		fadeFlip[NUM_PTS];
	
	// the worm
	int			wormDrawMode;
	ofVbo		wormVbo;
	ofVec3f		worm[WORM_LEN];
	ofFloatColor		wormColor[WORM_LEN];
	
	// ------------------------------------	
	ofVbo	vbo;
	ofVec3f pos[GRID_WIDTH*GRID_HEIGHT*LENGTH];
	ofVec3f norm[GRID_WIDTH*GRID_HEIGHT*LENGTH];	
	ofFloatColor col[GRID_WIDTH*GRID_HEIGHT*LENGTH];	
	ofVec3f center;
	int		space;
	float   restLength;
	int		total;	
	
};

