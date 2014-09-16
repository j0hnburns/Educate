//
//  TeachingStrategiesViewController.m
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TeachingStrategiesViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "TeachingThinkingStrategiesViewController.h"
#import "TeachingCollaborativeStrategiesViewController.h"


@implementation TeachingStrategiesViewController

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
	customNavHeader.viewHeader.text = @"Strategies";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
	[self.view addSubview:customNavHeader];
	
	UIButton* thinkingStrategiesButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	thinkingStrategiesButton.frame = CGRectMake(30, 165, 120, 113);
	[thinkingStrategiesButton setImage:[UIImage imageNamed:@"teachIcon_thinking.png"] forState:UIControlStateNormal];
	[thinkingStrategiesButton setBackgroundColor:[UIColor clearColor]];
	[thinkingStrategiesButton addTarget:self action:@selector(showTeachingThinkingStrategiesController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:thinkingStrategiesButton];
	
	UILabel* thinkingLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 285, 120, 50)];
	thinkingLabel.text = @"Thinking\rStrategies";
	thinkingLabel.backgroundColor = [UIColor clearColor];
	thinkingLabel.textColor = [UIColor whiteColor];
	thinkingLabel.textAlignment = UITextAlignmentCenter;
	thinkingLabel.font = [UIFont boldSystemFontOfSize:15];
	thinkingLabel.shadowColor = [UIColor blackColor];
	thinkingLabel.shadowOffset = CGSizeMake(0,1);
	thinkingLabel.numberOfLines = 2;
	[self.view addSubview:thinkingLabel];
	[thinkingLabel release];
	
	 
	 UIButton* collaborativeStrategiesButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	 collaborativeStrategiesButton.frame = CGRectMake(170, 165, 120, 113);
	 [collaborativeStrategiesButton setImage:[UIImage imageNamed:@"teachIcon_collaborative.png"] forState:UIControlStateNormal];
	 [collaborativeStrategiesButton setBackgroundColor:[UIColor clearColor]];
	 [collaborativeStrategiesButton addTarget:self action:@selector(showTeachingCollaborativeStrategiesController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:collaborativeStrategiesButton];
	
	UILabel* collaborativeLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 285, 120, 50)];
	collaborativeLabel.text = @"Collaborative\rStrategies";
	collaborativeLabel.backgroundColor = [UIColor clearColor];
	collaborativeLabel.textColor = [UIColor whiteColor];
	collaborativeLabel.textAlignment = UITextAlignmentCenter;
	collaborativeLabel.font = [UIFont boldSystemFontOfSize:15];
	collaborativeLabel.shadowColor = [UIColor blackColor];
	collaborativeLabel.shadowOffset = CGSizeMake(0,1);
	collaborativeLabel.numberOfLines = 2;
	[self.view addSubview:collaborativeLabel];
	[collaborativeLabel release];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)showTeachingThinkingStrategiesController {
	TeachingThinkingStrategiesViewController *teachingThinkingStrategiesViewController = [[TeachingThinkingStrategiesViewController alloc] initWithNibName: nil bundle:nil];
	[[self navigationController] pushViewController:teachingThinkingStrategiesViewController animated:YES];
	//[teachingThinkingStrategiesViewController release];
}

- (void)showTeachingCollaborativeStrategiesController {
	TeachingCollaborativeStrategiesViewController *teachingCollaborativeStrategiesViewController = [[TeachingCollaborativeStrategiesViewController alloc] initWithNibName: nil bundle:nil];
	[[self navigationController] pushViewController:teachingCollaborativeStrategiesViewController animated:YES];
	//[teachingCollaborativeStrategiesViewController release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
