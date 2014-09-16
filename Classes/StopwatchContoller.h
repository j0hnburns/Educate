//
//  StopwatchContoller.h
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StopwatchContoller : UIViewController {

	UILabel *timeDisplayLabel;
	UIButton *startButton;
	UIButton *stopButton;
	UIButton *resetButton;
	
	BOOL isCounting;
	
	NSTimeInterval startInterval;
	NSTimeInterval stopInterval;
	NSTimeInterval elapsedTime;
	
	
	NSThread *stopwatchDisplayUpdateThread;
	
}

- (void)callPopBackToPreviousView;
- (void)startStopwatch;
- (void)stopStopwatch;
- (void)resetStopwatch;

- (void)startStopwatchDisplayUpdateThread;
- (void)waitForStopwatchDisplayUpdateThreadToFinish;
- (void)stopStopwatchDisplayUpdateThread;
- (void)startStopwatchDisplayUpdateThreadTimer:(id)info;
- (void)setStopwatchTimerDisplayFromTimeInterval;

@property (nonatomic, retain) UILabel *timeDisplayLabel;
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) UIButton *stopButton;
@property (nonatomic, retain) UIButton *resetButton;
@property (nonatomic, retain) NSThread *stopwatchDisplayUpdateThread;

@end
