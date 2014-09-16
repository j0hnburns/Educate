//
//  AudioRecorderViewController.h
//  Educate
//
//  Created by James Hodge on 20/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioQueueObject.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"

@interface AudioRecorderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UIImageView *controlButtonBackground;
	UIImageView *positionButtonBackground;
	UISlider *positionSlider;
	UIButton *stopButton;
	UIButton *playButton;
	UIButton *recordButton;
	UIButton *fastForwardButton;
	UIButton *rewindButton;
	UITableView *recorderTableView;
	
	NSMutableArray *recordingsArray;
	
	int currentRecording;
	
	AudioRecorder				*audioRecorder;
	AudioPlayer					*audioPlayer;
	NSURL						*soundFileURL;
	NSString					*recordingDirectory;
	
	Float32						*audioLevels;
	Float32						*peakLevels;
	
	
	IBOutlet UITextField		*statusSign;
	
	
	BOOL						interruptedOnPlayback;

	
	
}

- (void)callPopBackToPreviousView;
- (void)newRecording;
- (void)stopRecording;
- (void)playRecording;
- (void)previousRecording;
- (void)nextRecording;
- (void)startRecording;
- (void)setRecordingToPositionFromSlider;

- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue;
- (void) pausePlayback;
- (void) resumePlayback;

@property (nonatomic, retain) UIImageView *controlButtonBackground;
@property (nonatomic, retain) UIImageView *positionButtonBackground;
@property (nonatomic, retain) UISlider *positionSlider;
@property (nonatomic, retain) UIButton *stopButton;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *recordButton;
@property (nonatomic, retain) UIButton *fastForwardButton;
@property (nonatomic, retain) UIButton *rewindButton;
@property (nonatomic, retain) UITableView *recorderTableView;
@property (nonatomic, retain) NSMutableArray *recordingsArray;

@property (nonatomic, retain)	AudioRecorder				*audioRecorder;
@property (nonatomic, retain)	AudioPlayer					*audioPlayer;
@property (nonatomic, retain)	NSURL						*soundFileURL;
@property (nonatomic, retain)	NSString					*recordingDirectory;

@property (readwrite)			Float32						*audioLevels;
@property (readwrite)			Float32						*peakLevels;
@property (nonatomic, retain)	IBOutlet UITextField		*statusSign;


@property (readwrite)			BOOL						interruptedOnPlayback;


@end
