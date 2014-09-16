//
//  StudentTrackerStudentListNameEditorCell.m
//  Educate
//
//  Created by James Hodge on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerStudentListNameEditorCell.h"
#import "CustomNavigationHeaderThin.h"


@implementation StudentTrackerStudentListNameEditorCell

@synthesize studentNameField;
@synthesize studentFirstNameField;
@synthesize studentEmailField;
@synthesize studentPhone1Field;
@synthesize studentPhone2Field;
@synthesize guardianEmailField;
@synthesize studentParentNameField;
@synthesize localStudentNameArray;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
	parentIndexPathRow = 0;
	studentNameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 150.0, 50)];
	studentNameField.backgroundColor = [UIColor clearColor];
	studentNameField.textColor = [UIColor blackColor];
	studentNameField.textAlignment = UITextAlignmentLeft;
	studentNameField.font = [UIFont systemFontOfSize:20];
	studentNameField.borderStyle = UITextBorderStyleNone;
	[studentNameField addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentNameField.delegate = self;
	[studentNameField setReturnKeyType:UIReturnKeyDone];
	studentNameField.autocorrectionType=UITextAutocorrectionTypeNo;
	[self addSubview:studentNameField];	
	
	studentFirstNameField = [[UITextField alloc] initWithFrame:CGRectMake(160, 5, 150.0, 50)];
	studentFirstNameField.backgroundColor = [UIColor clearColor];
	studentFirstNameField.textColor = [UIColor blackColor];
	studentFirstNameField.textAlignment = UITextAlignmentLeft;
	studentFirstNameField.font = [UIFont systemFontOfSize:20];
	studentFirstNameField.borderStyle = UITextBorderStyleNone;
	[studentFirstNameField addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentFirstNameField.delegate = self;
	[studentFirstNameField setReturnKeyType:UIReturnKeyDone];
	studentFirstNameField.autocorrectionType=UITextAutocorrectionTypeNo;
	[self addSubview:studentFirstNameField];	
	
	studentEmailField = [[UITextField alloc] initWithFrame:CGRectMake(310, 5, 250.0, 50)];
	studentEmailField.backgroundColor = [UIColor clearColor];
	studentEmailField.textColor = [UIColor blackColor];
	studentEmailField.textAlignment = UITextAlignmentLeft;
	studentEmailField.font = [UIFont systemFontOfSize:20];
	studentEmailField.borderStyle = UITextBorderStyleNone;
	[studentEmailField addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentEmailField.delegate = self;
	[studentEmailField setReturnKeyType:UIReturnKeyDone];
	studentEmailField.autocorrectionType=UITextAutocorrectionTypeNo;
	studentEmailField.keyboardType=UIKeyboardTypeEmailAddress;
	[self addSubview:studentEmailField];	
	
	studentPhone1Field = [[UITextField alloc] initWithFrame:CGRectMake(560, 5, 250.0, 50)];
	studentPhone1Field.backgroundColor = [UIColor clearColor];
	studentPhone1Field.textColor = [UIColor blackColor];
	studentPhone1Field.textAlignment = UITextAlignmentLeft;
	studentPhone1Field.font = [UIFont systemFontOfSize:20];
	studentPhone1Field.borderStyle = UITextBorderStyleNone;
	[studentPhone1Field addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentPhone1Field.delegate = self;
	[studentPhone1Field setReturnKeyType:UIReturnKeyDone];
	studentPhone1Field.autocorrectionType=UITextAutocorrectionTypeNo;
	studentPhone1Field.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
	[self addSubview:studentPhone1Field];		
	
	studentParentNameField = [[UITextField alloc] initWithFrame:CGRectMake(810, 5, 250.0, 50)];
	studentParentNameField.backgroundColor = [UIColor clearColor];
	studentParentNameField.textColor = [UIColor blackColor];
	studentParentNameField.textAlignment = UITextAlignmentLeft;
	studentParentNameField.font = [UIFont systemFontOfSize:20];
	studentParentNameField.borderStyle = UITextBorderStyleNone;
	[studentParentNameField addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentParentNameField.delegate = self;
	[studentParentNameField setReturnKeyType:UIReturnKeyDone];
	studentParentNameField.autocorrectionType=UITextAutocorrectionTypeNo;
	studentParentNameField.keyboardType=UIKeyboardTypeDefault;
	[self addSubview:studentParentNameField];	
	
	guardianEmailField = [[UITextField alloc] initWithFrame:CGRectMake(1060, 5, 250.0, 50)];
	guardianEmailField.backgroundColor = [UIColor clearColor];
	guardianEmailField.textColor = [UIColor blackColor];
	guardianEmailField.textAlignment = UITextAlignmentLeft;
	guardianEmailField.font = [UIFont systemFontOfSize:20];
	guardianEmailField.borderStyle = UITextBorderStyleNone;
	[guardianEmailField addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	guardianEmailField.delegate = self;
	[guardianEmailField setReturnKeyType:UIReturnKeyDone];
	guardianEmailField.autocorrectionType=UITextAutocorrectionTypeNo;
	guardianEmailField.keyboardType=UIKeyboardTypeEmailAddress;
	[self addSubview:guardianEmailField];
	
	studentPhone2Field = [[UITextField alloc] initWithFrame:CGRectMake(1310, 5, 250.0, 50)];
	studentPhone2Field.backgroundColor = [UIColor clearColor];
	studentPhone2Field.textColor = [UIColor blackColor];
	studentPhone2Field.textAlignment = UITextAlignmentLeft;
	studentPhone2Field.font = [UIFont systemFontOfSize:20];
	studentPhone2Field.borderStyle = UITextBorderStyleNone;
	[studentPhone2Field addTarget:self action:@selector(scrollViewForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	studentPhone2Field.delegate = self;
	[studentPhone2Field setReturnKeyType:UIReturnKeyDone];
	studentPhone2Field.autocorrectionType=UITextAutocorrectionTypeNo;
	studentPhone2Field.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
	[self addSubview:studentPhone2Field];

	
    return self;
}


- (void)setTablePointers:(StudentTrackerStudentListTableViewController *)withTableView andIndexPathRow:(int)localIndexPathRow {
	
	parentIndexPathRow = localIndexPathRow;
	parentTableView = withTableView;
	//NSLog(@"setTablePointers for row %i", [localIndexPathRow intValue]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	NSLog(@"textFieldShouldReturn for row %i", parentIndexPathRow);
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == studentNameField) {
		[studentNameField resignFirstResponder];
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentNameField.text);
		[localStudentNameArray replaceObjectAtIndex:1 withObject:studentNameField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		
		
	} else if (theTextField == studentFirstNameField) {
		[studentFirstNameField resignFirstResponder];
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentFirstNameField.text);
		[localStudentNameArray replaceObjectAtIndex:3 withObject:studentFirstNameField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		
		
	} else if (theTextField == studentEmailField) {
		[studentEmailField resignFirstResponder];
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentEmailField.text);
		[localStudentNameArray replaceObjectAtIndex:4 withObject:studentEmailField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		
		
	}
	
 else if (theTextField == studentPhone1Field) {
	[studentPhone1Field resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentPhone1Field.text);
	[localStudentNameArray replaceObjectAtIndex:5 withObject:studentPhone1Field.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
	
}

 else if (theTextField == studentPhone2Field) {
	[studentPhone2Field resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentPhone2Field.text);
	[localStudentNameArray replaceObjectAtIndex:6 withObject:studentPhone2Field.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
	
}

 else if (theTextField == studentParentNameField) {
	[studentParentNameField resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentParentNameField.text);
	[localStudentNameArray replaceObjectAtIndex:7 withObject:studentParentNameField.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
	
 }
	
 else if (theTextField == guardianEmailField) {
	 [guardianEmailField resignFirstResponder];
	 NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],guardianEmailField.text);
	 [localStudentNameArray replaceObjectAtIndex:8 withObject:guardianEmailField.text];
	 parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	 
	 
	 
 }
	
	return YES;
	
}	
- (void)textFieldDidEndEditing:(UITextField *)theTextField {
	NSLog(@"textFieldShouldEndEditing for row %i", parentIndexPathRow);
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == studentNameField) {
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentNameField.text);
		[localStudentNameArray replaceObjectAtIndex:1 withObject:studentNameField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		//[self release];
		
	} else if (theTextField == studentFirstNameField) {
		[studentFirstNameField resignFirstResponder];
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentFirstNameField.text);
		[localStudentNameArray replaceObjectAtIndex:3 withObject:studentFirstNameField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		
		//[self release];
		
	} else if (theTextField == studentEmailField) {
		[studentEmailField resignFirstResponder];
		
		//[[[appDelegate studentTrackerArray] objectAtIndex:[trackerID integerValue]] replaceObjectAtIndex:1 withObject:trackerNameField.text];
		NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentEmailField.text);
		[localStudentNameArray replaceObjectAtIndex:4 withObject:studentEmailField.text];
		parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
		
		
		//[self release];
		
	}
	
 else if (theTextField == studentPhone1Field) {
	[studentPhone1Field resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentPhone1Field.text);
	[localStudentNameArray replaceObjectAtIndex:5 withObject:studentPhone1Field.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
	//[self release];
	
}

 else if (theTextField == studentPhone2Field) {
	[studentPhone2Field resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentPhone2Field.text);
	[localStudentNameArray replaceObjectAtIndex:6 withObject:studentPhone2Field.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
//[self release];
	
}

 else if (theTextField == studentParentNameField) {
	[studentParentNameField resignFirstResponder];
	NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],studentParentNameField.text);
	[localStudentNameArray replaceObjectAtIndex:7 withObject:studentParentNameField.text];
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	
	
	//[self release];
	
 }
	
 else if (theTextField == guardianEmailField) {
	 [guardianEmailField resignFirstResponder];
	 NSLog(@"Updating cell %@ with %@",[localStudentNameArray objectAtIndex:0],guardianEmailField.text);
	 [localStudentNameArray replaceObjectAtIndex:8 withObject:guardianEmailField.text];
	 parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,290);
	 
	 
	 //[self release];
	 
 }
	
	
}	
- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {
	
	NSLog(@"textFieldShouldBeginEditing for row %i", parentIndexPathRow);
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == studentNameField) {
		if ([studentNameField.text isEqualToString:@"Student"]) {
			studentNameField.text = @"";
		}
		
		[self retain];
		
	} else if (theTextField == studentFirstNameField) {
		if ([studentFirstNameField.text isEqualToString:@"New"]) {
			studentFirstNameField.text = @"";
		}
		
		[self retain];
		
	} else if (theTextField == studentEmailField) {
		if ([studentEmailField.text isEqualToString:@""]) {
			studentEmailField.text = @"";
		}
		
		[self retain];
		
	}
	
	return YES;
	
}	

- (void)scrollViewForKeyboard {
	NSLog(@"scrollViewForKeyboard pending");
	NSLog(@"scrollViewForKeyboard %i", parentIndexPathRow);
	parentTableView.trackerTableView.frame = CGRectMake(0,110,1560,60);
	
	//[parentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[parentIndexPathRow intValue] inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	[parentTableView setCurrentlyEditingRowAndScroll:parentIndexPathRow];
	
}

- (void)dealloc {
	//[studentNameField release];
	//[studentNameFirstField release];
	//[studentEmailField release];
	//[localStudentNameArray release];
	//[parentIndexPathRow release];
    [super dealloc];
}


@end
