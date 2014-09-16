//
//  TrackerAttendanceAlertView.m
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackerAttendanceAlertView.h"


@implementation TrackerAttendanceAlertView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		UIImageView* valueSelectorBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackerPopup_background.png"]];	
		valueSelectorBackground.frame = CGRectMake(0,0,264,243);
		[self addSubview:valueSelectorBackground];
		[valueSelectorBackground release];
		
		UIButton* valueButtonA = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonA.frame = CGRectMake(35,70,60,50);
		[valueButtonA setTitle:@"P" forState:UIControlStateNormal];
		[valueButtonA setBackgroundColor:[UIColor clearColor]];
		[valueButtonA setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonA.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonA addTarget:self action:@selector(returnValuePresent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonA];
		
		
		UIButton* valueButtonB = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonB.frame = CGRectMake(95,70,60,50);
		[valueButtonB setTitle:@"A" forState:UIControlStateNormal];
		[valueButtonB setBackgroundColor:[UIColor clearColor]];
		[valueButtonB setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonB.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonB addTarget:self action:@selector(returnValueAbsent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonB];
		
		UIButton* valueButtonC = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonC.frame = CGRectMake(155,70,60,50);
		[valueButtonC setTitle:@"S" forState:UIControlStateNormal];
		[valueButtonC setBackgroundColor:[UIColor clearColor]];
		[valueButtonC setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonC.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonC addTarget:self action:@selector(returnValueM) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonC];
		
		
		UIButton* valueButtonD = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonD = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonD.frame = CGRectMake(35,120,60,50);
		[valueButtonD setTitle:@"T" forState:UIControlStateNormal];
		[valueButtonD setBackgroundColor:[UIColor clearColor]];
		[valueButtonD setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonD.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonD addTarget:self action:@selector(returnValueT) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonD];
		
		UIButton* valueButtonE = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonE = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonE.frame = CGRectMake(95,120,60,50);
		[valueButtonE setTitle:@"L" forState:UIControlStateNormal];
		[valueButtonE setBackgroundColor:[UIColor clearColor]];
		[valueButtonE setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonE setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonE.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonE addTarget:self action:@selector(returnValueLeave) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonE];
	
		
		UIButton* clearButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		clearButton.frame = CGRectMake(155,120,60,50);
		[clearButton setTitle:@"Clear" forState:UIControlStateNormal];
		[clearButton setBackgroundColor:[UIColor clearColor]];
		[clearButton setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greyButton.png"] forState:UIControlStateNormal];	
		[clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[clearButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[clearButton addTarget:self action:@selector(clearAndReturn) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:clearButton];

		
		
		UIButton* cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		cancelButton.frame = CGRectMake(53,170,150,40);
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[cancelButton setBackgroundColor:[UIColor clearColor]];
		[cancelButton setBackgroundImage:[UIImage imageNamed:@"trackerPopupWide_greyButton.png"] forState:UIControlStateNormal];	
		[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cancelButton addTarget:self action:@selector(cancelAndReturn) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:cancelButton];
		
		
		
    }
    return self;
}

- (void)returnValuePresent {
	[self dismissWithClickedButtonIndex:1 animated:YES];
}
- (void)returnValueAbsent {
	[self dismissWithClickedButtonIndex:2 animated:YES];
}
- (void)returnValueSick {
	[self dismissWithClickedButtonIndex:3 animated:YES];
}
- (void)returnValueLeave {
	[self dismissWithClickedButtonIndex:4 animated:YES];
}
- (void)returnValueT {
	[self dismissWithClickedButtonIndex:5 animated:YES];
}
- (void)returnValueM {
	[self dismissWithClickedButtonIndex:6 animated:YES];
}
- (void)cancelAndReturn {
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)clearAndReturn {
	[self dismissWithClickedButtonIndex:99 animated:YES];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}



- (void)dealloc {
    [super dealloc];
}


@end
