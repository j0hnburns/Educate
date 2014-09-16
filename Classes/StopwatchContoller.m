//
//  StopwatchContoller.m
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StopwatchContoller.h"
#import "CustomNavigationHeaderThin.h"


@implementation StopwatchContoller

@synthesize timeDisplayLabel;
@synthesize startButton;
@synthesize stopButton;
@synthesize resetButton;
@synthesize stopwatchDisplayUpdateThread;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Stopwatch";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
	[self.view addSubview:customNavHeader];
    [super viewDidLoad];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	UIImageView* timeBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stopwatch_timeBackground.png"]];	
	timeBackground.frame = CGRectMake(40,120,241,80);
	[self.view addSubview:timeBackground];
	[timeBackground release];	
	
	timeDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, 241, 60)];
	timeDisplayLabel.text = @"00:00:00";
	timeDisplayLabel.backgroundColor = [UIColor clearColor];
	timeDisplayLabel.textColor = [UIColor whiteColor];
	timeDisplayLabel.textAlignment = UITextAlignmentCenter;
	//timeDisplayLabel.font = [UIFont fontWithName:@"Courier" size:40];
	timeDisplayLabel.font = [UIFont boldSystemFontOfSize:40];
	timeDisplayLabel.shadowColor = [UIColor blackColor];
	timeDisplayLabel.shadowOffset = CGSizeMake(0,1);
	[self.view addSubview:timeDisplayLabel];
	[timeDisplayLabel release];
	
	startButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	startButton.frame = CGRectMake(40, 200, 122, 46);
	[startButton setTitle:@"" forState:UIControlStateNormal];
	[startButton setBackgroundColor:[UIColor clearColor]];
	[startButton setImage:[UIImage imageNamed:@"stopwatch_startButton.png"] forState:UIControlStateNormal];
	[startButton addTarget:self action:@selector(startStopwatch) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:startButton];
	
	
	stopButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	stopButton.frame = CGRectMake(159, 200, 122, 46);
	[stopButton setTitle:@"" forState:UIControlStateNormal];
	[stopButton setBackgroundColor:[UIColor clearColor]];
	[stopButton setImage:[UIImage imageNamed:@"stopwatch_stopButton.png"] forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stopStopwatch) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopButton];
	
	
	resetButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	resetButton.frame = CGRectMake(112, 260, 102, 44);
	[resetButton setTitle:@"" forState:UIControlStateNormal];
	[resetButton setBackgroundColor:[UIColor clearColor]];
	[resetButton setImage:[UIImage imageNamed:@"stopwatch_resetButton.png"] forState:UIControlStateNormal];
	[resetButton addTarget:self action:@selector(resetStopwatch) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:resetButton];
	
	isCounting = NO;
	[self startStopwatchDisplayUpdateThread];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)callPopBackToPreviousView {
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)startStopwatch {
	//if (isCounting) {
		// pause stopwatch - stop counter and save elapsed time at this point
		//elapsedTime = stopInterval - startInterval;
		//isCounting = NO;
	//}
	//else {	
		
		startInterval = [NSDate timeIntervalSinceReferenceDate]-elapsedTime;
		isCounting = YES;
	//}
}

- (void)stopStopwatch {
	if (isCounting) {
		stopInterval = [NSDate timeIntervalSinceReferenceDate];
		elapsedTime = stopInterval - startInterval;
		if (elapsedTime < 10000000) {
			[self setStopwatchTimerDisplayFromTimeInterval];
		}
		isCounting = NO;
	}
}

- (void)resetStopwatch {
	timeDisplayLabel.text = @"00:00:00";
	startInterval = [NSDate timeIntervalSinceReferenceDate];
	elapsedTime = 0;
}


- (void)startStopwatchDisplayUpdateThread {
    if (stopwatchDisplayUpdateThread != nil) {
        [stopwatchDisplayUpdateThread cancel];
        [self waitForStopwatchDisplayUpdateThreadToFinish];
    }
    
    NSThread *tempThread = [[NSThread alloc] initWithTarget:self selector:@selector(startStopwatchDisplayUpdateThreadTimer:) object:nil];
	self.stopwatchDisplayUpdateThread = tempThread;
    [tempThread release];
    
    [self.stopwatchDisplayUpdateThread start];
}

- (void)waitForStopwatchDisplayUpdateThreadToFinish {
    while (stopwatchDisplayUpdateThread && ![stopwatchDisplayUpdateThread isFinished]) { // wait for the thread to finish
        [NSThread sleepForTimeInterval:0.1];
    }
}

- (void)stopStopwatchDisplayUpdateThread {
    [self.stopwatchDisplayUpdateThread cancel];
    [self waitForStopwatchDisplayUpdateThreadToFinish];
    self.stopwatchDisplayUpdateThread = nil;
}

- (void)startStopwatchDisplayUpdateThreadTimer:(id)info {
	
	
    NSAutoreleasePool *nearbyUsersUpdatePool = [[NSAutoreleasePool alloc] init];
    
    // Give the thread high priority to keep the timing steady
    [NSThread setThreadPriority:1.0];
    BOOL continuePlaying = YES;
    
    while (continuePlaying) {  // loop until cancelled
        // Use an autorelease pool to prevent the build-up of temporary date objects
        NSAutoreleasePool *nearbyUsersUpdateLoopPool = [[NSAutoreleasePool alloc] init]; 
        
        
        // wake up periodically to see if we've been cancelled
        while (continuePlaying) { 
            if ([stopwatchDisplayUpdateThread isCancelled] == YES) {
                continuePlaying = NO;
            }
			
			if (isCounting) {
				stopInterval = [NSDate timeIntervalSinceReferenceDate];
				elapsedTime = stopInterval - startInterval;
				[self performSelectorOnMainThread:@selector(setStopwatchTimerDisplayFromTimeInterval) withObject:nil waitUntilDone:NO];
				[NSThread sleepForTimeInterval:1];
			} else {
				[NSThread sleepForTimeInterval:0.1];
			}
		
			
			
        }
        [nearbyUsersUpdateLoopPool release];
    }
    [nearbyUsersUpdatePool release];
}

- (void)setStopwatchTimerDisplayFromTimeInterval {
	int hours = 0;
	int minutes = 0;
	int seconds = 0;
	
	hours = elapsedTime/3600;
	minutes = ((elapsedTime)-(hours*60))/60;
	seconds = (elapsedTime)-(minutes*60)-(hours*3600);
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSMutableString* hoursString = [NSMutableString stringWithString:[numberFormatter stringFromNumber:[NSNumber numberWithInt:hours]]];
	if ([hoursString length] == 1) {
		[hoursString insertString:@"0" atIndex:0];
	}
	
	NSMutableString* minutesString = [NSMutableString stringWithString:[numberFormatter stringFromNumber:[NSNumber numberWithInt:minutes]]];
	if ([minutesString length] == 1) {
		[minutesString insertString:@"0" atIndex:0];
	}
	
	NSMutableString* secondsString = [NSMutableString stringWithString:[numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]]];
	if ([secondsString length] == 1) {
		[secondsString insertString:@"0" atIndex:0];
	}
	
	timeDisplayLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hoursString,minutesString,secondsString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[self stopStopwatchDisplayUpdateThread];
	[timeDisplayLabel release];
	[startButton release];
	[stopButton release];
	[resetButton release];
	[stopwatchDisplayUpdateThread release];
    [super dealloc];
}


@end
