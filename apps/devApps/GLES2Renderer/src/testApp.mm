
#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup()
{
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	//ofSetLogLevel( OF_LOG_NOTICE );
	ofSetLogLevel( OF_LOG_VERBOSE );
	
	/*
	int overrideGLVersion = 2;
#ifndef OPENGLES_VERSION_2
	overrideGLVersion = 1;
#endif	
	ofSetCurrentRenderer(ofPtr<ofBaseRenderer>(new ofGLES2Renderer(overrideGLVersion)));
	*/	
	 
	//ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	//ipad doesn't need no scale ;) 
	appIphoneScale = 1.0;

	ofBackground(140,140,140);	
	ofSetFrameRate(60);
	
	ofSetCircleResolution( 50 );
	
	nCurveVertexes = 7;
	
	curveVertices[0].x = 326;
	curveVertices[0].y = 209;
	curveVertices[1].x = 306;
	curveVertices[1].y = 279;
	curveVertices[2].x = 265;
	curveVertices[2].y = 331;
	curveVertices[3].x = 304;
	curveVertices[3].y = 383;
	curveVertices[4].x = 374;
	curveVertices[4].y = 383;
	curveVertices[5].x = 418;
	curveVertices[5].y = 309;
	curveVertices[6].x = 345;
	curveVertices[6].y = 279;
	
	for (int i = 0; i < nCurveVertexes; i++){
		curveVertices[i].bOver 			= false;
		curveVertices[i].bBeingDragged 	= false;
		curveVertices[i].radius = 4;
	}

	checkGlError( glGetError(), __FILE__, __LINE__ );		
	
	//testImage.loadImage("boy_10.tga");
	testImage.loadImage("tdf_1972_poster.jpg");	
	
	//ofDisableArbTex();
	testImage2.loadImage("bikers.jpg");
	//ofEnableArbTex();
	
	testImageAlpha.loadImage("AlphaTest.png");
	
	debugTextureImage.loadImage("Vatrobot_tile6_debug_texture.jpeg");
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	ofSetGlobalAmbientColor( ofColor( 40.0f, 40.0f, 40.0f) );		
	
	//ofSetGlobalAmbientColor( ofColor( 255.0f, 255.0f, 255.0f) );		
	
	//GLfloat global_ambient[] = { 40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f };
	//ofGetGLES2Context()->glLightModelfv(GL_LIGHT_MODEL_AMBIENT, global_ambient);	
	
	
	pointLight.setAmbientColor( ofFloatColor( 0.0f, 0.0f, 0.0f) );
	pointLight.setDiffuseColor( ofFloatColor( 1.0f, 1.0f, 1.0f) );
	pointLight.setSpecularColor(ofFloatColor( 0.5f, 0.5f, 0.5f) );
	pointLight.setPosition( 0.0f, 10.0f, 0.0f );	
	pointLight.setPointLight();
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
//	spotLight.setDiffuseColor( ofColor(255, 0, 0) );
//	spotLight.setSpecularColor( ofColor(255, 255, 255) );
//	spotLight.setSpotlight(40, 6);

	checkGlError( glGetError(), __FILE__, __LINE__ );		
	
//	directionalLight.setDiffuseColor( ofColor(0, 0, 255) );
//	directionalLight.setSpecularColor( ofColor(255, 255, 255) );
//	directionalLight.setDirectional();
//	directionalLight.setOrientation( ofVec3f(0, 90, 0) );	

	//material.setDiffuseColor(ofFloatColor(30.0f / 255.0f, 161.0f / 255.0f, 244.0f / 255.0f, 1.0f));		
	material.setDiffuseColor(ofFloatColor(0.0f, 1.0f, 0.0f, 1.0f));			
	material.setSpecularColor(ofFloatColor(1.0f, 1.0f, 1.0f, 1.0f));	
	material.setShininess( 127 );

	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	//ofSetSmoothLighting(true);
	
	bPointLight = bSpotLight = bDirLight = true;
	
	
	checkGlError( glGetError(), __FILE__, __LINE__ );
	
	
	// we need GL_TEXTURE_2D for our models coords.
	ofDisableArbTex();
 

	string modelPath = "astroBoy_walk.dae";
	//string modelPath = "teapot-530verts.dae";	
	model = new ofxAssimpModelLoader();

	if(model->loadModel(modelPath,true)){
    	model->setAnimation(0);
    	//model.setPosition(ofGetWidth()/2, (float)ofGetHeight() * 0.75 , 0);
    	//model.createLightsFromAiModel();
    	//model.disableTextures();
    	//model.disableMaterials();
    }

	 ofEnableBlendMode(OF_BLENDMODE_ALPHA);
	 animationTime = 0.0f;

 
	 //some model / light stuff
	 //glShadeModel(GL_SMOOTH);
	 //light.enable();
	 //ofEnableSeparateSpecularLight();
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	franklinBook14.loadFont("frabk.ttf", 14);
	franklinBook14.setLineHeight(18.0f);
	franklinBook14.setLetterSpacing(1.037);	
	
	typeStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n0123456789,:&!?";
	
	checkGlError( glGetError(), __FILE__, __LINE__ );
	
	
	ofFbo::Settings tmpScreenFBOSettings = ofFbo::Settings(); 
	tmpScreenFBOSettings.width  = 1024;
	tmpScreenFBOSettings.height = 768;	
	tmpScreenFBOSettings.useDepth = true;
	tmpScreenFBOSettings.useStencil = false;
	tmpScreenFBOSettings.internalformat = GL_RGB;
	
	screenFBO.allocate( tmpScreenFBOSettings ); 	
	
	 
	checkGlError( glGetError(), __FILE__, __LINE__ );
	
#ifdef OPENGLES_VERSION_2	

	testShader.load("shaders/TestShader");
	
	shaderBlur.setup( 1024, 768 );
	shaderBlur.clearColor.set( 100, 100, 100, 255);

	//testSurfaceShader.load("shaders/TestSurfaceShader");
	
#endif	
	
	mouseX = 400;
	mouseY = 400;	
	
	// -----------------------------------------------------
	
	counter = 0;
	total = 0;
	
	restLength = 3.0;
	space      = 4;
	
	center.x   = ((GRID_WIDTH-1)  * space) / 2;
	center.y   = ((GRID_HEIGHT-1) * space) / 2;
	
	for (int i=0; i<GRID_WIDTH; i++) {
		for (int j=0; j<GRID_HEIGHT; j++) {
			
			int x	  = (i * space) - center.x;
			int y     = 0;
			int z     = (j * space) - center.y;
			int index = (j*GRID_WIDTH+i) * LENGTH;
			
			// now we are at each line
			for (int k=0; k<LENGTH; k++) {
				y = ofMap(k, 0, LENGTH, 0, 50);
				pos[index + k].set( x, y, z );
				
				float tmpFrac = k / ((float)LENGTH-1);
				col[index + k].set( tmpFrac, tmpFrac, tmpFrac );
				
				norm[index + k].set( /*0.0f, 0.0f, 0.0f*/ ofRandom(100.0f), ofRandom(100.0f), ofRandom(100.0f));
			}
		}
	}
	
	total = GRID_WIDTH*GRID_HEIGHT*LENGTH;
	vbo.setVertexData(pos, total, GL_DYNAMIC_DRAW);	
	vbo.setColorData(col, total, GL_DYNAMIC_DRAW);		
	vbo.setNormalData(norm, total, GL_DYNAMIC_DRAW);	// throw some normals in there too, not used in rendering
	
	
	// -----------------------------------------------------
	
	initVBOTest2();
	vboMode = 0;
	
	
	// -----------------------------------------------------
	// Massive overkill to get a nice floor to light, it needs resolution (when not using per pixel lighting)

	
	testTerrain.setup( 20, 20, 600.0f, 600.0f );
	
	testTerrain.computeVertexNormals(); // testing testing
	
	surfaceVbo.setVertexData( testTerrain.surfacePoints,  testTerrain.pointAmount, GL_DYNAMIC_DRAW );	
	surfaceVbo.setColorData(  testTerrain.surfaceColors,  testTerrain.pointAmount, GL_DYNAMIC_DRAW );
	surfaceVbo.setNormalData( testTerrain.surfaceNormals, testTerrain.pointAmount, GL_DYNAMIC_DRAW );	

	surfaceVbo.setTexCoordData( testTerrain.surfaceTexCoords, testTerrain.pointAmount, GL_DYNAMIC_DRAW );	
	
	surfaceVbo.setIndexData(  testTerrain.surfaceIndices,  testTerrain.triangleAmount*3, GL_DYNAMIC_DRAW );	
	// -----------------------------------------------------	
	
	testDistortedTerrain.setup( 30, 30, 600.0f, 600.0f );	
	
	distortedTerrainVbo.setVertexData( testDistortedTerrain.surfacePoints,  testDistortedTerrain.pointAmount, GL_DYNAMIC_DRAW );	
	distortedTerrainVbo.setColorData(  testDistortedTerrain.surfaceColors,  testDistortedTerrain.pointAmount, GL_DYNAMIC_DRAW );
	distortedTerrainVbo.setNormalData( testDistortedTerrain.surfaceNormals, testDistortedTerrain.pointAmount, GL_DYNAMIC_DRAW );	

	distortedTerrainVbo.setTexCoordData( testDistortedTerrain.surfaceTexCoords, testDistortedTerrain.pointAmount, GL_DYNAMIC_DRAW );		
	
	distortedTerrainVbo.setIndexData(  testDistortedTerrain.surfaceIndices,  testDistortedTerrain.triangleAmount*3, GL_DYNAMIC_DRAW );	
	
	terrainNoise.Set( 0.5,  0.1f, 180.0f, 3, 12345 );
	
	//string extensions = (char*)glGetString(GL_EXTENSIONS);
	//ofLog(OF_LOG_VERBOSE,extensions);

	//string glEsVersion = (char*)glGetString(GL_VERSION);
	//ofLog(OF_LOG_VERBOSE,glEsVersion);	
	
	//string glslVersion = (char*)glGetString(GL_SHADING_LANGUAGE_VERSION);
	//ofLog(OF_LOG_VERBOSE,glslVersion);
	
	float debugNormalScale = 20.0f;
	
	ofGenerateSphereMesh( sphereMesh, 100.0f, 16, 16 );
	generateDebugNormalsMesh( sphereMesh, sphereDebugNormalsMesh, debugNormalScale );

	
	ofGenerateTorusMesh( torusMesh, 100.0f, 20.0f, 16, 26 );	
	generateDebugNormalsMesh( torusMesh, torusDebugNormalsMesh, debugNormalScale );	
	
	
	ofGenerateConeMesh( coneMesh, 100.0f, 300.0f, 16, 16 );		
	generateDebugNormalsMesh( coneMesh, coneDebugNormalsMesh, debugNormalScale );	

	ofGenerateCylinderMesh( cylinderMesh, 40.0f, 100.0f, 16,  16, true );
	generateDebugNormalsMesh( cylinderMesh, cylinderDebugNormalsMesh, debugNormalScale );		
	
	ofGenerateCapsuleMesh( capsuleMesh, 40.0f, 100.0f, 8, 16, 1 );
	generateDebugNormalsMesh( capsuleMesh, capsuleDebugNormalsMesh, debugNormalScale );	
	
	//string pos_x, string pos_y, string pos_z, string neg_x,string neg_y,string neg_z
	

	testCubemap.loadImages("cubemaps/summer_scene/cubescene_rt.jpg", 
						   "cubemaps/summer_scene/cubescene_up.jpg", 
						   "cubemaps/summer_scene/cubescene_fr.jpg", 
						   "cubemaps/summer_scene/cubescene_lf.jpg",
						   "cubemaps/summer_scene/cubescene_dn.jpg",
						   "cubemaps/summer_scene/cubescene_bk.jpg" );
	
	/*testCubemap.loadImages("cubemaps/cubemap_debug/debug_positive_x.png", 
						   "cubemaps/cubemap_debug/debug_positive_y.png", 
						   "cubemaps/cubemap_debug/debug_positive_z.png", 
						   "cubemaps/cubemap_debug/debug_negative_x.png",
						   "cubemaps/cubemap_debug/debug_negative_y.png",
						   "cubemaps/cubemap_debug/debug_negative_z.png" );	*/
	
	//glassSurfaceShader.load("shaders/Glass");
	glassSurfaceShader.load("shaders/Reflection");	
	
	cubeMapShader.load("shaders/Cubemap");
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
}


//	{ GLenum tmpError = glGetError(); if( tmpError != GL_NO_ERROR ) { cout << "GL Error: " << tmpError << " in " << __FILE__ << " at line: " << __LINE__ << endl;} }

/*
 gestureRecognizer = [[AiOSGestureRecognizer alloc] init];
 [gestureRecognizer addGestureRecognizers: ofxiPhoneGetGLView()];
 
 ofAddListener( gestureRecognizer->newTapEvent, this, &TimeVideo::receivedTap );	
 ofAddListener( gestureRecognizer->newPinchEvent, this, &TimeVideo::receivedPinch );		
 ofAddListener( gestureRecognizer->newSwipeEvent, this, &TimeVideo::receivedSwipe );			
 ofAddListener( gestureRecognizer->newPanEvent, this, &TimeVideo::receivedPan );
 
 */


//--------------------------------------------------------------
void testApp::update()
{
	counter++;
	
	float radius = 20.0f; 
	//ofVec3f center(0.0f,-110.0f, 0);	
	ofVec3f center(0.0f,20.0f, 0);		
	
	pointLight.setPosition( cos(ofGetElapsedTimef()*0.8f) * radius * 2 + center.x, 
						    sin(ofGetElapsedTimef()*0.6f) * radius * 2 + center.y, 
						   -cos(ofGetElapsedTimef()*0.7f) * radius * 2 + center.z ); 
	
	
	//spotLight.setOrientation( ofVec3f( 0, cos(ofGetElapsedTimef()) * RAD_TO_DEG, 0) );
	//spotLight.setPosition( mouseX, mouseY, 200);	
	
}

//--------------------------------------------------------------
void testApp::draw()
{
	//ofGetGLRenderer()->setupScreenPerspective(0, 0, OF_ORIENTATION_UNKNOWN, true, 60, 0.0f, 1024.0f);
	ofGetCurrentRenderer()->setupScreenPerspective(0, 0, OF_ORIENTATION_UNKNOWN, true, 60, 0.0f, 1024.0f);
	
	ofScale(appIphoneScale, appIphoneScale, 1.0);


	checkGlError( glGetError(), __FILE__, __LINE__ );

/*	
 	// 
	screenFBO.begin();		
		ofClear( 100.0f, 100.0f, 100.0f, 255.0f );	
		drawSceneSimple();
	screenFBO.end();	

	ofSetColor(255,255,255, 255);
	
	testShader.begin();
	testShader.setUniform1f("u_time", ofGetElapsedTimef() );
		ofPushMatrix();
			ofRotate( 90.0f );
			screenFBO.draw(0.0f,-768.0f, 1024, 768 );
		ofPopMatrix(); 
	testShader.end();
*/
	
	
/*	
	shaderBlur.beginRender();
		drawSceneSimple();
		//drawSceneModel();
		//drawSceneVBO();
	shaderBlur.endRender();	
	shaderBlur.performBlur();
	
	ofSetColor(255,255,255, 255);	
	ofPushMatrix();
		ofRotate( 90.0f );
		shaderBlur.draw(0.0f,-768.0f, 1024, 768 );
	ofPopMatrix();	
*/	
	
	
	//drawSceneSimple();
	//drawSceneVBO();
	//drawSceneModel();	
	//drawSceneVBOTest2();
	//drawSceneLightingTest();
	//drawSceneLightingCubeGridTest();
	drawSceneCustomShaderForVBOTest();
	
	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	string tmpStr = "fps: "+ofToString(ofGetFrameRate(), 2);
  	ofSetColor(0, 0, 0); 		ofDrawBitmapString(tmpStr, 21, 26,0);
    ofSetColor(255, 255, 255); 	ofDrawBitmapString(tmpStr, 20, 25,0);	
}

//--------------------------------------------------------------
void testApp::drawSceneCustomShaderForVBOTest()
{
	
	/*
	//terrainNoise
	for( int i = 0; i < testDistortedTerrain.pointAmount; i++ ){
		float tmpX = testDistortedTerrain.surfacePoints[i].x + (ofGetElapsedTimef() * 20.4f );
		float tmpY = testDistortedTerrain.surfacePoints[i].z + (ofGetElapsedTimef() * 20.0f );
		
		tmpX *= 0.1f;
		tmpY *= 0.1f;
		
		testDistortedTerrain.surfacePoints[i].y = terrainNoise.GetHeight( tmpX, tmpY );
	}
	testDistortedTerrain.computeVertexNormals();
	
	distortedTerrainVbo.updateVertexData( testDistortedTerrain.surfacePoints,  testDistortedTerrain.pointAmount );	
	distortedTerrainVbo.updateNormalData( testDistortedTerrain.surfaceNormals, testDistortedTerrain.pointAmount );	
	*/
	
	
	/*
	 noiseX = (tmpPoint.x / globalVariables->noiseSizeDivisor) + noiseOffsetY;
	 noiseY = (tmpPoint.y / globalVariables->noiseSizeDivisor) + noiseOffsetY;
	 tmpNoise = ofNoise( noiseX, noiseY, globalVariables->noiseZ );
	 */
	
//	_ofEnable( GL_CULL_FACE );	
	ofLightingModel(GL_SMOOTH);	// We want per pixel lighting.	
	
	ofPushMatrix();
	
	
		// we need to set our own transform, setupScreen does it's on setup
		ofLoadIdentityMatrix();

		
//		ofEnableLighting();
	
	
		// draw the skybox/cubemap
		/*testCubemap.bind();
		cubeMapShader.begin();
		cubeMapShader.setUniform1i("u_cubeSampler", 0 ); // the texture unit it is in
		ofBox( 800.0f );
		cubeMapShader.end();
		testCubemap.unbind();*/
	
		checkGlError( glGetError(), __FILE__, __LINE__ );	
		
		ofMatrix4x4 tmpModelView;
		tmpModelView.glRotate( -mouseX, 0, 1, 0 );
		tmpModelView.glRotate( -mouseY, 1, 0, 0 );
		ofLoadMatrix( &tmpModelView );

		ofEnableDepthTest();		
	
		ofPushMatrix();
			ofTranslate( ofVec3f( 0.0f, 0.0f, 100.0f) );
			ofBox( 40.0f );
		ofPopMatrix();
	
		//ofRotate(-mouseX, 0, 1, 0);
		//ofRotate(-mouseY, 1, 0, 0);	
/*	
		testCubemap.bind();	
	
		cubeMapShader.begin();
		cubeMapShader.setUniform1i("u_cubeSampler", 0 ); // the texture unit it is in	
		ofBox( 250.0f );
		cubeMapShader.end();
*/	

	
		ofVec3f cameraPos( 0.0f, 0.0f, -200 );	
		//ofVec3f cameraPos( cos(ofGetElapsedTimef()*1.8f) * 200.0f, sin(ofGetElapsedTimef()*1.8f) * 200.0f, -200 );		
		
		ofMatrix4x4 lookAtMatrix; 
		lookAtMatrix.makeLookAtViewMatrix( cameraPos, ofVec3f(0, 0, 0), ofVec3f(0, 1, 0) );
		//ofMultMatrix( lookAtMatrix.getPtr() );	
		tmpModelView.postMult( lookAtMatrix );
		ofLoadMatrix( &tmpModelView );	
	
		//cout << tmpModelView.getTranslation() << endl;
	
		ofVec3f tmpWorldPos = ofVec3f(0.0f, 0.0f, 0.0f) * tmpModelView;
		cout << tmpWorldPos << endl;
	
		pointLight.enable();	
		pointLight.setPosition( pointLight.getPosition() );	// Lighting position has to be set when you have the matrix you want, this forces a call to onPositionChanged
	
		material.begin();	
	
	//	debugTextureImage.getTextureReference().bind();
	
	//	testSurfaceShader.begin();
	//	testSurfaceShader.setUniform1f("u_time", ofGetElapsedTimef() );

		//sphereMesh.drawFaces();	
		//cylinderMesh.drawFaces();		
		//torusMesh.drawFaces();		
		//coneMesh.drawFaces();
		//capsuleMesh.drawFaces();
	
		testCubemap.bind();
		//testCubemap.bindMulti(1);	
	
		glassSurfaceShader.begin();
		glassSurfaceShader.setUniform3f("u_eyePos", cameraPos.x, cameraPos.y, cameraPos.z );	
		glassSurfaceShader.setUniform1i("u_cubeSampler", 0 ); // the texture unit it is in
	
		//debugTextureImage.draw(0.0f, 0.0f, 512.0f, 512.0f);
	
		
			/*ofPushMatrix();
				//ofScale( -1.0, -1.0, -1.0 );
				ofBox( 400.0f );
			ofPopMatrix();*/
	
	
			ofCylinder( ofPoint( -60.0f, 0.0f, 0.0f ), 10.0f, 20.0f );
		
			ofCone( 	ofPoint( -30.0f, 0.0f, 0.0f ), 10.0f, 20.0f );	
		
			ofSphere( 	ofPoint(   0.0f, 0.0f, 0.0f ), 20.0f );		

			ofTorus( 	ofPoint(  30.0f, 0.0f, 0.0f ), 8.0f, 4.0f );		
		
			ofCapsule( 	ofPoint(  60.0f, 0.0f, 0.0f ), 10.0f, 20.0f );
			 
	
			//model->drawFaces();
			 
			/*surfaceVbo.bind();
				surfaceVbo.drawElements(GL_TRIANGLES, testTerrain.triangleAmount * 3 );
			surfaceVbo.unbind();*/
	 
		glassSurfaceShader.end();	
		testCubemap.unbind();
	
		
		//distortedTerrainVbo.bind();
		//	distortedTerrainVbo.drawElements( GL_TRIANGLES, testDistortedTerrain.triangleAmount * 3 );
		//distortedTerrainVbo.unbind();	
		
		//ofBox( 120.0f );
		 
		 
		//ofPushMatrix();

		//	ofTranslate( 100.0f, -80.0f, 0.0f );
		//	sphereMesh.drawFaces();

		//	ofTranslate( -100.0f,  0.0f, 0.0f );	
		//	torusMesh.drawFaces();
	
		//ofPopMatrix();

		
		 
	//	testSurfaceShader.end();	

	//	debugTextureImage.getTextureReference().unbind();	
	
		material.end();
	
		pointLight.disable();

		ofDisableLighting();		

		//coneDebugNormalsMesh.draw();
		//torusDebugNormalsMesh.draw();	
		//sphereDebugNormalsMesh.draw();		
		//cylinderDebugNormalsMesh.draw();			
		//capsuleDebugNormalsMesh.draw();
	
		pointLight.draw();			
	
		ofDisableDepthTest();
	
    ofPopMatrix();
		
	_ofDisable( GL_CULL_FACE );	
	
	checkGlError( glGetError(), __FILE__, __LINE__ );		
}

//--------------------------------------------------------------
void testApp::drawSceneLightingTest()
{
	
	// update animation 
	animationTime += ofGetLastFrameTime();
	if( animationTime >= 1.0 ){
		animationTime = 0.0;
	}
	model->setNormalizedTime(animationTime);
	
	
	_ofEnable( GL_CULL_FACE );	
	
	ofLightingModel(GL_SMOOTH);	// We want per pixel lighting.
		
	ofEnableDepthTest();
	
	ofPushMatrix();
	
		ofEnableLighting();
	
		checkGlError( glGetError(), __FILE__, __LINE__ );	
	
		ofTranslate( ofGetWidth()/2.0f, ofGetHeight()/2.0f, 0);
		ofRotate(-mouseX, 0, 1, 0);
		ofRotate(-mouseY, 1, 0, 0);

		pointLight.enable();	
		pointLight.setPosition( pointLight.getPosition() );	// Lighting position has to be set when you have the matrix you want, this forces a call to onPositionChanged
	
		material.begin();
	
		surfaceVbo.bind();
			surfaceVbo.drawElements(GL_TRIANGLES, testTerrain.triangleAmount * 3 );
			//surfaceVbo.drawElements(GL_TRIANGLES, surfaceTriangleAmount * 3 );	
		surfaceVbo.unbind();	
		
		material.end();
	
		model->drawFaces();
	
		//_ofEnable(GL_CULL_FACE);
	
		ofSetColor(255, 0, 0);
		ofBox( 180.0f, -61.0f, 0.0f, 120.0f );
	
		pointLight.disable();
	
		ofDisableLighting();		
	
		pointLight.draw();		
	
    ofPopMatrix();
	
	ofDisableDepthTest();
	
	checkGlError( glGetError(), __FILE__, __LINE__ );		
}

//--------------------------------------------------------------
void testApp::drawSceneLightingCubeGridTest()
{
	int gridResX = 10;
	int gridResY = 10;	
	float gridSpacingX = 50.0f;
	float gridSpacingY = 50.0f;	 
	
	float cubeSize = 40.0f;
		
	
	_ofEnable(GL_NORMALIZE);	
	
	ofLightingModel(GL_SMOOTH);	
	
	ofEnableDepthTest();
	
	ofPushMatrix();
	
		ofEnableLighting();
		
			checkGlError( glGetError(), __FILE__, __LINE__ );	
			
			ofTranslate( ofGetWidth()/2.0f, ofGetHeight()/2.0f, 0);
			ofRotate(-mouseX, 0, 1, 0);
			ofRotate(-mouseY, 1, 0, 0);	
			
			pointLight.enable();	
	
			pointLight.setPosition( pointLight.getPosition() );	// trying a setting a normalized light position
	
			material.begin();	
	
			for( int i = 0; i < gridResX; i++){
				for( int j = 0; j < gridResY; j++){
					float tmpX = (i * gridSpacingX) - ( gridSpacingX * (gridResX / 2));
					float tmpZ = (j * gridSpacingY) - ( gridSpacingY * (gridResY / 2));		
					
					ofPushMatrix();
					
						ofRotateX( (i + j) * 12 );
					
						ofBox( tmpX, 0.0f, tmpZ, cubeSize );
					
					ofPopMatrix();
				}
			}	
			
			material.end();
	
			pointLight.disable();
		
		ofDisableLighting();		
		
		pointLight.draw();		
	
    ofPopMatrix();
	
	ofDisableDepthTest();
	
	checkGlError( glGetError(), __FILE__, __LINE__ );		

}

//--------------------------------------------------------------
void testApp::drawSceneVBO()
{
	// Update
	
	ofFloatColor mainCol = ofColor::fromHsb( fmodf(ofGetElapsedTimef() * 50.0f, 255.0f), 255.0f, 255.0f);

	ofVec3f vec;
	float   r = 0.3;
	//total = 0;
	for (int i=0; i<GRID_WIDTH; i++) {
		for (int j=0; j<GRID_HEIGHT; j++) {
			
			int x	  = (i * space) - center.x;
			int y     = 0;
			int z     = (j * space) - center.y;
			int index = (j*GRID_WIDTH+i) * LENGTH;
			pos[index].set(x, y, z);
			pos[index+1].set(x+ofRandom(-r,r), y+ofRandom(-r,r), z+ofRandom(-r,r));
			pos[index+1].y -= 1.0;
			
			for (int k=2; k<LENGTH; k++) {
				vec		 =  pos[index + k] - pos[index + (k-2)];
				float d  = vec.length();
				if(d > 0.0) {
					pos[index + k] = pos[index + k-1] + (vec * restLength) /d;
				}	
				
				float tmpFrac = k / ((float)LENGTH-1);
				col[index + k].set( mainCol.r * tmpFrac, mainCol.g * tmpFrac, mainCol.b * tmpFrac );				
				
			}
		}
	}
	
	ofPushMatrix();
	
	
		ofTranslate(ofGetWidth()/2, ofGetHeight()/2,/*( 10 + AMathHelpers::cosZeroToOne( ofGetElapsedTimef() ) * -200.0f )*/ 700.0f );
		
		ofRotate(ofGetElapsedTimef()*.6 * RAD_TO_DEG, 1, 0, 0);
		ofRotate(ofGetElapsedTimef()*.8 * RAD_TO_DEG, 0, 1, 0);
		
		// the lines
		ofEnableAlphaBlending();
	
	
		ofSetColor(255, 255, 255);
		checkGlError( glGetError(), __FILE__, __LINE__ );	
		vbo.bind();
		checkGlError( glGetError(), __FILE__, __LINE__ );	
	
		vbo.updateVertexData(pos, total);
		vbo.updateColorData(col, total);		
	
		checkGlError( glGetError(), __FILE__, __LINE__ );	
		
	
		for (int i=0; i<GRID_WIDTH; i++) {
			for (int j=0; j<GRID_HEIGHT; j++) {
				int index = (j*GRID_WIDTH+i) * LENGTH;
				vbo.draw(GL_LINE_STRIP, index, LENGTH);
			}
		}
	
	
		vbo.draw( GL_POINTS, 0, total );
	 
		checkGlError( glGetError(), __FILE__, __LINE__ );
	
		vbo.unbind();	
	
		checkGlError( glGetError(), __FILE__, __LINE__ );
	
		ofDisableAlphaBlending();
	
		//ofBox( 16.0f );
	
		checkGlError( glGetError(), __FILE__, __LINE__ );
	
	ofPopMatrix();	

}


//--------------------------------------------------------------
void testApp::drawSceneModel()
{
	checkGlError( glGetError(), __FILE__, __LINE__ );		
	
	_ofEnable( GL_DEPTH_TEST );
	
/*	animationTime += ofGetLastFrameTime();
	if( animationTime >= 1.0 ){
		animationTime = 0.0;
	}
	model.setNormalizedTime(animationTime);
	mesh = model.getCurrentAnimatedMesh(0);	
	
	checkGlError( glGetError(), __FILE__, __LINE__ );		
	
	ofPushMatrix();
	
		ofTranslate( ofGetWidth()/2.0f, ofGetHeight() * 0.75f, 0);
		ofRotate(-mouseX, 0, 1, 0);
	
		model.drawFaces();

		ofTranslate(200.0f, 0.0f, 0.0f);	

		model.drawWireframe();
	
		checkGlError( glGetError(), __FILE__, __LINE__ );		
    ofPopMatrix();
*/	
	checkGlError( glGetError(), __FILE__, __LINE__ );		
	
	_ofDisable( GL_DEPTH_TEST );	
}


//--------------------------------------------------------------
void testApp::generateDebugNormalsMesh( ofMesh& _srcMesh, ofMesh& _dstMesh, float _debugNormalScale ){
	
	_dstMesh.setMode(OF_PRIMITIVE_LINES );			
	ofVec3f* vertices = _srcMesh.getVerticesPointer();
	ofVec3f* normals = _srcMesh.getNormalsPointer();	
	for( int i = 0; i < _srcMesh.getNumVertices(); i++ ){
		ofVec3f start = vertices[i];
		ofVec3f end = start + ( normals[i] * _debugNormalScale );	
		_dstMesh.addVertex( start );
		_dstMesh.addVertex( end );			
	}	
}

//--------------------------------------------------------------
void testApp::drawSceneSimple()
{
	ofFill();	
	
	ofSetColor(150,150,150, 255);	
	ofLine( 0.0f, 0.0f, 1024.0f, 768.0f );
	
	ofSetColor(255,0,255, 255);
	
	ofEnableAlphaBlending();
	
	ofCircle( 700.0f, 512.0f, 0.0f, 50.0f );
	
	ofSetColor(0,255,255, 100);	
	ofCircle( 700.0f, 560.0f, 0.0f, 20.0f );	
	
	ofSetColor(255,0,255, 255);	
	ofEllipse( 790.0f, 512.0f, 0.0f, 50.0f, 90.0f );	
	
	ofTriangle( 850.0f, 512.0f, 880.0f, 512.0f, 850.0f, 600.0f );		
	
	ofLine( 900.0f, 512.0f, 900.0f, 600.0f );			
	
	ofRect( 920.0f, 512.0f, 50.0f, 50.0f );	
	
	ofDisableAlphaBlending();
		
	_ofEnable( GL_DEPTH_TEST );
//	_ofEnable( GL_NORMALIZE );	
	
	ofSetColor(255,255,255, 255);	
	
	
	ofEnableLighting();
	
	//	material.begin();

	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
	if (bPointLight) pointLight.enable();	

	checkGlError( glGetError(), __FILE__, __LINE__ );
	
	
	ofPushMatrix();
	
		ofTranslate(800.0f, ofGetHeight() / 2.0f, 00.f);
			
		ofRotate(ofGetElapsedTimef()*.6 * RAD_TO_DEG, 1, 0, 0);
		ofRotate(ofGetElapsedTimef()*.8 * RAD_TO_DEG, 0, 1, 0);
		
		//model.drawFaces();	
#ifdef OPENGLES_VERSION_2	
		drawCube( 120.0f );
#endif
	//ofRect( 0.0, 0.0f, 100.0f, 100.0f );
		//drawIcosahedron( 120.0f );
	
	ofPopMatrix();
	

	checkGlError( glGetError(), __FILE__, __LINE__ );	
	
 	pointLight.disable();

	
	//	material.end();	
	ofDisableLighting();
 
	
	ofSetColor( pointLight.getDiffuseColor() );
	if(bPointLight) pointLight.draw();
	
	//	ofSetColor( spotLight.getDiffuseColor() );
	//	if(bSpotLight) spotLight.draw();
	
//	_ofDisable( GL_CULL_FACE );
	_ofDisable( GL_DEPTH_TEST );
	
	
	ofEnableAlphaBlending();	
	
	ofSetColor(255,255,255);	
	testImage.draw( 870.0f, 20.0f, testImage.getWidth() / 3.0f, testImage.getHeight() / 3.0f );
		
	ofSetColor(255,255,255, AMathHelpers::cosZeroToOne( ofGetElapsedTimef() ) * 255 );		
	testImage2.draw( 870.0f, 200.0f, testImage2.getWidth() / 3.0f, testImage2.getHeight() / 3.0f );
	
	ofSetColor(255,255,255, 255 - (AMathHelpers::cosZeroToOne( ofGetElapsedTimef() ) * 255) );
	testImageAlpha.draw( 960.0f, 350.0f, testImageAlpha.getWidth() / 2.0f, testImageAlpha.getHeight() / 2.0f );
	
	ofDisableAlphaBlending();	
	
	
	
	ofSetColor(225);
	franklinBook14.drawString("franklin book 14pt - ", 30, 700);
	franklinBook14.drawString(typeStr, 30, 720);
	
	
	ofFill();
	ofSetHexColor(0xe0be21);
	
	//------(a)--------------------------------------
	// 
	// 		draw a star
	//
	// 		use poly winding odd, the default rule
	//
	// 		info about the winding rules is here:
	//		http://glprogramming.com/red/images/Image128.gif
	// 
	ofSetPolyMode(OF_POLY_WINDING_ODD);	// this is the normal mode
	ofBeginShape();
	ofVertex(200,135);
	ofVertex(15,135);
	ofVertex(165,25);
	ofVertex(105,200);
	ofVertex(50,25);
	ofEndShape();
	
	
	//------(b)--------------------------------------
	// 
	// 		draw a star
	//
	// 		use poly winding nonzero
	//
	// 		info about the winding rules is here:
	//		http://glprogramming.com/red/images/Image128.gif
	// 
	ofSetHexColor(0xb5de10);
	ofSetPolyMode(OF_POLY_WINDING_NONZERO);
	ofBeginShape();
	ofVertex(400,135);
	ofVertex(215,135);
	ofVertex(365,25);
	ofVertex(305,200);
	ofVertex(250,25);
	ofEndShape();
	//-------------------------------------
	
	
	
	//------(c)--------------------------------------
	// 
	// 		draw a star dynamically
	//
	// 		use the mouse position as a pct
	//		to calc nPoints and internal point radius
	//
	float xPct = (float)(mouseX) / (float)(ofGetWidth());
	float yPct = (float)(mouseY) / (float)(ofGetHeight());
	int nTips = 5 + xPct * 60;
	int nStarPts = nTips * 2;
	float angleChangePerPt = TWO_PI / (float)nStarPts;
	float innerRadius = 0 + yPct*80;
	float outerRadius = 80;
	float origx = 525;
	float origy = 100;
	float angle = 0;
	
	ofSetHexColor(0xa16bca);
	ofBeginShape();
	for (int i = 0; i < nStarPts; i++){
		if (i % 2 == 0) {
			// inside point:
			float x = origx + innerRadius * cos(angle);
			float y = origy + innerRadius * sin(angle);
			ofVertex(x,y);
		} else {
			// outside point
			float x = origx + outerRadius * cos(angle);
			float y = origy + outerRadius * sin(angle);
			ofVertex(x,y);
		}
		angle += angleChangePerPt;
	}
	ofEndShape();
	//-------------------------------------
	
	//------(d)--------------------------------------
	// 
	// 		poylgon of random points
	//
	// 		lots of self intersection, 500 pts is a good stress test
	// 
	// 
	ofSetHexColor(0x0cb0b6);
	ofSetPolyMode(OF_POLY_WINDING_ODD);
	ofBeginShape();
	for (int i = 0; i < 10; i++){
		ofVertex(ofRandom(650,850), ofRandom(20,200));
	}
	ofEndShape();
	//-------------------------------------
	
	
	//------(e)--------------------------------------
	// 
	// 		use sin cos and time to make some spirally shape
	//
	ofPushMatrix();
	ofTranslate(100,300,0);
	ofSetHexColor(0xff2220);
	ofFill();
	ofSetPolyMode(OF_POLY_WINDING_ODD);
	ofBeginShape();
	float angleStep 	= TWO_PI/(100.0f + sin(ofGetElapsedTimef()/5.0f) * 60); 
	float radiusAdder 	= 0.5f;
	float radius 		= 0;
	for (int i = 0; i < 200; i++){
		float anglef = (i) * angleStep;
		float x = radius * cos(anglef);
		float y = radius * sin(anglef); 
		ofVertex(x,y);
		radius 	+= radiusAdder; 
	}
	ofEndShape(OF_CLOSE);
	ofPopMatrix();
	//-------------------------------------
	
	//------(f)--------------------------------------
	// 
	// 		ofCurveVertex
	// 
	// 		because it uses catmul rom splines, we need to repeat the first and last 
	// 		items so the curve actually goes through those points
	//
	
	ofSetHexColor(0x2bdbe6);
	ofBeginShape();
	
	for (int i = 0; i < nCurveVertexes; i++){
		
		
		// sorry about all the if/states here, but to do catmull rom curves
		// we need to duplicate the start and end points so the curve acutally 
		// goes through them.
		
		// for i == 0, we just call the vertex twice
		// for i == nCurveVertexes-1 (last point) we call vertex 0 twice
		// otherwise just normal ofCurveVertex call
		
		if (i == 0){
			ofCurveVertex(curveVertices[0].x, curveVertices[0].y); // we need to duplicate 0 for the curve to start at point 0
			ofCurveVertex(curveVertices[0].x, curveVertices[0].y); // we need to duplicate 0 for the curve to start at point 0
		} else if (i == nCurveVertexes-1){
			ofCurveVertex(curveVertices[i].x, curveVertices[i].y);
			ofCurveVertex(curveVertices[0].x, curveVertices[0].y);	// to draw a curve from pt 6 to pt 0
			ofCurveVertex(curveVertices[0].x, curveVertices[0].y);	// we duplicate the first point twice
		} else {
			ofCurveVertex(curveVertices[i].x, curveVertices[i].y);
		}
	}
	
	ofEndShape();
	
	
	// show a faint the non-curve version of the same polygon:
	ofEnableAlphaBlending();
	ofNoFill();
	ofSetColor(0,0,0,40);
	ofBeginShape();
	for (int i = 0; i < nCurveVertexes; i++){
		ofVertex(curveVertices[i].x, curveVertices[i].y);
	}
	ofEndShape(true);
	
	
	ofSetColor(0,0,0,80);
	for (int i = 0; i < nCurveVertexes; i++){
		if (curveVertices[i].bOver == true) ofFill();
		else ofNoFill();
		ofCircle(curveVertices[i].x, curveVertices[i].y,4);
	}
	ofDisableAlphaBlending();
	//-------------------------------------
	
	
	//------(g)--------------------------------------
	// 
	// 		ofBezierVertex
	// 
	// 		with ofBezierVertex we can draw a curve from the current vertex
	//		through the the next three vertexes we pass in.
	//		(two control points and the final bezier point)
	//		
	
	float x0 = 500;
	float y0 = 300;
	float x1 = 550+50*cos(ofGetElapsedTimef()*1.0f);
	float y1 = 300+100*sin(ofGetElapsedTimef()/3.5f);
	float x2 = 600+30*cos(ofGetElapsedTimef()*2.0f);
	float y2 = 300+100*sin(ofGetElapsedTimef());
	float x3 = 650;
	float y3 = 300;
	
	
	
	ofFill();
	ofSetHexColor(0xFF9933);
	ofBeginShape();
	ofVertex(x0,y0);
	ofBezierVertex(x1,y1,x2,y2,x3,y3);
	ofEndShape();
	
	
	ofEnableAlphaBlending();
	ofFill();
	ofSetColor(0,0,0,40);
	ofCircle(x0,y0,4);
	ofCircle(x1,y1,4);
	ofCircle(x2,y2,4);
	ofCircle(x3,y3,4);
	ofDisableAlphaBlending();
	
	
	
	//------(h)--------------------------------------
	// 
	// 		holes / ofNextContour
	// 
	// 		with ofNextContour we can create multi-contour shapes
	// 		this allows us to draw holes, for example... 
	//
	ofFill();
	ofSetHexColor(0xd3ffd3);
	ofRect(80,480,140,70);
	ofSetHexColor(0xff00ff);
	
	ofBeginShape();
	
	ofVertex(100,500);
	ofVertex(180,550);
	ofVertex(100,600);
	
	ofNextContour(true);
	
	ofVertex(120,520);
	ofVertex(160,550);
	ofVertex(120,580);
	
	ofEndShape(true);
	//-------------------------------------
	
	
	//------(i)--------------------------------------
	// 
	// 		CSG / ofNextContour
	// 
	// 		with different winding rules, you can even use ofNextContour to 
	// 		perform constructive solid geometry 
	// 		
	// 		be careful, the clockwiseness or counter clockwisenss of your multiple
	// 		contours matters with these winding rules.
	//
	// 		for csg ideas, see : http://glprogramming.com/red/chapter11.html
	// 
	// 		info about the winding rules is here:
	//		http://glprogramming.com/red/images/Image128.gif
	// 
	ofNoFill();
	
	
	ofPushMatrix();
	
	ofSetPolyMode(OF_POLY_WINDING_ODD);
	
	ofBeginShape();
	
	ofVertex(300,500);
	ofVertex(380,550);
	ofVertex(300,600);
	
	ofNextContour(true);
	
	for (int i = 0; i < 20; i++){
		float anglef = ((float)i / 19.0f) * TWO_PI;
		float x = 340 + 30 * cos(anglef);
		float y = 550 + 30 * sin(anglef); 
		ofVertex(x,y);
		radius 	+= radiusAdder; 
	}
	
	
	ofEndShape(true);
	
	ofTranslate(100,0,0);
	
	ofSetPolyMode(OF_POLY_WINDING_NONZERO);	
	ofBeginShape();
	
	ofVertex(300,500);
	ofVertex(380,550);
	ofVertex(300,600);
	
	ofNextContour(true);
	
	for (int i = 0; i < 20; i++){
		float anglef = ((float)i / 19.0f) * TWO_PI;
		float x = 340 + 30 * cos(anglef);
		float y = 550 + 30 * sin(anglef); 
		ofVertex(x,y);
		radius 	+= radiusAdder; 
	}
	
	ofEndShape(true);
	
	ofTranslate(100,0,0);
	ofSetPolyMode(OF_POLY_WINDING_ABS_GEQ_TWO);
	ofBeginShape();
	ofVertex(300,500);
	ofVertex(380,550);
	ofVertex(300,600);
	ofNextContour(true);
	
	for (int i = 0; i < 20; i++){
		float anglef = ((float)i / 19.0f) * TWO_PI;
		float x = 340 + 30 * cos(anglef);
		float y = 550 + 30 * sin(anglef); 
		ofVertex(x,y);
		radius 	+= radiusAdder; 
	}
	
	
	ofEndShape(true);
	
	ofPopMatrix();
	//-------------------------------------
	
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwxyz\n0123456789,:&!?", 20,300);	
	
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(a) star\nwinding rule odd", 20,210);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(b) star\nwinding rule nonzero", 220,210);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(c) dynamically\ncreated shape", 420,210);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(d) random points\npoly", 670,210);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(e) fun with sin/cos", 20,410);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(f) ofCurveVertex\nuses catmull rom\nto make curved shapes", 220,410);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(g) ofBezierVertex\nuses bezier to draw curves", 460,410);
	
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(h) ofNextContour\nallows for holes", 20,610);
	
	ofSetHexColor(0x000000);
	ofDrawBitmapString("(i) ofNextContour\ncan even be used for CSG operations\nsuch as union and intersection", 260,620);	
	
}

#ifdef OPENGLES_VERSION_2

//--------------------------------------------------------------
void testApp::debugDraw()
{
	ofGetGLES2Context()->glMatrixMode(GL_PROJECTION);
    
	ofGetGLES2Context()->glLoadIdentity();
	ofGetGLES2Context()->glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
	
	ofGetGLES2Context()->glMatrixMode(GL_MODELVIEW);
    
    // Enable lighting
	ofGetGLES2Context()->glEnable(GL_LIGHTING);
	
    // Turn the first light on
	ofGetGLES2Context()->glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.4, 0.4, 0.4, 1.0}};
    ofGetGLES2Context()->glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{1.0, 1.0, 1.0, 1.0}};
    ofGetGLES2Context()->glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const Color3D light0Specular[] = {{0.7, 0.7, 0.7, 1.0}};
    ofGetGLES2Context()->glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
	
	// 	float radius = 100.f; 
	//	float tmpX =  cos(counter*.006f) * radius * 2; 
	//	float tmpY =  sin(counter*.008f) * radius * 2; 
	//	float tmpZ = -cos(counter*.008f) * radius * 2; 
	
    // Define the position of the first light
	// const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    static const Vertex3D light0Position[] = {{0.0, 0.0, 10.0}};
	//   Vertex3D light0Position[] = {{tmpX, tmpY, tmpZ}};	
	

    ofGetGLES2Context()->glLoadIdentity();
	
	
    ofGetGLES2Context()->glEnable( GL_DEPTH_TEST );
	
    ofGetGLES2Context()->glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position);
	
    ofGetGLES2Context()->glRotatef(counter, 0.0f, 0.0f, 1.0f);
    ofGetGLES2Context()->glRotatef(counter / 1.4f, 0.0f, 1.0f, 0.0f);
	
	
	drawIcosahedron( 1.0f );
	
	ofGetGLES2Context()->glDisable(GL_LIGHTING);
}


//--------------------------------------------------------------
void testApp::drawCube( float _scale )
{
	
	static const float _vertices[] =
	{
		// front
		-0.5f, 0.5f, 0.5f, -0.5f, -0.5f, 0.5f, 0.5f, 0.5f, 0.5f,
		0.5f, 0.5f, 0.5f, -0.5f, -0.5f, 0.5f, 0.5f, -0.5f, 0.5f,
		
		// right
		0.5f, 0.5f, 0.5f, 0.5f, -0.5f, 0.5f, 0.5f, 0.5f, -0.5f,
		0.5f, 0.5f, -0.5f, 0.5f, -0.5f, 0.5f, 0.5f, -0.5f, -0.5f,
		
		// back
		0.5f, 0.5f, -0.5f, 0.5f, -0.5f, -0.5f, -0.5f, 0.5f, -0.5f,
		-0.5f, 0.5f, -0.5f, 0.5f, -0.5f, -0.5f, -0.5f, -0.5f, -0.5f,
		
		// left
		-0.5f, 0.5f, -0.5f, -0.5f, -0.5f, -0.5f, -0.5f, 0.5f, 0.5f,
		-0.5f, 0.5f, 0.5f, -0.5f, -0.5f, -0.5f, -0.5f, -0.5f, 0.5f,
		
		// top
		-0.5f, 0.5f, -0.5f, -0.5f, 0.5f, 0.5f, 0.5f, 0.5f, -0.5f,
		0.5f, 0.5f, -0.5f, -0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f,
		
		// bottom
		-0.5f, -0.5f, 0.5f, -0.5f, -0.5f, -0.5f, 0.5f, -0.5f, 0.5f,
		0.5f, -0.5f, 0.5f, -0.5f, -0.5f, -0.5f, 0.5f, -0.5f, -0.5f
	};

	static const float _normals[] =
	{
		0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1,
		 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
		 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1,
		-1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0,
		 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,
		 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0
	};

	static const float _colors[] =
	{
		1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
		1,0,0,1, 1,0,0,1, 1,0,0,1, 1,0,0,1, 1,0,0,1, 1,0,0,1,
		0,1,0,1, 0,1,0,1, 0,1,0,1, 0,1,0,1, 0,1,0,1, 0,1,0,1,
		0,0,1,1, 0,0,1,1, 0,0,1,1, 0,0,1,1, 0,0,1,1, 0,0,1,1,
		1,1,0,1, 1,1,0,1, 1,1,0,1, 1,1,0,1, 1,1,0,1, 1,1,0,1,
		1,0,1,1, 1,0,1,1, 1,0,1,1, 1,0,1,1, 1,0,1,1, 1,0,1,1
	};
	
	int _vertexCount = 36;
	
	ofGetGLES2Context()->glPushMatrix();
	
	ofGetGLES2Context()->glScalef( _scale, _scale , _scale );
		
	ofGetGLES2Context()->glEnableClientState(GL_VERTEX_ARRAY);
	ofGetGLES2Context()->glEnableClientState(GL_NORMAL_ARRAY);
	ofGetGLES2Context()->glEnableClientState(GL_COLOR_ARRAY);
		
	ofGetGLES2Context()->glVertexPointer(3, GL_FLOAT, 0, _vertices);
	ofGetGLES2Context()->glNormalPointer(GL_FLOAT, 0, _normals);
	ofGetGLES2Context()->glColorPointer(4, GL_FLOAT, 0, _colors);
	ofGetGLES2Context()->glDrawArrays(GL_TRIANGLES, 0, _vertexCount);

	ofGetGLES2Context()->glDisableClientState(GL_VERTEX_ARRAY);
	ofGetGLES2Context()->glDisableClientState(GL_NORMAL_ARRAY);
	ofGetGLES2Context()->glDisableClientState(GL_COLOR_ARRAY);
		
	ofGetGLES2Context()->glPopMatrix();
	
}

//--------------------------------------------------------------
void testApp::drawIcosahedron( float _scale )
{
	
	// This is the same result as using Vertex3D, just faster to type and
    // can be made const this way
    static const Vertex3D vertices[]= {
        {0, -0.525731, 0.850651},             // vertices[0]
        {0.850651, 0, 0.525731},              // vertices[1]
        {0.850651, 0, -0.525731},             // vertices[2]
        {-0.850651, 0, -0.525731},            // vertices[3]
        {-0.850651, 0, 0.525731},             // vertices[4]
        {-0.525731, 0.850651, 0},             // vertices[5]
        {0.525731, 0.850651, 0},              // vertices[6]
        {0.525731, -0.850651, 0},             // vertices[7]
        {-0.525731, -0.850651, 0},            // vertices[8]
        {0, -0.525731, -0.850651},            // vertices[9]
        {0, 0.525731, -0.850651},             // vertices[10]
        {0, 0.525731, 0.850651}               // vertices[11]
    };
    
    static const Color3D colors[] = {
        {1.0, 0.0, 0.0, 1.0},
        {1.0, 0.5, 0.0, 1.0},
        {1.0, 1.0, 0.0, 1.0},
        {0.5, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.5, 1.0},
        {0.0, 1.0, 1.0, 1.0},
        {0.0, 0.5, 1.0, 1.0},
        {0.0, 0.0, 1.0, 1.0},
        {0.5, 0.0, 1.0, 1.0},
        {1.0, 0.0, 1.0, 1.0},
        {1.0, 0.0, 0.5, 1.0}
    };
    
    static const GLubyte icosahedronFaces[] = {
        1, 2, 6,
        1, 7, 2,
        3, 4, 5,
        4, 3, 8,
        6, 5, 11,
        5, 6, 10,
        9, 10, 2,
        10, 9, 3,
        7, 8, 9,
        8, 7, 0,
        11, 0, 1,
        0, 11, 4,
        6, 2, 10,
        1, 6, 11,
        3, 5, 10,
        5, 4, 11,
        2, 7, 9,
        7, 1, 0,
        3, 9, 8,
        4, 8, 0,
    };
    
    static const Vector3D normals[] = {
        {0.000000, -0.417775, 0.675974},
        {0.675973, 0.000000, 0.417775},
        {0.675973, -0.000000, -0.417775},
        {-0.675973, 0.000000, -0.417775},
        {-0.675973, -0.000000, 0.417775},
        {-0.417775, 0.675974, 0.000000},
        {0.417775, 0.675973, -0.000000},
        {0.417775, -0.675974, 0.000000},
        {-0.417775, -0.675974, 0.000000},
        {0.000000, -0.417775, -0.675973},
        {0.000000, 0.417775, -0.675974},
        {0.000000, 0.417775, 0.675973},
    };	

	ofGetGLES2Context()->glPushMatrix();

		ofGetGLES2Context()->glScalef( _scale, _scale , _scale );
		
		ofGetGLES2Context()->glEnableClientState(GL_VERTEX_ARRAY);
		ofGetGLES2Context()->glEnableClientState(GL_COLOR_ARRAY);
		ofGetGLES2Context()->glEnableClientState(GL_NORMAL_ARRAY);
		
		ofGetGLES2Context()->glVertexPointer(3, GL_FLOAT, 0, vertices);
		ofGetGLES2Context()->glColorPointer(4, GL_FLOAT, 0, colors);
		ofGetGLES2Context()->glNormalPointer(GL_FLOAT, 0, normals);
		
		ofGetGLES2Context()->glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
		
		ofGetGLES2Context()->glDisableClientState(GL_VERTEX_ARRAY);
		ofGetGLES2Context()->glDisableClientState(GL_COLOR_ARRAY);
		ofGetGLES2Context()->glDisableClientState(GL_NORMAL_ARRAY);
	
	ofGetGLES2Context()->glPopMatrix();
}

#endif 


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

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	
	
	ofLogNotice() << "touchDown id: " << touch.id;
	
	if( touch.id == 0 ){
		for (int i = 0; i < nCurveVertexes; i++){
			float diffx = touch.x/appIphoneScale - curveVertices[i].x;
			float diffy = touch.y/appIphoneScale - curveVertices[i].y;
			float dist = sqrt(diffx*diffx + diffy*diffy);
			if (dist < 45 ){
				curveVertices[i].bBeingDragged = true;
			} else {
				curveVertices[i].bBeingDragged = false;
			}	
		}
	}
}


//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	if( touch.id == 0 ){
		for (int i = 0; i < nCurveVertexes; i++){
			if (curveVertices[i].bBeingDragged == true){
				curveVertices[i].x = touch.x/appIphoneScale;
				curveVertices[i].y = touch.y/appIphoneScale;
			}
		}
	}
}


//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	if( touch.id == 0 ){
		for (int i = 0; i < nCurveVertexes; i++){
			curveVertices[i].bBeingDragged = false;	
		}
	}
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	
	ofSetSphereResolution( ofRandom(2,40), ofRandom(2,40) );
	
	ofSetTorusResolution( ofRandom(2,40), ofRandom(2,40) );
	
	ofSetConeResolution( ofRandom(2,40), ofRandom(2,40) );
	
	ofSetCylinderResolution( ofRandom(2,40), ofRandom(2,40) );
	
	ofSetCapsuleResolution( ofRandom(2,40), ofRandom(2,40), ofRandom(2,40) );
	
}


