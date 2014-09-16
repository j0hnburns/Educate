//
//  TrackerCompetencyAlertView.m
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackerCompetencyAlertView.h"


@implementation TrackerCompetencyAlertView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		UIImageView* valueSelectorBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackerPopup_background.png"]];	
		valueSelectorBackground.frame = CGRectMake(0,0,264,243);
		[self addSubview:valueSelectorBackground];
		[valueSelectorBackground release];
		
		UIButton* valueButtonC = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonC.frame = CGRectMake(35,70,60,50);
		[valueButtonC setTitle:@"C" forState:UIControlStateNormal];
		[valueButtonC setBackgroundColor:[UIColor clearColor]];
		[valueButtonC setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonC.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonC addTarget:self action:@selector(returnValueCompetent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonC];
		
		
		UIButton* valueButtonNYC = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonNYC.frame = CGRectMake(95,70,60,50);
		[valueButtonNYC setTitle:@"NYC" forState:UIControlStateNormal];
		[valueButtonNYC setBackgroundColor:[UIColor clearColor]];
		[valueButtonNYC setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonNYC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonNYC.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonNYC addTarget:self action:@selector(returnValueNotYetCompetent) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonNYC];
		
		
		UIButton* valueButtonJ = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonJ.frame = CGRectMake(35,120,60,50);
		[valueButtonJ setTitle:@"J" forState:UIControlStateNormal];
		[valueButtonJ setBackgroundColor:[UIColor clearColor]];
		[valueButtonJ setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonJ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonJ.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonJ addTarget:self action:@selector(returnValueJ) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonJ];
		
		
		
		UIButton* valueButtonM = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonM = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonM.frame = CGRectMake(95,120,60,50);
		[valueButtonM setTitle:@"M" forState:UIControlStateNormal];
		[valueButtonM setBackgroundColor:[UIColor clearColor]];
		[valueButtonM setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonM.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonM addTarget:self action:@selector(returnValueM) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:valueButtonM];
		
		
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

- (void)returnValueCompetent {
	[self dismissWithClickedButtonIndex:1 animated:YES];
}
- (void)returnValueNotYetCompetent {
	[self dismissWithClickedButtonIndex:2 animated:YES];
}
- (void)returnValueJ {
	[self dismissWithClickedButtonIndex:3 animated:YES];
}
- (void)returnValueM {
	[self dismissWithClickedButtonIndex:4 animated:YES];
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
