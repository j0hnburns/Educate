//
//  TrackerStudentNameContactActionSelectionAlertView.m
//  Educate
//
//  Created by James Hodge on 28/11/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "TrackerStudentNameContactActionSelectionAlertView.h"


@implementation TrackerStudentNameContactActionSelectionAlertView

@synthesize valueButtonPhoneStudent;
@synthesize valueButtonPhoneGuardian;
@synthesize valueButtonEmailStudent;
@synthesize valueButtonEmailGuardian;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		UIImageView* valueSelectorBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackerStudentContactPopupBackground.png"]];	
		valueSelectorBackground.frame = CGRectMake(0,0,264,275);
		[self addSubview:valueSelectorBackground];
		[valueSelectorBackground release];
		
		valueButtonPhoneStudent = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonPhoneStudent.frame = CGRectMake(40,50,180,37);
		[valueButtonPhoneStudent setTitle:@"Phone Student" forState:UIControlStateNormal];
		[valueButtonPhoneStudent setBackgroundColor:[UIColor clearColor]];
		[valueButtonPhoneStudent setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonPhoneStudent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonPhoneStudent.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[valueButtonPhoneStudent addTarget:self action:@selector(returnValuePhoneStudent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonPhoneStudent];
		
		valueButtonPhoneGuardian = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonPhoneGuardian.frame = CGRectMake(40,90,180,37);
		[valueButtonPhoneGuardian setTitle:@"Phone Guardian" forState:UIControlStateNormal];
		[valueButtonPhoneGuardian setBackgroundColor:[UIColor clearColor]];
		[valueButtonPhoneGuardian setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonPhoneGuardian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonPhoneGuardian.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[valueButtonPhoneGuardian addTarget:self action:@selector(returnValuePhoneGuardian) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonPhoneGuardian];
		
		valueButtonEmailStudent = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonEmailStudent.frame = CGRectMake(40,130,180,37);
		[valueButtonEmailStudent setTitle:@"Email Student" forState:UIControlStateNormal];
		[valueButtonEmailStudent setBackgroundColor:[UIColor clearColor]];
		[valueButtonEmailStudent setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonEmailStudent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonEmailStudent.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[valueButtonEmailStudent addTarget:self action:@selector(returnValueEmailStudent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonEmailStudent];
		
		valueButtonEmailGuardian = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonEmailGuardian.frame = CGRectMake(40,170,180,37);
		[valueButtonEmailGuardian setTitle:@"Email Guardian" forState:UIControlStateNormal];
		[valueButtonEmailGuardian setBackgroundColor:[UIColor clearColor]];
		[valueButtonEmailGuardian setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonEmailGuardian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonEmailGuardian.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[valueButtonEmailGuardian addTarget:self action:@selector(returnValueEmailGuardian) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonEmailGuardian];
		
		
		UIButton* cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		cancelButton.frame = CGRectMake(40,210,180,37);
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[cancelButton setBackgroundColor:[UIColor clearColor]];
		[cancelButton setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_greyButton.png"] forState:UIControlStateNormal];	
		[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[cancelButton addTarget:self action:@selector(cancelAndReturn) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cancelButton];
		
		
    }
    return self;
}

- (void)returnValuePhoneStudent {
	[self dismissWithClickedButtonIndex:1 animated:YES];
}


- (void)returnValuePhoneGuardian {
	[self dismissWithClickedButtonIndex:2 animated:YES];
}


- (void)returnValueEmailStudent {
	[self dismissWithClickedButtonIndex:3 animated:YES];
}


- (void)returnValueEmailGuardian {
	[self dismissWithClickedButtonIndex:4 animated:YES];
}


- (void)cancelAndReturn {
	[self dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[valueButtonPhoneStudent release];
	[valueButtonPhoneGuardian release];
	[valueButtonEmailStudent release];
	[valueButtonEmailGuardian release];
    [super dealloc];
}


@end
