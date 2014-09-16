//
//  TeachingStrategyExampleController.m
//  Educate
//
//  Created by James Hodge on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TeachingStrategyExampleController.h"
#import "CustomNavigationHeader.h"


@implementation TeachingStrategyExampleController

@synthesize customNavHeader;
@synthesize exampleImageView;
@synthesize imageScrollFrame;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeader.viewHeader.text = @"Teaching Strategies";
		customNavHeader.upperSubHeading.frame = CGRectMake(20, 55, 280, 20);
		customNavHeader.lowerSubHeading.frame = CGRectMake(20, 80, 280, 40);
		customNavHeader.lowerSubHeading.numberOfLines = 2;
		
		[self.view addSubview:customNavHeader];
		[customNavHeader release];
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 40);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		 lowerViewBackground.frame = CGRectMake(0,134,320,330);
		[self.view addSubview:lowerViewBackground];
		[lowerViewBackground release];
		
		imageScrollFrame = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 140, 310, 270)];
		[imageScrollFrame setCanCancelContentTouches:NO];
		imageScrollFrame.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		imageScrollFrame.clipsToBounds = YES;
		imageScrollFrame.scrollEnabled = YES;
		imageScrollFrame.backgroundColor = [UIColor clearColor];
		[self.view addSubview:imageScrollFrame];
		//[labelPeriodType release];
		
    }
    return self;
}

- (void)addDescriptionImageToScrollView:(NSString *)withImageName {
	
	exampleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",withImageName]]];	
	exampleImageView.frame = CGRectMake((320-exampleImageView.frame.size.width)/2, 0, exampleImageView.frame.size.width, exampleImageView.frame.size.height);
	[imageScrollFrame addSubview:exampleImageView];
	[imageScrollFrame setContentSize:CGSizeMake(exampleImageView.frame.size.width, exampleImageView.frame.size.height)];
	[exampleImageView release];
	
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	
    [super viewDidLoad];
}


- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[customNavHeader release];
	[exampleImageView release];
	[imageScrollFrame release];
    [super dealloc];
}


@end