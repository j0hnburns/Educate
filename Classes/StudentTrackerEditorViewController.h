//
//  StudentTrackerEditorViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeader.h"


@interface StudentTrackerEditorViewController : UIViewController <UITextFieldDelegate> {
	
	NSNumber *trackerID;
	UITextField *trackerNameField;
	UISegmentedControl *trackerScaleSelector;
	UIButton *editStudentsButton;
	NSMutableArray *localStudentTrackerInstanceArray;
    sqlite3 *educateDatabase;
	CustomNavigationHeader *customNavHeader;

	
}

- (void)changeScaleType;
- (void)editStudentList;
- (void)callPopBackToPreviousView;


@property (nonatomic, retain) NSNumber *trackerID;
@property (nonatomic, retain) UITextField *trackerNameField;
@property (nonatomic, retain) UISegmentedControl *trackerScaleSelector;
@property (nonatomic, retain) UIButton *editStudentsButton;
@property (nonatomic, retain) NSMutableArray *localStudentTrackerInstanceArray;
@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;

@end
