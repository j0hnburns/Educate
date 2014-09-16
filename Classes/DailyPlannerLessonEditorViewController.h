//
//  DailyPlannerLessonEditorViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeader.h"


@interface DailyPlannerLessonEditorViewController : UIViewController <UITextFieldDelegate> {
	
	NSNumber *periodID;
	UITextField *periodNameField;
	UISegmentedControl *periodTypeSelector;
	NSMutableArray *localPeriodArray;
	CustomNavigationHeader *customNavHeader;
	
}

- (void)changePeriodType;
- (void)callPopBackToPreviousView;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)slideViewUpForKeyboard;


@property (nonatomic, retain) NSNumber *periodID;
@property (nonatomic, retain) UITextField *periodNameField;
@property (nonatomic, retain) UISegmentedControl *periodTypeSelector;
@property (nonatomic, retain) NSMutableArray *localPeriodArray;
@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;

@end
