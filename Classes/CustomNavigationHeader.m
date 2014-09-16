//
//  CustomNavigationHeader.m
//  Educate
//
//  Created by James Hodge on 2/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationHeader.h"
#import "EducateAppDelegate.h"


@implementation CustomNavigationHeader

@synthesize viewBackground;
@synthesize backButton;
@synthesize viewHeader;
@synthesize rightSettingsButton;
@synthesize upperSubHeading;
@synthesize lowerSubHeading;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		
		viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viewHeader.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,134);
		[self addSubview:viewBackground];
		//[viewBackground release];
		
		viewHeader = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 20)];
		viewHeader.text = @"";
		viewHeader.backgroundColor = [UIColor clearColor];
		viewHeader.textColor = [UIColor whiteColor];
		viewHeader.textAlignment = UITextAlignmentLeft;
		viewHeader.font = [UIFont boldSystemFontOfSize:18];
		viewHeader.shadowColor = [UIColor blackColor];
		viewHeader.shadowOffset = CGSizeMake(0,1);
		[self addSubview:viewHeader];
		//[viewHeader release];
		
		upperSubHeading = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 180, 20)];
		upperSubHeading.text = @"";
		upperSubHeading.backgroundColor = [UIColor clearColor];
		upperSubHeading.textColor = [UIColor whiteColor];
		upperSubHeading.textAlignment = UITextAlignmentLeft;
		upperSubHeading.font = [UIFont boldSystemFontOfSize:18];
		upperSubHeading.shadowColor = [UIColor blackColor];
		upperSubHeading.shadowOffset = CGSizeMake(0,1);
		[self addSubview:upperSubHeading];
		//[upperSubHeading release];
		
		lowerSubHeading = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 180, 20)];
		lowerSubHeading.text = @"";
		lowerSubHeading.backgroundColor = [UIColor clearColor];
		lowerSubHeading.textColor = [UIColor whiteColor];
		lowerSubHeading.textAlignment = UITextAlignmentLeft;
		lowerSubHeading.font = [UIFont systemFontOfSize:18];
		lowerSubHeading.shadowColor = [UIColor blackColor];
		lowerSubHeading.shadowOffset = CGSizeMake(0,1);
		[self addSubview:lowerSubHeading];
		//[lowerSubHeading release];
		

		/*
		frame = CGRectMake(690,0,156,48);
		fridayPeriodButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		fridayPeriodButton.frame = frame;
		[fridayPeriodButton setTitle:@"Reject Buddy Request" forState:UIControlStateNormal];
		[fridayPeriodButton setBackgroundColor:[UIColor clearColor]];
		[fridayPeriodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[fridayPeriodButton setFont:[UIFont systemFontOfSize:14]];
		[fridayPeriodButton addTarget:self action:@selector(showPeriodDetailForFriday) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:fridayPeriodButton];
		*/
		
    }
    return self;
}


- (void)popBackToPreviousView {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[[appDelegate dailyPlannerNavigationController] popViewControllerAnimated:YES];
}

- (void)callPopBackToPreviousView {
	[self performSelectorOnMainThread:@selector(popBackToPreviousView) withObject:nil waitUntilDone:NO];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[viewBackground release];
	[backButton release];
	[viewHeader release];
	[rightSettingsButton release];
	[upperSubHeading release];
	[lowerSubHeading release];
    [super dealloc];
}


@end
