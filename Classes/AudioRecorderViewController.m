//
//  AudioRecorderViewController.m
//  Educate
//
//  Created by James Hodge on 20/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import "CustomNavigationHeaderThin.h"
void interruptionListenerCallback (
								   void	*inUserData,
								   UInt32	interruptionState
) {
	// This callback, being outside the implementation block, needs a reference 
	//	to the AudioViewController object. You provide this reference when
	//	initializing the audio session (see the call to AudioSessionInitialize).
	AudioRecorderViewController *controller = (AudioRecorderViewController *) inUserData;
	
	if (interruptionState == kAudioSessionBeginInterruption) {
		
		NSLog (@"Interrupted. Stopping playback or recording.");
		
		if (controller.audioRecorder) {
			// if currently recording, stop
			[controller startRecording];
		} else if (controller.audioPlayer) {
			// if currently playing, pause
			[controller pausePlayback];
			controller.interruptedOnPlayback = YES;
		}
		
	} else if ((interruptionState == kAudioSessionEndInterruption) && controller.interruptedOnPlayback) {
		// if the interruption was removed, and the app had been playing, resume playback
		[controller resumePlayback];
		controller.interruptedOnPlayback = NO;
	}
}


// Audio session callback function for responding to audio route changes. This 
//	callback behaves as follows when a headset gets plugged in or unplugged:
//
//	If playing back:	pauses playback and displays an alert that allows the user
//						to resume playback
//
//	If recording:		stops recording and displays an alert that notifies the
//						user that recording has stopped.

void audioRouteChangeListenerCallback (
									   void                      *inUserData,
									   AudioSessionPropertyID    inPropertyID,
									   UInt32                    inPropertyValueSize,
									   const void                *inPropertyValue
) {
	
	// ensure that this callback was invoked for the correct property change
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
	
	// This callback, being outside the implementation block, needs a reference 
	//	to the AudioViewController object. You provide this reference when
	//	registering this callback (see the call to AudioSessionAddPropertyListener).
	AudioRecorderViewController *controller = (AudioRecorderViewController *) inUserData;
	
	// A change in audio session category counts as an "audio route change." Because
	//	this sample sets the audio session category only when beginning playback 
	//	or recording, it should not pause or stop for that. To avoid inappropriate
	//	pausing or stopping, this callback queries the "reason" for the route change 
	//	and branches accordingly.
	CFDictionaryRef	routeChangeDictionary	= inPropertyValue;
	
	CFNumberRef		routeChangeReasonRef	=
	CFDictionaryGetValue (
						  routeChangeDictionary,
						  CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
						  );
	
	SInt32			routeChangeReason;
	
	CFNumberGetValue (
					  routeChangeReasonRef,
					  kCFNumberSInt32Type,
					  &routeChangeReason
					  );
	
	if (routeChangeReason != kAudioSessionRouteChangeReason_CategoryChange) {
		
		if (controller.audioRecorder) {
			
			NSLog (@"Recording audio route change.");
			
			[controller startRecording];
			
			UIAlertView *routeChangeAlertView;
			routeChangeAlertView = [[UIAlertView alloc]	initWithTitle:		@"Recording Stopped"
															  message:			@"Audio input was changed"
															 delegate:			nil
													cancelButtonTitle:	@"OK"
													otherButtonTitles:	nil];
			[routeChangeAlertView show];
			[routeChangeAlertView release];
			
		} else if (controller.audioPlayer) {
			
			CFStringRef newAudioRoute;
			UInt32 propertySize = sizeof (CFStringRef);
			
			AudioSessionGetProperty (
									 kAudioSessionProperty_AudioRoute,
									 &propertySize,
									 &newAudioRoute
									 );
			
			CFComparisonResult newDeviceIsSpeaker =	CFStringCompare (
																	 newAudioRoute,
																	 (CFStringRef) @"Speaker",
																	 0
																	 );
			
			if (newDeviceIsSpeaker == kCFCompareEqualTo) {
				
				[controller pausePlayback];
				NSLog (@"New audio route is %@.", newAudioRoute);
				
				UIAlertView *routeChangeAlertView;
				routeChangeAlertView = [[UIAlertView alloc]	initWithTitle:		@"Playback Paused"
																  message:			@"Audio output was changed"
																 delegate:			controller
														cancelButtonTitle:	@"Stop"
														otherButtonTitles:	@"Play", nil];
				[routeChangeAlertView show];
				// release takes place in alertView:clickedButtonAtIndex: method
				
			} else {
				
				NSLog (@"New audio route is %@.", newAudioRoute);
			}
			
		} else {
			
			NSLog (@"Audio route change while stopped.");
		}
		
	} else {
		
		NSLog (@"Audio category change.");
	}
}



@implementation AudioRecorderViewController

@synthesize controlButtonBackground;
@synthesize positionButtonBackground;
@synthesize positionSlider;
@synthesize stopButton;
@synthesize playButton;
@synthesize recordButton;
@synthesize fastForwardButton;
@synthesize rewindButton;
@synthesize recorderTableView;
@synthesize recordingsArray;

@synthesize audioPlayer;			// the playback audio queue object
@synthesize audioRecorder;			// the recording audio queue object
@synthesize soundFileURL;			// the sound file to record to and to play back
@synthesize recordingDirectory;		// the location to record into; it's the application's Documents directory
@synthesize audioLevels;			// an array of two floating point values that represents the current recording or playback audio level
@synthesize peakLevels;				// an array of two floating point values that represents the current recording or playback audio level
@synthesize statusSign;				// a UILabel object that says "Recording" or "Playback," or empty when stopped
@synthesize interruptedOnPlayback;	// this allows playback to resume when an interruption ends. this app does not resume a recording for the user.




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		// set the name of the default recording file from the recordingsArray.  If the array doesn't exist, create it first with a default recording.
		
		//create array
				
		NSMutableArray *tempMutableRecordingsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"recordingsArray"] mutableCopy];
		if (tempMutableRecordingsArray == nil)
		{
			// user has not launched this app before so set default arrays
			// array format: itemID, type, name, startTime, endTime
			
			// currently populated with dummy data for test purposes - remove and replace with blank array for final
			
			
			
			tempMutableRecordingsArray = [[NSMutableArray arrayWithObjects:
										  [[NSMutableArray arrayWithObjects: 
											@"0",
											@"01 March 2009 1600",
											nil] retain],
										  nil] retain];
			
			while ([tempMutableRecordingsArray count] > 0) {
				[tempMutableRecordingsArray removeLastObject];
			}
			
			
		}
		recordingsArray = tempMutableRecordingsArray;
		
		
		
		NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																	 
																	 NSDocumentDirectory, 
																	 NSUserDomainMask,
																	 YES
																	 ); 
		
		self.recordingDirectory = [filePaths objectAtIndex: 0];
		
		
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/nil.caf", self.recordingDirectory];
		if ([recordingsArray count] != 0) {
			fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:0] objectAtIndex:0]];
		}
		
		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
		
		// allocate memory to hold audio level values
		audioLevels = calloc (2, sizeof (AudioQueueLevelMeterState));
		peakLevels = calloc (2, sizeof (AudioQueueLevelMeterState));
		
		// initialize the audio session object for this application,
		//		registering the callback that Audio Session Services will invoke 
		//		when there's an interruption
		AudioSessionInitialize (
								NULL,
								NULL,
								interruptionListenerCallback,
								self
								);
		
		AudioSessionAddPropertyListener (
										 kAudioSessionProperty_AudioRouteChange,
										 audioRouteChangeListenerCallback,
										 self
										 );
		
		
		
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
		
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Audio Recorder";
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
	
	controlButtonBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ar_buttonBackground.png"]];	
	controlButtonBackground.frame = CGRectMake(0,365,320,47);
	[self.view addSubview:controlButtonBackground];
	
	stopButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	stopButton.frame = CGRectMake(0, 365, 51, 47);
	[stopButton setTitle:@"" forState:UIControlStateNormal];
	[stopButton setBackgroundColor:[UIColor clearColor]];
	[stopButton setImage:[UIImage imageNamed:@"ar_stopButton.png"] forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stopRecording) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopButton];
	
	playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	playButton.frame = CGRectMake(51, 365, 46, 47);
	[playButton setTitle:@"" forState:UIControlStateNormal];
	[playButton setBackgroundColor:[UIColor clearColor]];
	[playButton setImage:[UIImage imageNamed:@"ar_playButton.png"] forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(playRecording) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:playButton];
	
	recordButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	recordButton.frame = CGRectMake(97, 365, 50, 47);
	[recordButton setTitle:@"" forState:UIControlStateNormal];
	[recordButton setBackgroundColor:[UIColor clearColor]];
	[recordButton setImage:[UIImage imageNamed:@"ar_recordButton.png"] forState:UIControlStateNormal];
	[recordButton addTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:recordButton];
	
	rewindButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	rewindButton.frame = CGRectMake(219, 366, 53, 47);
	[rewindButton setTitle:@"" forState:UIControlStateNormal];
	[rewindButton setBackgroundColor:[UIColor clearColor]];
	[rewindButton setImage:[UIImage imageNamed:@"ar_rewindButton.png"] forState:UIControlStateNormal];
	[rewindButton addTarget:self action:@selector(previousRecording) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:rewindButton];
	
	fastForwardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	fastForwardButton.frame = CGRectMake(272, 366, 48, 47);
	[fastForwardButton setTitle:@"" forState:UIControlStateNormal];
	[fastForwardButton setBackgroundColor:[UIColor clearColor]];
	[fastForwardButton setImage:[UIImage imageNamed:@"ar_fastForwardButton.png"] forState:UIControlStateNormal];
	[fastForwardButton addTarget:self action:@selector(nextRecording) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:fastForwardButton];
	
	/*
	positionButtonBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ar_bottomBarBackground.png"]];	
	positionButtonBackground.frame = CGRectMake(0,365,320,48);
	[self.view addSubview:positionButtonBackground];
	
	positionSlider = [[UISlider alloc] initWithFrame:CGRectMake(60,365,200,48)];
	[positionSlider addTarget:self action:@selector(setRecordingToPositionFromSlider) forControlEvents:UIControlEventValueChanged];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	positionSlider.backgroundColor = [UIColor clearColor];
	
	positionSlider.minimumValue = 0.0;
	positionSlider.maximumValue = 100.0;
	positionSlider.continuous = YES;
	positionSlider.value = 0;
	positionSlider.hidden = YES;
	[self.view addSubview:positionSlider];
	 */
	
	statusSign = [[UITextField alloc] initWithFrame:CGRectMake(150, 375, 60, 30)];
	[self.view addSubview:statusSign];
	
	recorderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,320) style:UITableViewStyleGrouped];
	recorderTableView.delegate = self;
	recorderTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	recorderTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	recorderTableView.rowHeight = 40;
	recorderTableView.backgroundColor = [UIColor clearColor];
	recorderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:recorderTableView];
	
	
	NSFileManager * fileManager = [NSFileManager defaultManager];

	// on the very first launch of the application, there's no file to play,
	//	so gray out the Play button.
	NSString* fileTestString = [NSString stringWithFormat: @"%@/nil.caf", self.recordingDirectory];
	if ([recordingsArray count] != 0) {
		fileTestString = [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:0] objectAtIndex:0]];
		[recorderTableView reloadData];
		[recorderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	}
	
	if ([fileManager fileExistsAtPath:  fileTestString] != TRUE) {
		[self.playButton setEnabled: NO];
	} 

	[statusSign setFont: [UIFont fontWithName: @"Helvetica" size: 18.0]];
	
}





- (void)newRecording {
	
}

- (void)stopRecording {
	
	if ([statusSign.text isEqualToString:@"Playback"]) {
		[self playRecording];
	} else if ([statusSign.text isEqualToString:@"Recording"]) {
		[self startRecording];
	}
	
}

- (void)playRecording {
	NSLog (@"playOrStop:");
	
	// if not playing, start playing
	if (self.audioPlayer == nil) {
		
		// before instantiating the playback audio queue object, 
		//	set the audio session category
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,
								 sizeof (sessionCategory),
								 &sessionCategory
								 );
		
		AudioPlayer *thePlayer = [[AudioPlayer alloc] initWithURL: self.soundFileURL];
		
		if (thePlayer) {
			
			self.audioPlayer = thePlayer;
			[thePlayer release];								// decrements the retain count for the thePlayer object
			
			[self.audioPlayer setNotificationDelegate: self];	// sets up the playback object to receive property change notifications from the playback audio queue object
			
			// activate the audio session immmediately before playback starts
			AudioSessionSetActive (true);
			NSLog (@"sending play message to play object.");
			[self.audioPlayer play];
		}
		
		// else if playing, stop playing
	} else if (self.audioPlayer) {
		
		NSLog (@"User tapped Stop to stop playing.");
		[self.audioPlayer setAudioPlayerShouldStopImmediately: YES];
		
		NSLog (@"Calling AudioQueueStop from controller object.");
		[self.audioPlayer stop];
		
		// the previous statement returns after the audioPlayer object is completely
		// stopped, which also ensures that the underlying audio queue object is 
		// stopped, so now it's safe to release the audioPlayer object.
		[audioPlayer release];
		audioPlayer = nil;
		
		// now that playback has stopped, deactivate the audio session
		AudioSessionSetActive (false);
	}  
	
}

- (void)startRecording {
	NSLog (@"recordOrStop:");
	
		
	// if not recording, start recording
	if (self.audioRecorder == nil) {
		
		// setup navigation header and settings button
		NSDate *now = [NSDate date];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
		[dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
		//[dateFormatter release];
		//[now release];
		
		// first create a new file and add the entry into the array
		[recordingsArray addObject: [[NSMutableArray arrayWithObjects: 
									  [NSString stringWithFormat:@"%i",[recordingsArray count]],
									  [dateFormatter stringFromDate:now],
									  nil] retain]];
		
		[[NSUserDefaults standardUserDefaults] setObject:recordingsArray forKey:@"recordingsArray"];
		
		[recorderTableView reloadData];
		
		[recorderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[recordingsArray count]-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
		
		//code to move a recording into the active spot
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:[recordingsArray count]-1] objectAtIndex:0]];
		
		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
		playButton.enabled = YES;
		
		
		// before instantiating the recording audio queue object, 
		//	set the audio session category
		UInt32 sessionCategory = kAudioSessionCategory_RecordAudio;
		AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,
								 sizeof (sessionCategory),
								 &sessionCategory
								 );
		
		// the first step in recording is to instantiate a recording audio queue object
		AudioRecorder *theRecorder = [[AudioRecorder alloc] initWithURL: self.soundFileURL];
		
		// if the audio queue was successfully created, initiate recording.
		if (theRecorder) {
			
			self.audioRecorder = theRecorder;
			[theRecorder release];								// decrements the retain count for the theRecorder object
			
			[self.audioRecorder setNotificationDelegate: self];	// sets up the recorder object to receive property change notifications 
			//	from the recording audio queue object
			
			// activate the audio session immediately before recording starts
			AudioSessionSetActive (true);
			
			NSLog (@"sending record message to recorder object.");
			[self.audioRecorder record];						// starts the recording audio queue object
		}
		
		// else if recording, stop recording
	} else if (self.audioRecorder) {
		
		[self.audioRecorder setStopping: YES];				// this flag lets the property listener callback
		//	know that the user has tapped Stop
		NSLog (@"sending stop message to recorder object.");
		[self.audioRecorder stop];							// stops the recording audio queue object. the object 
		//	remains in existence until it actually stops, at
		//	which point the property listener callback calls
		//	this class's updateUserInterfaceOnAudioQueueStateChange:
		//	method, which releases the recording object.
		// now that recording has stopped, deactivate the audio session
		AudioSessionSetActive (false);
	}
}

- (void)previousRecording {
	
	if ([recordingsArray count] > 1) {
	
		int currentRecordingNumber = [[recorderTableView indexPathForSelectedRow] row];
	
		currentRecordingNumber -=1;
		
		if (currentRecordingNumber < 0) {
			currentRecordingNumber = [recordingsArray count]-1;
		}
		
		[recorderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRecordingNumber inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
		
		//code to move a recording into the active spot
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:currentRecordingNumber] objectAtIndex:0]];
		
		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
	}
		
	
}

- (void)nextRecording {
	if ([recordingsArray count] > 1) {
		
		int currentRecordingNumber = [[recorderTableView indexPathForSelectedRow] row];
		
		currentRecordingNumber +=1;
		
		if (currentRecordingNumber >= [recordingsArray count]) {
			currentRecordingNumber = 0;
		}
		
		[recorderTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentRecordingNumber inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
		
		//code to move a recording into the active spot
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:currentRecordingNumber] objectAtIndex:0]];
		
		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
	}
}

- (void)setRecordingToPositionFromSlider {
	
}

// this method gets called (by property listener callback functions) when a recording or playback 
// audio queue object starts or stops. 
- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue {
	
	NSAutoreleasePool *uiUpdatePool = [[NSAutoreleasePool alloc] init];
	
	NSLog (@"updateUserInterfaceOnAudioQueueStateChange just called.");
	
	// the audio queue (playback or record) just started
	if ([inQueue isRunning]) {
		
		
		// playback just started
		if (inQueue == self.audioPlayer) {
			
			NSLog (@"playback just started.");
			[self.recordButton setEnabled: NO];
			[self.statusSign setText: @"Playback"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0]];
			
			// recording just started
		} else if (inQueue == self.audioRecorder) {
			
			NSLog (@"recording just started.");
			[self.playButton setEnabled: NO];
			NSLog (@"setting Record button title to Stop.");
			[self.statusSign setText: @"Recording"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.67 green: 0.0 blue: 0.0 alpha: 1.0]];
		}
		// the audio queue (playback or record) just stopped
	} else {
		
		// playback just stopped
		if (inQueue == self.audioPlayer) {
			
			NSLog (@"playback just stopped.");
			[self.recordButton setEnabled: YES];
			
			// release the audioPlayer object if it stopped because the sound
			//	file finished playing. In this case, this class's playOrStop
			//	method, which otherwise releases the audioPlayer, doesn't get called.
			if (![self.audioPlayer audioPlayerShouldStopImmediately]) {
				[self.audioPlayer release];
				audioPlayer = nil;
			}
			// recording just stopped
		} else if (inQueue == self.audioRecorder) {
			
			NSLog (@"recording just stopped.");
			[self.playButton setEnabled: YES];
			NSLog (@"setting Record button title to Record.");
			
			[self.audioRecorder release];
			audioRecorder = nil;
		}
		
				
		[self.statusSign setText: @""];
	}
	
	[uiUpdatePool drain];
}




// pausing is invoked when removing a headset from the device, which is why 
// this isn't an IBAction method (that is, there's no explicit UI for 
// invoking this method)
- (void) pausePlayback {
	
	if (self.audioPlayer) {
		
		NSLog (@"Pausing playback on interruption.");
		[self.audioPlayer pause];
	}
}

// resuming playback is only every invoked if the user rejects an incoming call
//	or other interruption, which is why this isn't an IBAction method (that is, 
//	there's no explicit UI for invoking this method)
- (void) resumePlayback {
	
	NSLog (@"Resuming playback on end of interruption.");
	
	// before resuming playback, set the audio session
	// category and activate it
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	AudioSessionSetActive (true);
	
	[self.audioPlayer resume];
}

// delegate method for the audio route change alert view; follows the protocol specified
//	in the UIAlertViewDelegate protocol.
- (void) alertView: routeChangeAlertView clickedButtonAtIndex: buttonIndex {
	
	if ((NSInteger) buttonIndex == 1) {
		[self resumePlayback];
	} else {
		[self playRecording];
	}
	
	[routeChangeAlertView release];			
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void) didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	
	// the most likely reason for a memory warning is that the file being recorded is getting
	// too big -- so stop recording. This can be tested in the iPhone Simulator.
	if (self.audioRecorder) {
		[self startRecording];
	}
	
	UIAlertView *memoryWarningAlertView;
	memoryWarningAlertView = [[UIAlertView alloc]	initWithTitle:		@"Recording Stopped"
														message:			@"Not enough disk space to continue recording"
													   delegate:			nil
											  cancelButtonTitle:	@"OK"
											  otherButtonTitles:	nil];
	[memoryWarningAlertView show];
	[memoryWarningAlertView release];
}




#pragma mark Table view methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
	//return UITableViewCellAccessoryDisclosureIndicator;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// one section for content, next section for the 'new item' button
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
			
		return [recordingsArray count];
	//return 1;

	
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [[recordingsArray objectAtIndex:indexPath.row] objectAtIndex:1];
	
    return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];

	//code to move a recording into the active spot
	CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:indexPath.row] objectAtIndex:0]];
	
	// create the file URL that identifies the file that the recording audio queue object records into
	CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
													   NULL,
													   fileString,
													   kCFURLPOSIXPathStyle,
													   false
													   );
	NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
	
	// save the sound file URL as an object attribute (as an NSURL object)
	if (fileURL) {
		self.soundFileURL	= (NSURL *) fileURL;
		CFRelease (fileURL);
	}
	
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[recordingsArray removeObjectAtIndex:indexPath.row];
		// Now animate the deletion from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView selectRowAtIndexPath:0 animated:YES scrollPosition:UITableViewScrollPositionTop];
		
		//code to move a recording into the active spot
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/nil.caf", self.recordingDirectory];
		if ([recordingsArray count] != 0) {
			fileString = (CFStringRef) [NSString stringWithFormat: @"%@/%@.caf", self.recordingDirectory, [[recordingsArray objectAtIndex:0] objectAtIndex:0]];
		} else {
			
			playButton.enabled = NO;
		}
		
		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
		
		
		[[NSUserDefaults standardUserDefaults] setObject:recordingsArray forKey:@"recordingsArray"];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)dealloc {
	
	[[NSUserDefaults standardUserDefaults] setObject:recordingsArray forKey:@"recordingsArray"];
	
	[controlButtonBackground release];
	[positionButtonBackground release];
	[positionSlider release];
	[stopButton release];
	[playButton release];
	[recordButton release];
	[fastForwardButton release];
	[rewindButton release];
	[recorderTableView release];
	[recordingsArray release];
    [super dealloc];
}


@end
