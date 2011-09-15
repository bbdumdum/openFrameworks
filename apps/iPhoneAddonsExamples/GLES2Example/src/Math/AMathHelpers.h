/*
 *  AMathHelpers.h
 *  HyundaiLightRevealControlSoftware
 *
 *  Created by Andreas Müller on 03/02/2011.
 *  Copyright 2011 Nanika. All rights reserved.
 *
 */

#pragma once


#include "ofMain.h"

class AMathHelpers 
{
public:
	
	static float cosCurve( float _valueIn, float _maxValue )
	{
		float tmpVal = _valueIn / _maxValue;
		tmpVal = cosf( tmpVal * (PI*2.0f) );
		tmpVal += 1.0f;
		tmpVal /= 2.0f;
		
		return tmpVal;
	}
	
	static float sinCurve( float _valueIn, float _maxValue )
	{
		float tmpVal = _valueIn / _maxValue;
		tmpVal = cosf( tmpVal * (PI*2.0f) );
		tmpVal += 1.0f;
		tmpVal /= 2.0f;
		
		return tmpVal;
	}	
	
	static float cosZeroToOne( float _angleRad )
	{
		float tmpVal = (cosf( _angleRad ) + 1.0f) * 0.5f;
		return tmpVal;
	}		
	
	static float sinZeroToOne( float _angleRad )
	{
		float tmpVal = (sinf( _angleRad ) + 1.0f) * 0.5f;
		return tmpVal;
	}			
		
private:
	
};
