/*
    File: AudioViewController.m
Abstract: View controller class for SpeakHere. Sets up user interface, responds 
to and manages user interaction.
 Version: 1.2

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AudioViewController.h"
#import "SpeakHereAppDelegate.h"

#define kLevelMeterWidth	238
#define kLevelMeterHeight	45
#define kLevelOverload		0.9
#define kLevelHot			0.7
#define kLevelMinimum		0.01

void interruptionListenerCallback (
	void	*inUserData,
	UInt32	interruptionState
) {
	// This callback, being outside the implementation block, needs a reference 
	//	to the AudioViewController object. You provide this reference when
	//	initializing the audio session (see the call to AudioSessionInitialize).
	AudioViewController *controller = (AudioViewController *) inUserData;
	
	if (interruptionState == kAudioSessionBeginInterruption) {

		NSLog (@"Interrupted. Stopping playback or recording.");
		
		if (controller.audioRecorder) {
			// if currently recording, stop
			[controller recordOrStop: (id) controller];
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
	AudioViewController *controller = (AudioViewController *) inUserData;

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

			[controller recordOrStop: (id) controller];

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





@implementation AudioViewController

@synthesize audioPlayer;			// the playback audio queue object
@synthesize audioRecorder;			// the recording audio queue object
@synthesize soundFileURL;			// the sound file to record to and to play back
@synthesize recordingDirectory;		// the location to record into; it's the application's Documents directory
@synthesize playButton;				// the play button, which toggles to display "stop"
@synthesize recordButton;			// the record button, which toggles to display "stop"
@synthesize levelMeter;				// a mono audio level meter to show average level, implemented using Core Animation
@synthesize peakLevelMeter;			// a mono audio level meter to show peak level, implemented using Core Animation
@synthesize peakGray;				// a color to use with the peak audio level display
@synthesize peakOrange;				// a color to use with the peak audio level display
@synthesize peakRed;				// a color to use with the peak audio level display
@synthesize peakClear;				// a color to use with the peak audio level display
@synthesize bargraphTimer;			// a timer for updating the level meter
@synthesize audioLevels;			// an array of two floating point values that represents the current recording or playback audio level
@synthesize peakLevels;				// an array of two floating point values that represents the current recording or playback audio level
@synthesize statusSign;				// a UILabel object that says "Recording" or "Playback," or empty when stopped
@synthesize interruptedOnPlayback;	// this allows playback to resume when an interruption ends. this app does not resume a recording for the user.

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {

	self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];

	if (self != nil) {

		// this app uses a fixed file name at a fixed location, so it makes sense to set the name and 
		// URL here.
		NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
		
									NSDocumentDirectory, 
									NSUserDomainMask,
									YES
								); 
								
		self.recordingDirectory = [filePaths objectAtIndex: 0];
	
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/Recording.caf", self.recordingDirectory];

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

- (void) addBargraphToView: (UIView *) parentView {

	// static image for showing average level
	UIImage *soundbarImage		= [[UIImage imageNamed: @"soundbar_mono.png"] retain];

	// background colors for generated image for showing peak level
	self.peakClear				= [UIColor clearColor];
	self.peakGray				= [UIColor lightGrayColor];
	self.peakOrange				= [UIColor orangeColor];
	self.peakRed				= [UIColor redColor]; 
	
	levelMeter					= [CALayer layer];
	levelMeter.anchorPoint		= CGPointMake (0.0, 0.5);						// anchor to halfway up the left edge
	levelMeter.frame			= CGRectMake (41, 131, 0, kLevelMeterHeight);	// set width to 0 to start to completely hide the bar graph segements
	levelMeter.contents			= (UIImage *) soundbarImage.CGImage;

	peakLevelMeter				= [CALayer layer];
	peakLevelMeter.frame		= CGRectMake (41, 131, 0, kLevelMeterHeight);
	peakLevelMeter.anchorPoint	= CGPointMake (0.0, 0.5);
	peakLevelMeter.backgroundColor = peakGray.CGColor;

	peakLevelMeter.bounds		= CGRectMake (0, 0, 0, kLevelMeterHeight);
	peakLevelMeter.contentsRect	= CGRectMake (0, 0, 1.0, 1.0);

	[parentView.layer addSublayer: levelMeter];
	[parentView.layer addSublayer: peakLevelMeter];
}


- (void) viewDidLoad {
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	
	// on the very first launch of the application, there's no file to play,
	//	so gray out the Play button
	if ([fileManager fileExistsAtPath: [NSString stringWithFormat: @"%@/Recording.caf", self.recordingDirectory]] != TRUE) {
		[self.playButton setEnabled: NO];
	}

	[statusSign setFont: [UIFont fontWithName: @"Helvetica" size: 24.0]];
}


// this method gets called (by property listener callback functions) when a recording or playback 
// audio queue object starts or stops. 
- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue {

	NSAutoreleasePool *uiUpdatePool = [[NSAutoreleasePool alloc] init];

	NSLog (@"updateUserInterfaceOnAudioQueueStateChange just called.");

	// the audio queue (playback or record) just started
	if ([inQueue isRunning]) {
	
		// create a timer for updating the audio level meter
		self.bargraphTimer = [NSTimer scheduledTimerWithTimeInterval:	0.05		// seconds
															target:		self
															selector:	@selector (updateBargraph:)
															userInfo:	inQueue		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
															repeats:	YES];
		// playback just started
		if (inQueue == self.audioPlayer) {
		
			NSLog (@"playback just started.");
			[self.recordButton setEnabled: NO];
			[self.playButton setTitle: @"Stop"];
			[self.statusSign setText: @"Playback"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0]];

		// recording just started
		} else if (inQueue == self.audioRecorder) {
		
			NSLog (@"recording just started.");
			[self.playButton setEnabled: NO];
			NSLog (@"setting Record button title to Stop.");
			[self.recordButton setTitle: @"Stop"];
			[self.statusSign setText: @"Recording"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.67 green: 0.0 blue: 0.0 alpha: 1.0]];
		}
	// the audio queue (playback or record) just stopped
	} else {

		// playback just stopped
		if (inQueue == self.audioPlayer) {
		
			NSLog (@"playback just stopped.");
			[self.recordButton setEnabled: YES];
			[self.playButton setTitle: @"Play"];

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
			[self.recordButton setTitle: @"Record"];

			[self.audioRecorder release];
			audioRecorder = nil;
		}

		if (self.bargraphTimer) {
		
			[self.bargraphTimer invalidate];
			[self.bargraphTimer release];
			bargraphTimer = nil;
		}

		[self.statusSign setText: @""];
		[self resetBargraph];
	}
	
	[uiUpdatePool drain];
}


// respond to a tap on the Record button. If stopped, start recording. If recording, stop.
// an audio queue object is created for each recording, and destroyed when the recording finishes.
- (IBAction) recordOrStop: (id) sender {

	NSLog (@"recordOrStop:");
	
	// if not recording, start recording
	if (self.audioRecorder == nil) {
	
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

// respond to a tap on the Play button. If stopped, start playing. If playing, stop.
- (IBAction) playOrStop: (id) sender {

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
		[self playOrStop: self];
	}
	
	[routeChangeAlertView release];			
}


// Core Animation-based audio level meter updating method
- (void) updateBargraph: (NSTimer *) timer {

	AudioQueueObject *activeQueue = (AudioQueueObject *) [timer userInfo];
	
	if (activeQueue) {
	
		[activeQueue getAudioLevels: self.audioLevels peakLevels: self.peakLevels];
//		NSLog (@"Average: %f, Peak: %f", audioLevels[0], peakLevels[0]);
		
		[CATransaction begin];

			[CATransaction setValue: [NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];

			levelMeter.bounds =			CGRectMake (
											0,
											0,
											(audioLevels[0] > 1.0 ? 1.0 : audioLevels[0]) * kLevelMeterWidth,
											kLevelMeterHeight
										);

			levelMeter.contentsRect	=	CGRectMake (
											0,
											0,
											audioLevels[0],
											1.0
										);
										
			peakLevelMeter.frame =		CGRectMake (
											41.0 + (peakLevels[0] > 1.0 ? 1.0 : peakLevels[0] )* kLevelMeterWidth,
											131,
											3,
											kLevelMeterHeight
										);
			peakLevelMeter.bounds =		CGRectMake (
											0,
											0,
											3,
											kLevelMeterHeight
										);

			if (peakLevels[0] > kLevelOverload) {
				peakLevelMeter.backgroundColor = self.peakRed.CGColor;
			} else if (peakLevels[0] > kLevelHot) {
				peakLevelMeter.backgroundColor = self.peakOrange.CGColor;
			} else if (peakLevels[0] > kLevelMinimum) {
				peakLevelMeter.backgroundColor = self.peakGray.CGColor;
			} else {
				peakLevelMeter.backgroundColor = self.peakClear.CGColor;
			}

		[CATransaction commit];
	}
}


- (void) resetBargraph {

	levelMeter.bounds		= CGRectMake (0, 0, 0, kLevelMeterHeight);
	peakLevelMeter.frame	= CGRectMake (41, 131, 3, kLevelMeterHeight);
	peakLevelMeter.bounds	= CGRectMake (0, 0, 0, kLevelMeterHeight);
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
		[self recordOrStop: self];
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



- (void) dealloc {

	[recordButton		release];
	[playButton			release];
	
	[super dealloc];
}


@end
