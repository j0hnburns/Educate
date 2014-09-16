//
//  TeachingStrategyDescriptionController.m
//  Educate
//
//  Created by James Hodge on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TeachingStrategyDescriptionController.h"
#import "CustomNavigationHeader.h"
#import "TeachingStrategyExampleController.h"


@implementation TeachingStrategyDescriptionController

@synthesize customNavHeader;
@synthesize descriptionImageView;
@synthesize exampleImageName;
@synthesize imageScrollFrame;
@synthesize exampleButton;




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		exampleImageName = @"";
		
 customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
 customNavHeader.viewHeader.text = @"Teaching Strategies";
 customNavHeader.upperSubHeading.text = @"";
		customNavHeader.upperSubHeading.frame = CGRectMake(20, 55, 280, 20);
		customNavHeader.lowerSubHeading.frame = CGRectMake(20, 80, 280, 40);
		customNavHeader.lowerSubHeading.numberOfLines = 2;
 customNavHeader.lowerSubHeading.text = @"";
 [self.view addSubview:customNavHeader];
 [customNavHeader release];
 
 
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
 
		
		
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 40);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
			
 
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
}

- (void)addDescriptionImageToScrollView {
	
	descriptionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"desc_%@",exampleImageName]]];	
	[imageScrollFrame addSubview:descriptionImageView];
	
	// only show example button if there is an example image
	if ([UIImage imageNamed:[NSString stringWithFormat:@"%@",exampleImageName]] != nil) {
	
	
	exampleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	exampleButton.frame = CGRectMake(200, (descriptionImageView.frame.size.height + 30), 102, 45);
	[exampleButton setTitle:@"See Example" forState:UIControlStateNormal];
	[exampleButton setBackgroundColor:[UIColor clearColor]];
	[exampleButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[exampleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[exampleButton addTarget:self action:@selector(showExample) forControlEvents:UIControlEventTouchUpInside];
	exampleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[imageScrollFrame addSubview:exampleButton];
	
	}
	
	[imageScrollFrame setContentSize:CGSizeMake(descriptionImageView.frame.size.width, descriptionImageView.frame.size.height+80)];
	[descriptionImageView release];
	
}
- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)showExample {
	
	TeachingStrategyExampleController *teachingStrategyExampleController = [[TeachingStrategyExampleController alloc] initWithNibName: nil bundle:nil];
	teachingStrategyExampleController.customNavHeader.upperSubHeading.text = self.customNavHeader.upperSubHeading.text;
	teachingStrategyExampleController.customNavHeader.lowerSubHeading.text = self.customNavHeader.lowerSubHeading.text;

	[teachingStrategyExampleController addDescriptionImageToScrollView:exampleImageName];
	[self.navigationController pushViewController:teachingStrategyExampleController animated:YES];
	//[teachingStrategyExampleController release];

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
	[descriptionImageView release];
	[exampleImageName release];
	[imageScrollFrame release];
	[exampleButton release];
    [super dealloc];
}


@end
