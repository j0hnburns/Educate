//
//  TrackerValueAlertView.m
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackerValueAlertView.h"


@implementation TrackerValueAlertView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		UIImageView* valueSelectorBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trackerPopup_background.png"]];	
		valueSelectorBackground.frame = CGRectMake(0,0,264,243);
		[self addSubview:valueSelectorBackground];
		[valueSelectorBackground release];
		
		valueButtonA = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonA.frame = CGRectMake(35,70,60,50);
		[valueButtonA setTitle:@"A" forState:UIControlStateNormal];
		[valueButtonA setBackgroundColor:[UIColor clearColor]];
		[valueButtonA setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonA.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonA addTarget:self action:@selector(popModifiersForA) forControlEvents:UIControlEventTouchUpInside];
		[valueButtonA addTarget:self action:@selector(popModifiersForA) forControlEvents:UIControlEventTouchDragOutside];
		[self addSubview:valueButtonA];
		
		valueButtonB = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonB.frame = CGRectMake(95,70,60,50);
		[valueButtonB setTitle:@"B" forState:UIControlStateNormal];
		[valueButtonB setBackgroundColor:[UIColor clearColor]];
		[valueButtonB setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonB.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonB addTarget:self action:@selector(popModifiersForB) forControlEvents:UIControlEventTouchUpInside];
		[valueButtonB addTarget:self action:@selector(popModifiersForB) forControlEvents:UIControlEventTouchDragOutside];
		[self addSubview:valueButtonB];
		
		valueButtonC = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonC.frame = CGRectMake(155,70,60,50);
		[valueButtonC setTitle:@"C" forState:UIControlStateNormal];
		[valueButtonC setBackgroundColor:[UIColor clearColor]];
		[valueButtonC setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonC.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonC addTarget:self action:@selector(popModifiersForC) forControlEvents:UIControlEventTouchUpInside];
		[valueButtonC addTarget:self action:@selector(popModifiersForC) forControlEvents:UIControlEventTouchDragOutside];
		[self addSubview:valueButtonC];
		
		valueButtonD = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonD.frame = CGRectMake(35,120,60,50);
		[valueButtonD setTitle:@"D" forState:UIControlStateNormal];
		[valueButtonD setBackgroundColor:[UIColor clearColor]];
		[valueButtonD setBackgroundImage:[UIImage imageNamed:@"trackerPopup_blueButton.png"] forState:UIControlStateNormal];	
		[valueButtonD setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonD.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonD addTarget:self action:@selector(popModifiersForD) forControlEvents:UIControlEventTouchUpInside];
		[valueButtonD addTarget:self action:@selector(popModifiersForD) forControlEvents:UIControlEventTouchDragOutside];
		[self addSubview:valueButtonD];
		
		valueButtonE = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		valueButtonE.frame = CGRectMake(95,120,60,50);
		[valueButtonE setTitle:@"E" forState:UIControlStateNormal];
		[valueButtonE setBackgroundColor:[UIColor clearColor]];
		[valueButtonE setBackgroundImage:[UIImage imageNamed:@"trackerPopup_greenButton.png"] forState:UIControlStateNormal];	
		[valueButtonE setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[valueButtonE.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[valueButtonE addTarget:self action:@selector(popModifiersForE) forControlEvents:UIControlEventTouchUpInside];
		[valueButtonE addTarget:self action:@selector(popModifiersForE) forControlEvents:UIControlEventTouchDragOutside];
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

- (void)returnValueA {
	[self dismissWithClickedButtonIndex:1 animated:YES];
}
- (void)returnValueAPlus {
	[self dismissWithClickedButtonIndex:11 animated:YES];
}
- (void)returnValueAMinus {
	[self dismissWithClickedButtonIndex:12 animated:YES];
}
- (void)returnValueB {
	[self dismissWithClickedButtonIndex:2 animated:YES];
}
- (void)returnValueBPlus {
	[self dismissWithClickedButtonIndex:21 animated:YES];
}
- (void)returnValueBMinus {
	[self dismissWithClickedButtonIndex:22 animated:YES];
}
- (void)returnValueC {
	[self dismissWithClickedButtonIndex:3 animated:YES];
}
- (void)returnValueCPlus {
	[self dismissWithClickedButtonIndex:31 animated:YES];
}
- (void)returnValueCMinus {
	[self dismissWithClickedButtonIndex:32 animated:YES];
}
- (void)returnValueD {
	[self dismissWithClickedButtonIndex:4 animated:YES];
}
- (void)returnValueDPlus {
	[self dismissWithClickedButtonIndex:41 animated:YES];
}
- (void)returnValueDMinus {
	[self dismissWithClickedButtonIndex:42 animated:YES];
}
- (void)returnValueE {
	[self dismissWithClickedButtonIndex:5 animated:YES];
}
- (void)returnValueEPlus {
	[self dismissWithClickedButtonIndex:51 animated:YES];
}
- (void)returnValueEMinus {
	[self dismissWithClickedButtonIndex:52 animated:YES];
}
- (void)cancelAndReturn {
	[self dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)clearAndReturn {
	[self dismissWithClickedButtonIndex:99 animated:YES];
}

- (void)popModifiersForA {
	// hide other buttons and re-label buttons for A modifier
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[valueButtonA setTitle:@"A+" forState:UIControlStateNormal];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:@selector(returnValueAMinus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonB setTitle:@"A" forState:UIControlStateNormal];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:@selector(returnValueA) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonC setTitle:@"A-" forState:UIControlStateNormal];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:@selector(returnValueAPlus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	
	valueButtonD.hidden = YES;
	valueButtonE.hidden = YES;

	[UIView commitAnimations];
		
}
- (void)popModifiersForB {
	// hide other buttons and re-label buttons for B modifier
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[valueButtonA setTitle:@"B +" forState:UIControlStateNormal];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:@selector(returnValueBMinus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonB setTitle:@"B" forState:UIControlStateNormal];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:@selector(returnValueB) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonC setTitle:@"B-" forState:UIControlStateNormal];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:@selector(returnValueBPlus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	
	valueButtonD.hidden = YES;
	valueButtonE.hidden = YES;
	
	[UIView commitAnimations];
	
}

- (void)popModifiersForC {
	// hide other buttons and re-label buttons for C modifier
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[valueButtonA setTitle:@"C+" forState:UIControlStateNormal];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:@selector(returnValueCMinus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonB setTitle:@"C" forState:UIControlStateNormal];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:@selector(returnValueC) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonC setTitle:@"C-" forState:UIControlStateNormal];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:@selector(returnValueCPlus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	
	valueButtonD.hidden = YES;
	valueButtonE.hidden = YES;
	
	[UIView commitAnimations];
	
}

- (void)popModifiersForD {
	// hide other buttons and re-label buttons for D modifier
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[valueButtonA setTitle:@"D+" forState:UIControlStateNormal];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:@selector(returnValueDMinus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonB setTitle:@"D" forState:UIControlStateNormal];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:@selector(returnValueD) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonC setTitle:@"D-" forState:UIControlStateNormal];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:@selector(returnValueDPlus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	
	valueButtonD.hidden = YES;
	valueButtonE.hidden = YES;
	
	[UIView commitAnimations];
	
}
- (void)popModifiersForE {
	// hide other buttons and re-label buttons for E modifier
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[valueButtonA setTitle:@"E+" forState:UIControlStateNormal];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:@selector(returnValueEMinus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonA addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonB setTitle:@"E" forState:UIControlStateNormal];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:@selector(returnValueE) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonB addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	[valueButtonC setTitle:@"E-" forState:UIControlStateNormal];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:@selector(returnValueEPlus) forControlEvents:UIControlEventTouchUpInside];
	[valueButtonC addTarget:self action:nil forControlEvents:UIControlEventTouchDragOutside];
	
	valueButtonD.hidden = YES;
	valueButtonE.hidden = YES;
	
	[UIView commitAnimations];
	
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
}



- (void)dealloc {
    [super dealloc];
}


@end
