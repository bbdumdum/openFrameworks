//
//  AiOSGestureRecognizer.m
//  TimeVideo_iOS
//
//  Created by Andreas Müller on 13/05/2011.
//  Copyright 2011 Nanika. All rights reserved.
//

#import "AiOSGestureRecognizer.h"


@implementation AiOSGestureRecognizer


// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
		
		//myInt = 9;
		
		doPan		= true;
		doTap		= true;
		doPinch		= true;
		doRotation	= true;
		doSwipe		= true;
		
		
    }
    
    return self;
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)dealloc
{
    [super dealloc];
}




// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)addGestureRecognizers: (UIView*) _view 
{
	myView = _view;
	
	if( doTap )
	{
		UITapGestureRecognizer *singleFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleDoubleTap:)];
		singleFingerDoubleTap.numberOfTapsRequired = 2;
		[singleFingerDoubleTap setDelegate:self];
		[myView addGestureRecognizer:singleFingerDoubleTap];
		
		
		UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		singleFingerTap.numberOfTapsRequired = 1;
		[singleFingerTap requireGestureRecognizerToFail: singleFingerDoubleTap];	
		[singleFingerTap setDelegate:self];
		[myView addGestureRecognizer:singleFingerTap];
		
		[singleFingerTap release];		
		[singleFingerDoubleTap release];			
	}
		
	if( doPinch )
	{
		UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
		[pinchRecognizer setDelegate:self];
		[myView addGestureRecognizer:pinchRecognizer];
		
		[pinchRecognizer release];		
	}
		
	if( doRotation )
	{
		UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
		[rotationRecognizer setDelegate:self];
		[myView addGestureRecognizer:rotationRecognizer];
		
		[rotationRecognizer release];		
	}
		
	if( doPan )
	{
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		[panRecognizer setMinimumNumberOfTouches:1];
		[panRecognizer setMaximumNumberOfTouches:2];
		[panRecognizer setDelegate:self];
		[myView addGestureRecognizer:panRecognizer];	
		
		[panRecognizer release];		
	}
		
	if( doSwipe )
	{
		UISwipeGestureRecognizer *recognizer;
		
		recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
		[myView addGestureRecognizer:recognizer];
		[recognizer release];
		
		recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
		[myView addGestureRecognizer:recognizer];
		[recognizer release];
		
		recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
		[myView addGestureRecognizer:recognizer];
		[recognizer release];
		
		recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
		[myView addGestureRecognizer:recognizer];
		[recognizer release];	
	}
	 
}




// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	//cout << "AiOSGestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer" << endl;
	
    return YES;	
}


// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handleSingleDoubleTap:(UIGestureRecognizer *)sender 
{	
	cout << "AiOSGestureRecognizer We got a double tap!" << endl;
	
	CGPoint pos = [sender locationInView:sender.view];		
	
	touchArgs.pos[0].x = pos.x;
	touchArgs.pos[0].y = pos.y; 
	touchArgs.numTaps = 2;
	touchArgs.state = TouchEventArgs::TOUCH_STARTED;
	
	ofNotifyEvent( newTapEvent, touchArgs );	
	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handleSingleTap:(UIGestureRecognizer *)sender 
{	
	CGPoint pos = [sender locationInView:sender.view];	
	
	//cout << "AiOSGestureRecognizer We got a single tap!  pos " << pos.x << "," << pos.y<< endl;
	touchArgs.numTouches = 1;
	touchArgs.pos[0].x = pos.x;
	touchArgs.pos[0].y = pos.y; 
	touchArgs.numTaps = 1;
	touchArgs.state = TouchEventArgs::TOUCH_STARTED;
	
	ofNotifyEvent( newTapEvent, touchArgs );	
	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handlePinch:(UIGestureRecognizer *)sender 
{
	UIView *_view = sender.view;
	static CGRect initialBounds;	
	
	UIPinchGestureRecognizer *pinchZoomGesture = (UIPinchGestureRecognizer *) sender;
		
	switch( pinchZoomGesture.state )
	{
		case UIGestureRecognizerStateChanged:
			
			//cout << "handlePinch UIGestureRecognizerStateChanged " << endl;
			touchArgs.state = TouchEventArgs::TOUCH_CHANGED;		
			
			break;
			
		case UIGestureRecognizerStateBegan:
			
			//cout << "AiOSGestureRecognizer handlePinch UIGestureRecognizerStateBegan " << endl;
			
			touchArgs.state = TouchEventArgs::TOUCH_STARTED;	
			
			break;
			
		case UIGestureRecognizerStateEnded:
			
			//cout << "AiOSGestureRecognizer handlePinch UIGestureRecognizerStateEnded " << endl;			
			
			touchArgs.state = TouchEventArgs::TOUCH_ENDED;	
			
			break;
			
		default:
			// Something else happened. Do any cleanup you need to.
			break;
	}
	
	
	if (sender.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = _view.bounds;
    }
    CGFloat scale 	 = [pinchZoomGesture scale];
    CGFloat velocity = [pinchZoomGesture velocity];	
	
	touchArgs.scale = scale;
	
	touchArgs.numTouches = [pinchZoomGesture numberOfTouches];
	
	//cout << "handlePinch  numberOfTouches: " << touchAmount << endl; 
	for( int i = 0; i < touchArgs.numTouches; i++ )
	{
		CGPoint pos = [ pinchZoomGesture locationOfTouch:i inView:myView ];	
		touchArgs.pos[i].x = pos.x;
		touchArgs.pos[i].y = pos.y;	
	}

	ofNotifyEvent( newPinchEvent, touchArgs );		
	
	//cout << "AiOSGestureRecognizer We got a pinch! Scale: " << scale << "  Velocity: " <<  velocity << endl;
	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handleRotate:(UIGestureRecognizer *)sender 
{
	//cout << "AiOSGestureRecognizer We got a rotation!" << endl;

	UIRotationGestureRecognizer *rotationGesture = (UIRotationGestureRecognizer *) sender;
	
	CGFloat rotation = [rotationGesture rotation];
    CGFloat velocity = [rotationGesture velocity];	
	
	touchArgs.angle = rotation;
	//touchArgs.vel = velocity;	
	ofNotifyEvent( newRotationEvent, touchArgs );		
	
	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handlePan:(UIGestureRecognizer *)sender 
{
	
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) sender;
	
	switch( panGesture.state )
	{
		case UIGestureRecognizerStateChanged:

			touchArgs.state = TouchEventArgs::TOUCH_CHANGED;			
			break;
			
		case UIGestureRecognizerStateBegan:
			
			touchArgs.state = TouchEventArgs::TOUCH_STARTED;				
			break;
			
		case UIGestureRecognizerStateEnded:
			
			touchArgs.state = TouchEventArgs::TOUCH_ENDED;	
			break;
			
		default:
			break;
	}
	

	CGPoint translation = [ (UIPanGestureRecognizer *)sender translationInView:myView ];
	CGPoint pos = [ (UIPanGestureRecognizer *)sender locationInView:myView ];	
	CGPoint vel = [ (UIPanGestureRecognizer *)sender velocityInView:myView ];
	
	//cout << "AiOSGestureRecognizer We got a pan!  pos " << pos.x << "," << pos.y << "  vel " << vel.x << "," << vel.y << endl;	

	touchArgs.pos[0].x = pos.x;
	touchArgs.pos[0].y = pos.y; 

	touchArgs.translation[0].x = translation.x;
	touchArgs.translation[0].y = translation.y; 
	
	touchArgs.vel[0].x = vel.x;
	touchArgs.vel[0].y = vel.y; 	

	ofNotifyEvent( newPanEvent, touchArgs );	
		
}



// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)handleSwipe:(UIGestureRecognizer *)sender 
{
	
	//UISwipeGestureRecognizerDirection *swipeGesture = (UISwipeGestureRecognizerDirection *) sender;	
	
	UISwipeGestureRecognizerDirection dir = [(UISwipeGestureRecognizer *)sender direction];
	
	//cout << "AiOSGestureRecognizer We got a swipe! ";
	
	if( dir == UISwipeGestureRecognizerDirectionRight )
	{
		//cout << " To the right." << endl;
		touchArgs.swipeDirection = TouchEventArgs::SWIPE_RIGHT; 				
	}
	else if( dir == UISwipeGestureRecognizerDirectionLeft )
	{
		//cout << " To the left." << endl;
		touchArgs.swipeDirection = TouchEventArgs::SWIPE_LEFT; 		
	}
	else if( dir == UISwipeGestureRecognizerDirectionUp )
	{
		//cout << " To the up." << endl;		
		touchArgs.swipeDirection = TouchEventArgs::SWIPE_UP; 		
	}
	else if( dir == UISwipeGestureRecognizerDirectionDown )
	{
		//cout << " To the down." << endl;
		touchArgs.swipeDirection = TouchEventArgs::SWIPE_DOWN; 				
	}	
		
	ofNotifyEvent( newSwipeEvent, touchArgs );		

}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	cout << "touchesBegan" << endl;	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//	NSLog(@"touchesMoved: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	
	cout << "touchesMoved" << endl;	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//	NSLog(@"touchesEnded: %i %i %i", [touches count],  [[event touchesForView:self] count], multitouchData.numTouches);
	
	cout << "touchesEnded" << endl;	
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	cout << "touchesCancelled" << endl;
}








@end
