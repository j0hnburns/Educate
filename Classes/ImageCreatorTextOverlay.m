//
//  ImageCreatorTextOverlay.m
//  Educate
//
//  Created by James Hodge on 27/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageCreatorTextOverlay.h"
#import <QuartzCore/QuartzCore.h>
#import "TextViewPopUpEditorView.h"
#import "EducateAppDelegate.h"


@implementation ImageCreatorTextOverlay

@synthesize labelString;
@synthesize localLabel;
@synthesize textViewPopUpEditorView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		[self setUserInteractionEnabled:YES];
		labelString = @"New String";
		localLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
		localLabel.text = [NSString stringWithString:labelString];
		localLabel.backgroundColor = [UIColor clearColor];
		localLabel.textColor = [UIColor whiteColor];
		localLabel.textAlignment = UITextAlignmentCenter;
		localLabel.font = [UIFont boldSystemFontOfSize:17];
		localLabel.shadowColor = [UIColor blackColor];
		localLabel.shadowOffset = CGSizeMake(0,1);
		localLabel.numberOfLines = 0;
		[self addSubview:localLabel];
		[localLabel release];
		
		textViewPopUpEditorView = [[TextViewPopUpEditorView alloc] initWithNibName:nil bundle:nil];    
		textViewPopUpEditorView.title = @"Edit Tracker Heading";
		textViewPopUpEditorView.textView.text = labelString;
		textViewPopUpEditorView.textView.delegate = self;
		textViewPopUpEditorView.editingField = @"aboutMe";
		[textViewPopUpEditorView.view setAlpha:0.8];
		EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		
		[[appDelegate tabBarController] presentModalViewController:textViewPopUpEditorView animated:YES];
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	localLabel.text = textViewPopUpEditorView.textView.text;
	[localLabel sizeToFit];
	//self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, localLabel.frame.size.width, localLabel.frame.size.height);
	//localLabel.text = @"TEST";
}



- (void)startEditingLabelValue {
	
	
	//[textViewPopUpEditorView release];
	
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	NSLog(@"Touches Began");
		// In case of a double tap on the object, update the text string
		if ([touch tapCount] == 2) {
			// update text string by popping up the TextViewPopUpEditorView and sending it the text value of this view
			
			[self startEditingLabelValue];			
		}
		return;
	
	// Animate the first touch
	CGPoint touchPoint = [touch locationInView:nil];
	[self animateFirstTouchAtPoint:touchPoint];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
	
		CGPoint location = [touch locationInView:nil];
		self.center = location;		
		return;
	
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:nil];
	self.center = location;		
	return;
}


- (void)touchesCanceled {
	
	// Disable user interaction so subsequent touches don't interfere with animation
	self.userInteractionEnabled = NO;
	
}



- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
	
	/*
	 Create two separate animations, the first for the grow, which uses a delegate method as before to start an animation for the shrink operation. The second animation here lasts for the total duration of the grow and shrink animations and is responsible for performing the move.
	 */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	self.transform = transform;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS];
	self.center = touchPoint;
	[UIView commitAnimations];
}



- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	self.transform = CGAffineTransformMakeScale(1.1, 1.1);	
	[UIView commitAnimations];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	//Animation delegate method called when the animation's finished:
	// restore the transform and reenable user interaction
	self.transform = CGAffineTransformIdentity;
	self.userInteractionEnabled = YES;
}


- (void)dealloc {
	[labelString release];
	//[localLabel release];
	[textViewPopUpEditorView release];
    [super dealloc];
}


@end
