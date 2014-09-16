//
//  ELearningViewController.m
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ELearningViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "StopwatchContoller.h"
#import "ELearningBookmarksViewController.h"
#import "AudioRecorderViewController.h"
#import "ImageCreatorController.h"


@implementation ELearningViewController

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
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"eLearning";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
	[self.view addSubview:customNavHeader];
	
	UIButton* audioIcon = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	audioIcon.frame = CGRectMake(30, 250, 120, 113);
	[audioIcon setImage:[UIImage imageNamed:@"elearnIcon_audio.png"] forState:UIControlStateNormal];
	[audioIcon setBackgroundColor:[UIColor clearColor]];
	[audioIcon addTarget:self action:@selector(pushAudioController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:audioIcon];
	
	UILabel* audioLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 365, 120, 30)];
	audioLabel.text = @"Audio Recorder";
	audioLabel.backgroundColor = [UIColor clearColor];
	audioLabel.textColor = [UIColor whiteColor];
	audioLabel.textAlignment = UITextAlignmentCenter;
	audioLabel.font = [UIFont boldSystemFontOfSize:15];
	audioLabel.shadowColor = [UIColor blackColor];
	audioLabel.shadowOffset = CGSizeMake(0,1);
	audioLabel.numberOfLines = 2;
	[self.view addSubview:audioLabel];
	[audioLabel release];
	
	
	UIButton* imageIcon = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	imageIcon.frame = CGRectMake(170, 85, 120, 113);
	[imageIcon setImage:[UIImage imageNamed:@"elearnIcon_image.png"] forState:UIControlStateNormal];
	[imageIcon setBackgroundColor:[UIColor clearColor]];
	[imageIcon addTarget:self action:@selector(pushImageCaptureController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:imageIcon];
	
	UILabel* imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 195, 120, 30)];
	imageLabel.text = @"Image Creator";
	imageLabel.backgroundColor = [UIColor clearColor];
	imageLabel.textColor = [UIColor whiteColor];
	imageLabel.textAlignment = UITextAlignmentCenter;
	imageLabel.font = [UIFont boldSystemFontOfSize:15];
	imageLabel.shadowColor = [UIColor blackColor];
	imageLabel.shadowOffset = CGSizeMake(0,1);
	imageLabel.numberOfLines = 2;
	[self.view addSubview:imageLabel];
	[imageLabel release];
	
	UIButton* bookmarksButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	bookmarksButton.frame = CGRectMake(30, 85, 120, 113);
	[bookmarksButton setImage:[UIImage imageNamed:@"elearnIcon_elearn.png"] forState:UIControlStateNormal];
	[bookmarksButton setBackgroundColor:[UIColor clearColor]];
	[bookmarksButton addTarget:self action:@selector(pushELearningBookmarksController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:bookmarksButton];
	
	UILabel* bookmarksLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 195, 120, 30)];
	bookmarksLabel.text = @"Bookmarks";
	bookmarksLabel.backgroundColor = [UIColor clearColor];
	bookmarksLabel.textColor = [UIColor whiteColor];
	bookmarksLabel.textAlignment = UITextAlignmentCenter;
	bookmarksLabel.font = [UIFont boldSystemFontOfSize:15];
	bookmarksLabel.shadowColor = [UIColor blackColor];
	bookmarksLabel.shadowOffset = CGSizeMake(0,1);
	bookmarksLabel.numberOfLines = 2;
	[self.view addSubview:bookmarksLabel];
	[bookmarksLabel release];
	
	
	UIButton* stopwatchIcon = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	stopwatchIcon.frame = CGRectMake(170, 250, 120, 113);
	[stopwatchIcon setImage:[UIImage imageNamed:@"elearnIcon_stopwatch.png"] forState:UIControlStateNormal];
	[stopwatchIcon setBackgroundColor:[UIColor clearColor]];
	[stopwatchIcon addTarget:self action:@selector(pushStopwatchController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopwatchIcon];
	
	UILabel* stopwatchLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 365, 120, 30)];
	stopwatchLabel.text = @"Stopwatch";
	stopwatchLabel.backgroundColor = [UIColor clearColor];
	stopwatchLabel.textColor = [UIColor whiteColor];
	stopwatchLabel.textAlignment = UITextAlignmentCenter;
	stopwatchLabel.font = [UIFont boldSystemFontOfSize:15];
	stopwatchLabel.shadowColor = [UIColor blackColor];
	stopwatchLabel.shadowOffset = CGSizeMake(0,1);
	stopwatchLabel.numberOfLines = 2;
	[self.view addSubview:stopwatchLabel];
	[stopwatchLabel release];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)pushStopwatchController {
	StopwatchContoller *stopwatchContoller = [StopwatchContoller alloc];    
	stopwatchContoller.title = @"Stopwatch";
	[[self navigationController] pushViewController:stopwatchContoller animated:YES];
	[stopwatchContoller release];
	
	
}

- (void)pushAudioController {
	AudioRecorderViewController *audioRecorderController = [[AudioRecorderViewController alloc] initWithNibName:nil bundle:nil];    
	audioRecorderController.title = @"Audio Recorder";
	[[self navigationController] pushViewController:audioRecorderController animated:YES];
	[audioRecorderController release];
}

- (void)pushImageCaptureController {
	ImageCreatorController *imageCreatorController = [[ImageCreatorController alloc] initWithNibName:nil bundle:nil];    
	imageCreatorController.title = @"Image Creator";
	[[self navigationController] pushViewController:imageCreatorController animated:YES];
	[imageCreatorController release];
}

- (void)pushELearningBookmarksController {
	ELearningBookmarksViewController *eLearningBookmarksViewController = [[ELearningBookmarksViewController alloc] initWithNibName:nil bundle:nil];    
	eLearningBookmarksViewController.title = @"Bookmarks";
	[[self navigationController] pushViewController:eLearningBookmarksViewController animated:YES];
	[eLearningBookmarksViewController release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
