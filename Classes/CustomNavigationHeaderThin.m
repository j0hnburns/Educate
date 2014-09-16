//
//  CustomNavigationHeaderThin.m
//  Educate
//
//  Created by James Hodge on 2/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationHeaderThin.h"

@implementation CustomNavigationHeaderThin

@synthesize viewBackground;
@synthesize backButton;
@synthesize viewHeader;
//@synthesize rightSettingsButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		
		viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"viewHeaderThin.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,51);
		[self addSubview:viewBackground];

		
		viewHeader = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, 260, 26)];
		viewHeader.text = @"";
		viewHeader.backgroundColor = [UIColor clearColor];
		viewHeader.textColor = [UIColor whiteColor];
		viewHeader.textAlignment = UITextAlignmentCenter;
		viewHeader.font = [UIFont boldSystemFontOfSize:20];
		viewHeader.shadowColor = [UIColor blackColor];
		viewHeader.shadowOffset = CGSizeMake(0,1);
		[self addSubview:viewHeader];

		
		backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 44);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		backButton.hidden = YES;
		//[backButton addTarget:self action:@selector(showPeriodDetailForFriday) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:backButton];
		
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


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)setLandscapeOrientation {
	viewBackground.frame = CGRectMake(0,0,480,51);
	viewHeader.frame = CGRectMake(30,8,420,26);
	
}
- (void)setPortraitOrientation {
	viewBackground.frame = CGRectMake(0,0,320,51);
	viewHeader.frame = CGRectMake(30,8,260,26);
	
}

- (void)dealloc {
	[viewBackground release];
	[backButton release];
	[viewHeader release];
	//[rightSettingsButton release];
    [super dealloc];
}


@end
