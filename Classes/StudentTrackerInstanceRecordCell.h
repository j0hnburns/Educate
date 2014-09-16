//
//  StudentTrackerInstanceRecordCell.h
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "StudentTrackerInstanceRecordViewController.h"


@interface StudentTrackerInstanceRecordCell : UITableViewCell <UIAlertViewDelegate, UITextFieldDelegate> {
	
	UILabel *trackerScaleLabel;
	NSMutableArray *localInstanceRecordArray;
	NSMutableArray *localDateRecordArray;
	NSMutableArray *buttonArray;
	NSMutableArray *cellValuesArray;
	
	StudentTrackerInstanceRecordViewController *parentStudentTrackerController;
	
	UIView *studentNameBackground;
	
	int editingButton;
	int trackerID;
	int rowNumberInParentTable;
    sqlite3 *educateDatabase;
	
	UITextField *currentlyEditingTextField;
	UIButton *hiddenKeyboardCloseButton;
	
}


- (void)showScaleSelectorAlert:(int)forWeekday;
- (void)initialiseValuesArrayAndPopulateColumns;
- (void)saveValuesArrayIntoDatabase;
- (void)setTrackerID:(int)withID;
- (void)createButtonsForCellValues;
- (void)setTrackerValueForColumnRepresentedBySender:(id)sender;
- (void)setRowColourScheme:(BOOL)asOddRow;
- (void)setRowNumberInParentTable:(int)withRowNumber;
- (void)manuallyRequestClosureOfCurrentlyEditingTextField;

@property (nonatomic, retain) UILabel *trackerScaleLabel;
@property (nonatomic, retain) NSMutableArray *localInstanceRecordArray;
@property (nonatomic, retain) NSMutableArray *localDateRecordArray;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *cellValuesArray;

@property (nonatomic, retain) StudentTrackerInstanceRecordViewController *parentStudentTrackerController;

@property (nonatomic, retain) UIView *studentNameBackground;


@end
