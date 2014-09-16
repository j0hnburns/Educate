//
//  ELearningAccessViewController.m
//  Educate
//
//  Created by James Hodge on 13/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ELearningAccessViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "ELearningBrowserMoodleController.h"
#import "ELearningBrowserBlackBoardController.h"
#import "EducateAppDelegate.h"



@implementation ELearningAccessViewController

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
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"eLearning Access";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
	[self.view addSubview:customNavHeader];
	
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	
	UIButton* moodleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	moodleButton.frame = CGRectMake(30, 165, 120, 113);
	[moodleButton setImage:[UIImage imageNamed:@"elearningIcon_moodle.png"] forState:UIControlStateNormal];
	[moodleButton setBackgroundColor:[UIColor clearColor]];
	[moodleButton addTarget:self action:@selector(showMoodleWebController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:moodleButton];
	
	UILabel* moodleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 285, 120, 50)];
	moodleLabel.text = @"Moodle";
	moodleLabel.backgroundColor = [UIColor clearColor];
	moodleLabel.textColor = [UIColor whiteColor];
	moodleLabel.textAlignment = UITextAlignmentCenter;
	moodleLabel.font = [UIFont boldSystemFontOfSize:15];
	moodleLabel.shadowColor = [UIColor blackColor];
	moodleLabel.shadowOffset = CGSizeMake(0,1);
	moodleLabel.numberOfLines = 2;
	[self.view addSubview:moodleLabel];
	[moodleLabel release];
	
	// check if settings for Moodle are configured, if not then disable and grey out button
	NSLog(@"Moodle: Comparing %@ with %@ to see if the button should be disabled",appDelegate.settings_moodleEmail,@"");
	if (appDelegate.settings_moodleEmail == NULL || [appDelegate.settings_moodleEmail isEqualToString:@""]) {
		//moodleButton.enabled = NO;
		[moodleButton setAlpha:0.5];
		[moodleLabel setAlpha:0.5];
		NSLog(@"Disabling Moodle Button");
	}
	
	
	
	UIButton* blackboardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	blackboardButton.frame = CGRectMake(170, 165, 120, 113);
	[blackboardButton setImage:[UIImage imageNamed:@"elearnIcon_blackboard.png"] forState:UIControlStateNormal];
	[blackboardButton setBackgroundColor:[UIColor clearColor]];
	[blackboardButton addTarget:self action:@selector(showBlackboardWebController) forControlEvents:UIControlEventTouchUpInside];
	blackboardButton.hidden = YES;
	[self.view addSubview:blackboardButton];
	
	UILabel* blackboardLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 285, 120, 50)];
	blackboardLabel.text = @"Blackboard";
	blackboardLabel.backgroundColor = [UIColor clearColor];
	blackboardLabel.textColor = [UIColor whiteColor];
	blackboardLabel.textAlignment = UITextAlignmentCenter;
	blackboardLabel.font = [UIFont boldSystemFontOfSize:15];
	blackboardLabel.shadowColor = [UIColor blackColor];
	blackboardLabel.shadowOffset = CGSizeMake(0,1);
	blackboardLabel.numberOfLines = 2;
	blackboardLabel.hidden = YES;
	[self.view addSubview:blackboardLabel];
	[blackboardLabel release];
	
	// check if settings for BlackBoard are configured, if not then disable and grey out button
	NSLog(@"Blackbaord: Comparing %@ with %@ to see if the button should be disabled",appDelegate.settings_googleEmail,@"");
	if (appDelegate.settings_googleEmail == NULL || [appDelegate.settings_googleEmail isEqualToString:@""]) {
		//blackboardButton.enabled = NO;
		[blackboardButton setAlpha:0.5];
		[blackboardLabel setAlpha:0.5];
		NSLog(@"Disabling Blackboard Button");
	}
	
    [super viewDidLoad];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)showMoodleWebController {
	// if Moodle settings are configured then push the view controller otherwise display the alert
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (appDelegate.settings_moodleEmail == NULL || [appDelegate.settings_moodleEmail isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Settings" message:@"Before you can access Moodle you need to configure your username and password in the Educate Settings tab (under 'More...' in the Tab Bar below)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	} else {
		// if moodle settings are configured, check for internet access before running code.  if no access display warning else open moodle
		
		
		if (appDelegate.internetConnectionStatus == NotReachable) {
			
			// if first offline failure then notify user with alert box
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to connect to Moodle.  You will not be able to use the Moodle module in Educate until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];
				[alert release];
		
			
		} else {
			// internet connection is active - open Moodle
		ELearningBrowserMoodleController *eLearningBrowserMoodleController = [[ELearningBrowserMoodleController alloc] initWithNibName:nil bundle:nil];    
		eLearningBrowserMoodleController.title = @"Moodle";
		[[self navigationController] pushViewController:eLearningBrowserMoodleController animated:YES];
		[eLearningBrowserMoodleController release];
			
			}
	}
	
}

- (void)showBlackboardWebController {
	
	// if Blackboard settings are configured then push the view controller otherwise display the alert
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (appDelegate.settings_googleEmail == NULL || [appDelegate.settings_googleEmail isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Settings" message:@"Before you can access Blackboard you need to configure your username and password in the Educate Settings tab (under 'More...' in the Tab Bar below)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	} else {
		ELearningBrowserBlackBoardController *eLearningBrowserBlackBoardController = [[ELearningBrowserBlackBoardController alloc] initWithNibName:nil bundle:nil];    
		eLearningBrowserBlackBoardController.title = @"BlackBoard";
		[[self navigationController] pushViewController:eLearningBrowserBlackBoardController animated:YES];
		[eLearningBrowserBlackBoardController release];
	}
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
