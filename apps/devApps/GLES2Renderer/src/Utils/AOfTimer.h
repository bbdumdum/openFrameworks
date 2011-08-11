
#pragma once

#include "ofMain.h"

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
class AOfTimer
{

public:

	AOfTimer()
	{
		startTime = 0.0f;
		start();
	}

	~AOfTimer() 
	{
	}

	void start()
	{
		startTime = ofGetElapsedTimef();
	}

	float elapsedSec()
	{
		return ofGetElapsedTimef() - startTime;
	}

	float startTime;

private:

};
