//
//  AiOSGestureRecognizer.h
//  TimeVideo_iOS
//
//  Created by Andreas Müller on 13/05/2011.
//  Copyright 2011 Nanika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#include <time.h>
#include <stdlib.h>

#import "ofMain.h"
#import "ofEvents.h"

#define MAX_TOUCHES 5

//-------------------------------------------------------------------------------------------------------------------------------------
//
class __xy 
{
	public:
		__xy(){ x = 0.0f, y = 0.0f; }
		float x, y;	
};

//-------------------------------------------------------------------------------------------------------------------------------------
//
class TouchEventArgs : public ofEventArgs 
{
	
public:
	
	TouchEventArgs()
	{
		numTouches = 0;
		myId = 0;
	
		age = 0.0f;
		scale = 0.0f;
		angle = 0.0f;
		numTaps = 0;
	}
	
	int myId;
	
	//float x,y; 							// position of the touch
	//float velx,vely; 					// velocity of the touch
	//float translationx, translationy; 	// how much it has moved since it began
	
	__xy pos[ MAX_TOUCHES ];
	__xy vel[ MAX_TOUCHES ];
	__xy translation[ MAX_TOUCHES ];	
	
	float angle;						// angle change in radians
	float scale;
	
	enum TouchState { TOUCH_STARTED, TOUCH_CHANGED, TOUCH_ENDED };
	TouchState state;
	
	enum SwipeDirection { SWIPE_LEFT, SWIPE_RIGHT, SWIPE_UP, SWIPE_DOWN };
	SwipeDirection swipeDirection;

	int numTouches;
	int numTaps;
	
	float age;
};


// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
@interface AiOSGestureRecognizer : NSObject <UIGestureRecognizerDelegate> {

@public
	
    //int myInt;
	ofEvent<int> newIntEvent;

	ofEvent<TouchEventArgs> newPanEvent;
	ofEvent<TouchEventArgs> newTapEvent;	
	ofEvent<TouchEventArgs> newPinchEvent;	
	ofEvent<TouchEventArgs> newRotationEvent;		
	ofEvent<TouchEventArgs> newSwipeEvent;		
	
	TouchEventArgs touchArgs;
	
	UIView* myView;
	
	bool doPan;
	bool doTap;
	bool doPinch;
	bool doRotation;
	bool doSwipe;
	
}

- (void) addGestureRecognizers:(UIView*) _view;

- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender;
- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender;
- (IBAction)handlePinch:(UIGestureRecognizer *)sender;
- (IBAction)handleRotate:(UIGestureRecognizer *)sender;
- (IBAction)handlePan:(UIGestureRecognizer *)sender;
- (IBAction)handleSwipe:(UIGestureRecognizer *)sender;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event; 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event; 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event; 


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;




@end
