//
//  ImageCreatorTextOverlay.h
//  Educate
//
//  Created by James Hodge on 27/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewPopUpEditorView.h"


@interface ImageCreatorTextOverlay : UIView <UITextViewDelegate> {

	NSString *labelString;
	UILabel *localLabel;
	TextViewPopUpEditorView *textViewPopUpEditorView;
	
}

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint;
- (void)startEditingLabelValue;

@property (nonatomic, retain) NSString *labelString;
@property (nonatomic, retain) UILabel *localLabel;
@property (nonatomic, retain) TextViewPopUpEditorView *textViewPopUpEditorView;

@end
