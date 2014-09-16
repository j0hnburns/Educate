//
//  StudentTrackerStudentListNameEditorCell.h
//  Educate
//
//  Created by James Hodge on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentTrackerStudentListTableViewController.h"

@interface StudentTrackerStudentListNameEditorCell : UITableViewCell <UITextFieldDelegate> {
	
	UITextField *studentNameField;
	UITextField *studentFirstNameField;
	UITextField *studentEmailField;
	UITextField *studentPhone1Field;
	UITextField *studentPhone2Field;
	UITextField *studentParentNameField;
	UITextField *guardianEmailField;
	int studentTrackerStudentListArrayRowNumber;	
	NSMutableArray *localStudentNameArray;
	StudentTrackerStudentListTableViewController *parentTableView;
	NSIndexPath *parentIndexPath;
	int parentIndexPathRow;

}

- (void)scrollViewForKeyboard;
- (void)setTablePointers:(StudentTrackerStudentListTableViewController *)withTableView andIndexPathRow:(int)localIndexPathRow;


@property (nonatomic, retain) UITextField *studentNameField;
@property (nonatomic, retain) UITextField *studentFirstNameField;
@property (nonatomic, retain) UITextField *studentEmailField;
@property (nonatomic, retain) UITextField *studentPhone1Field;
@property (nonatomic, retain) UITextField *studentPhone2Field;
@property (nonatomic, retain) UITextField *studentParentNameField;
@property (nonatomic, retain) UITextField *guardianEmailField;
@property (nonatomic, retain) NSMutableArray *localStudentNameArray;


@end
