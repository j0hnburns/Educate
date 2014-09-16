//
//  ELearningBookmarksNewBookmarkViewController.h
//  Educate
//
//  Created by James Hodge on 14/10/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeaderThin.h"
#import "ELearningBookmarksViewController.h"


@interface ELearningBookmarksNewBookmarkViewController : UIViewController <UITextFieldDelegate> {
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	
	UILabel *bookmarkNameLabel;
	UILabel *bookmarkURLLabel;
	UITextField *bookmarkNameField;
	UITextField *bookmarkURLField;
	
	UILabel *hintLabel;
	
	NSMutableArray *localBookmarkValueArray;
	int bookmarkArrayRowNumber;
	ELearningBookmarksViewController *parentELearningBookmarksViewController;
}

- (void)callPopBackToPreviousView;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)slideViewUpForKeyboard;
- (void)setBookmarkArrayRowNumber:(int)withInt;

@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;

@property (nonatomic, retain) UILabel *hintLabel;

@property (nonatomic, retain) UILabel *bookmarkNameLabel;
@property (nonatomic, retain) UILabel *bookmarkURLLabel;

@property (nonatomic, retain) UITextField *bookmarkNameField;
@property (nonatomic, retain) UITextField *bookmarkURLField;
@property (nonatomic, retain) NSMutableArray *localBookmarkValueArray;

@property (nonatomic, retain) ELearningBookmarksViewController *parentELearningBookmarksViewController;

@end
