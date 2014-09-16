//
//  StudentTrackerInstanceRecordCell.m
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerInstanceRecordCell.h"
#import "TrackerValueAlertView.h"
#import "TrackerCompetencyAlertView.h"
#import "TrackerAttendanceAlertView.h"


@implementation StudentTrackerInstanceRecordCell

@synthesize trackerScaleLabel;
@synthesize localInstanceRecordArray;
@synthesize buttonArray;
@synthesize cellValuesArray;
@synthesize localDateRecordArray;
@synthesize studentNameBackground;
@synthesize parentStudentTrackerController;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
	cellValuesArray = [[NSMutableArray alloc] initWithCapacity:0];
	editingButton = 0;
	
	buttonArray = [[NSMutableArray alloc] initWithCapacity:0];

	
	hiddenKeyboardCloseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
    return self;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex != 0) {
	
		if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"C/NYC"]) {
	
			if (buttonIndex == 1) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"C" forState:UIControlStateNormal];
			} else if (buttonIndex == 2) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"NYC" forState:UIControlStateNormal];
			} else if (buttonIndex == 3) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"J" forState:UIControlStateNormal];
			} else if (buttonIndex == 4) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"M" forState:UIControlStateNormal];
			} else if (buttonIndex == 99) {
				[[buttonArray objectAtIndex:editingButton]	setTitle:@"" forState:UIControlStateNormal];
			} 
			
		} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"Attendance"]) {
		
			if (buttonIndex == 1) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"P" forState:UIControlStateNormal];
			} else if (buttonIndex == 2) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"A" forState:UIControlStateNormal];
			} else if (buttonIndex == 3) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"S" forState:UIControlStateNormal];
			} else if (buttonIndex == 4) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"L" forState:UIControlStateNormal];
			} else if (buttonIndex == 5) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"T" forState:UIControlStateNormal];
			} else if (buttonIndex == 6) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"S" forState:UIControlStateNormal];
			} else if (buttonIndex == 99) {
				[[buttonArray objectAtIndex:editingButton]	setTitle:@"" forState:UIControlStateNormal];
			}
		} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"A+"]) {
		
			if (buttonIndex == 1) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"A" forState:UIControlStateNormal];
			} else if (buttonIndex == 11) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"A-" forState:UIControlStateNormal];
			} else if (buttonIndex == 12) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"A+" forState:UIControlStateNormal];
			} else if (buttonIndex == 2) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"B" forState:UIControlStateNormal];
			} else if (buttonIndex == 21) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"B-" forState:UIControlStateNormal];
			} else if (buttonIndex == 22) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"B+" forState:UIControlStateNormal];
			} else if (buttonIndex == 3) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"C" forState:UIControlStateNormal];
			} else if (buttonIndex == 31) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"C-" forState:UIControlStateNormal];
			} else if (buttonIndex == 32) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"C+" forState:UIControlStateNormal];
			} else if (buttonIndex == 4) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"D" forState:UIControlStateNormal];
			} else if (buttonIndex == 41) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"D-" forState:UIControlStateNormal];
			} else if (buttonIndex == 42) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"D+" forState:UIControlStateNormal];
			} else if (buttonIndex == 5) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"E" forState:UIControlStateNormal];
			} else if (buttonIndex == 51) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"E-" forState:UIControlStateNormal];
			} else if (buttonIndex == 52) {
				[[buttonArray objectAtIndex:editingButton] setTitle:@"E+" forState:UIControlStateNormal];
			}	else if (buttonIndex == 99) {
				[[buttonArray objectAtIndex:editingButton]	setTitle:@"" forState:UIControlStateNormal];
			}
		}
		
		[self saveValuesArrayIntoDatabase];
	
		} else if (buttonIndex == -1) {
			// buttonIndex == -1, therefore clear button was pressed, therefore clear the value and save.
			[[buttonArray objectAtIndex:editingButton] setTitle:@"" forState:UIControlStateNormal];
			[self saveValuesArrayIntoDatabase];
		} else {
		// buttonIndex == 0, therefore clear button was pressed, therefore do nothing
		
		}
}



- (void)setTrackerValueForColumnRepresentedBySender:(id)sender {
	
	int editingColumnNumber = 0;
	
	editingColumnNumber = [sender tag];
	
	if ([cellValuesArray count] > editingColumnNumber) {
		[self showScaleSelectorAlert:editingColumnNumber]; // tag relates to a 'normal' column cell, so display the editing code
	} else {
		// tag relates to the 'add column' cell, so do nothing
	}
}




- (void)showScaleSelectorAlert:(int)forWeekday {
	
			editingButton = forWeekday;
	
	NSLog(@"Field Tapped For Weekday %i, current value %@", forWeekday, [[buttonArray objectAtIndex:editingButton] titleForState:UIControlStateNormal]);
	
	if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"C/NYC"]) {
	
		// build custom view to display
		TrackerCompetencyAlertView *alert = [[TrackerCompetencyAlertView alloc] initWithTitle:@"\r\r\r\r\r\r\r" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		alert.delegate = self;
		[alert show];
		[alert release];
					
		
	} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"Attendance"]) {
		// if no value already, set the value to 'Present'
		// otherwise display the alert
		if ([[[buttonArray objectAtIndex:editingButton] titleForState:UIControlStateNormal] isEqualToString:@""]) {
			
			[[buttonArray objectAtIndex:editingButton] setTitle:@"P" forState:UIControlStateNormal];
			[self saveValuesArrayIntoDatabase];
		} else {
			// build custom view to display
			TrackerAttendanceAlertView *alert = [[TrackerAttendanceAlertView alloc] initWithTitle:@"\r\r\r\r\r\r\r" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
			alert.delegate = self;
			[alert show];
			[alert release];
		}
		
	} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"A+"]) {
			
			// build custom view to display
			TrackerValueAlertView *alert = [[TrackerValueAlertView alloc] initWithTitle:@"\r\r\r\r\r\r\r" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
			
			alert.delegate = self;
			
			[alert show];
			[alert release];
			
	} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"Custom"]) {
		
		// create a UITextField object, size it to the size of the button just pressed, then activate it for editing
		// this will display the keyboard to accept the custom input
		// use the UITextFieldDelegate functions to save the result and release the UITextField object
		[[buttonArray objectAtIndex:editingButton] setTitle:@"" forState:UIControlStateNormal];
		
		UITextField* customValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(85*editingButton,12,85,20)];
		customValueTextField.delegate = self;
		customValueTextField.returnKeyType = UIReturnKeyDone;
		[customValueTextField setFont:[UIFont systemFontOfSize:12]];
		customValueTextField.textColor = [UIColor blueColor];
		customValueTextField.textAlignment = UITextAlignmentCenter;
		customValueTextField.text = [[buttonArray objectAtIndex:editingButton] titleLabel].text;
		[self addSubview:customValueTextField];
		//[customValueTextField release];
		
		[parentStudentTrackerController shrinkTableViewsForKeyboardAndScrollToRow:rowNumberInParentTable];
		
		
		[customValueTextField becomeFirstResponder];
		
	} else if ([[localInstanceRecordArray objectAtIndex:3] isEqualToString:@"Numeric"]) {
		
		// create a UITextField object, size it to the size of the button just pressed, then activate it for editing
		// this will display the keyboard to accept the custom input
		// use the UITextFieldDelegate functions to save the result and release the UITextField object
		[[buttonArray objectAtIndex:editingButton] setTitle:@"" forState:UIControlStateNormal];
		
		UITextField* customValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(85*editingButton,12,85,20)];
		customValueTextField.delegate = self;
		customValueTextField.returnKeyType = UIReturnKeyDone;
		customValueTextField.keyboardType = UIKeyboardTypeNumberPad;
		[customValueTextField setFont:[UIFont systemFontOfSize:12]];
		customValueTextField.textColor = [UIColor blueColor];
		customValueTextField.textAlignment = UITextAlignmentCenter;
		customValueTextField.text = [[buttonArray objectAtIndex:editingButton] titleLabel].text;
		[self addSubview:customValueTextField];
		
		currentlyEditingTextField = customValueTextField;
		//[customValueTextField release];
		
		hiddenKeyboardCloseButton.frame = CGRectMake(85*editingButton,12,85,20);
		[hiddenKeyboardCloseButton setTitle:@"" forState:UIControlStateNormal];
		[hiddenKeyboardCloseButton setBackgroundColor:[UIColor clearColor]];	
		[hiddenKeyboardCloseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[hiddenKeyboardCloseButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[hiddenKeyboardCloseButton addTarget:self action:@selector(manuallyRequestClosureOfCurrentlyEditingTextField) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:hiddenKeyboardCloseButton];
		
		
		
		[parentStudentTrackerController shrinkTableViewsForKeyboardAndScrollToRow:rowNumberInParentTable];
		
		[customValueTextField becomeFirstResponder];
		
		
		// check whether the done button message has been shown previously, if not show the message
		BOOL hasShownTapValueToCloseKeyboardMessage = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownTapValueToCloseKeyboardMessage"];
		
		// show first launch message if not already shown
		if (!hasShownTapValueToCloseKeyboardMessage) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Numeric Keyboard" message:@"To close the numeric keyboard after entering a value, simply tap the value you are editing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			
			hasShownTapValueToCloseKeyboardMessage = YES;
			[[NSUserDefaults standardUserDefaults] setBool:hasShownTapValueToCloseKeyboardMessage forKey:@"hasShownTapValueToCloseKeyboardMessage"];
		}
		
	}
	
	
	
}


- (void)manuallyRequestClosureOfCurrentlyEditingTextField {
	
	[currentlyEditingTextField resignFirstResponder];
	[currentlyEditingTextField removeFromSuperview];
	[parentStudentTrackerController expandTableViewsForKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];	
	[parentStudentTrackerController expandTableViewsForKeyboard];
	return YES;
	
}	

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	NSLog(@"Text Field Returned Value: %@", textField.text);
	
	int calculatedEditingButton = textField.frame.origin.x / 85;
	[[buttonArray objectAtIndex:calculatedEditingButton] setTitle:textField.text forState:UIControlStateNormal];
	
	[textField removeFromSuperview];
	[self saveValuesArrayIntoDatabase];
	
	[hiddenKeyboardCloseButton removeFromSuperview];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseValuesArrayAndPopulateColumns {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	while ([cellValuesArray count] > 0) {
		[cellValuesArray removeLastObject];
	}
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT recordValue FROM studentTrackerInstanceRecord WHERE studentTrackerID = ? AND studentID = ? AND studentTrackerDateID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int columnNumber = 0;
			
			while ([localDateRecordArray count] > columnNumber) {
			
			// Bind the variables.
			sqlite3_bind_int(statement, 1, trackerID);
			sqlite3_bind_int(statement, 2, [[localInstanceRecordArray objectAtIndex:2] intValue]);
			sqlite3_bind_int(statement, 3, [[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue]);
				
			//NSLog(@"SELECT recordValue FROM studentTrackerInstanceRecord WHERE studentTrackerID = %i AND studentID = %i AND studentTrackerDateID = %i", trackerID, [[localInstanceRecordArray objectAtIndex:2] intValue],[[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue]);
			
			// Execute the query.
			int success =sqlite3_step(statement);
			
				char *str = (char *)sqlite3_column_text(statement, 0);
				
				[cellValuesArray addObject:(str) ? [NSString stringWithUTF8String:str] : @""];
				//NSLog(@"cellValuesArray now contains %i rows, last import %@", [cellValuesArray count], [cellValuesArray lastObject]);
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
				columnNumber +=1;
			}
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[pool release];
	
	
	[self createButtonsForCellValues];
	
	
}

-(void)createButtonsForCellValues {
	
	// loop through the localDateRecordArray and create a new button for each instance in the array
	// add the buttons into the buttonArray so they can be referenced later
	
	while ([buttonArray count] > 0) {
		[[buttonArray lastObject] removeFromSuperview];
		[buttonArray removeLastObject];
	}
	
	int i = 0;
	
	while ([cellValuesArray count] > i) {
		
		UIButton* cellButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		cellButton.frame = CGRectMake(85*i, 0, 85, 40);
		[cellButton setTitle:[cellValuesArray objectAtIndex:i] forState:UIControlStateNormal];
		[cellButton setBackgroundColor:[UIColor whiteColor]];
		[cellButton setBackgroundImage:[UIImage imageNamed:@"weeklyPlannerCellCream.png"] forState:UIControlStateNormal];
		[cellButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[cellButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
		cellButton.tag = i;
		[cellButton addTarget:self action:@selector(setTrackerValueForColumnRepresentedBySender:) forControlEvents:UIControlEventTouchUpInside];
		[buttonArray addObject:cellButton];
		[self.contentView addSubview:cellButton];
		//[cellButton release];
		
		i +=1;
		
	}
	
	
	UIButton* addColumnCellButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	addColumnCellButton.frame = CGRectMake(85*i, 0, 85, 40);
	[addColumnCellButton setTitle:@"" forState:UIControlStateNormal];
	[addColumnCellButton setBackgroundColor:[UIColor whiteColor]];
	[addColumnCellButton setBackgroundImage:[UIImage imageNamed:@"weeklyPlannerCellCream.png"] forState:UIControlStateNormal];
	[addColumnCellButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	[addColumnCellButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	addColumnCellButton.tag = i;
	[addColumnCellButton addTarget:self action:@selector(setTrackerValueForColumnRepresentedBySender:) forControlEvents:UIControlEventTouchUpInside];
	[buttonArray addObject:addColumnCellButton];
	[self.contentView addSubview:addColumnCellButton];
	//[cellButton release];
	

	
	
}

- (void)setRowColourScheme:(BOOL)asOddRow {
	
	if (asOddRow) { 		
		// row is odd, colour cream with white period name
		int i = 0;
		while ([buttonArray count] > i) {
			[[buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"weeklyPlannerCellCream.png"] forState:UIControlStateNormal];
			i +=1;
			
		}
		
		
	} else { // this is an even row
		// row is even, colour grey gradient with blue period name
		
		int i = 0;
		while ([buttonArray count] > i) {
			[[buttonArray objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"weeklyPlannerCellGradient.png"] forState:UIControlStateNormal];
			i +=1;
			
		}
		
		
	}
	
}




- (void)saveValuesArrayIntoDatabase {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerID = ? AND studentID = ? AND studentTrackerDateID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int columnNumber = 0;
			
			while (columnNumber < [localDateRecordArray count]) {
				
				// Bind the variables.
				sqlite3_bind_int(statement, 1, trackerID);
				sqlite3_bind_int(statement, 2, [[localInstanceRecordArray objectAtIndex:2] intValue]);
				sqlite3_bind_int(statement, 3, [[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue]);
								
				// Execute the query.
				int success =sqlite3_step(statement);
				
				NSLog(@"DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerID = %i AND studentID = %i AND studentTrackerDateID = %i",trackerID,[[localInstanceRecordArray objectAtIndex:2] intValue],[[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue]);
				
				
				// Reset the query for the next use.
				sqlite3_reset(statement);
				columnNumber +=1;
			}
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "INSERT INTO studentTrackerInstanceRecord VALUES (?,?,?,?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int columnNumber = 0;
			
			while (columnNumber < [localDateRecordArray count]) {
				
				// Bind the variables.
				sqlite3_bind_int(statement, 1, trackerID);
				sqlite3_bind_int(statement, 2, [[localInstanceRecordArray objectAtIndex:2] intValue]);
				sqlite3_bind_int(statement, 3, [[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue]);

				sqlite3_bind_text(statement, 4, [[[buttonArray objectAtIndex:columnNumber] titleForState:UIControlStateNormal] UTF8String], -1, SQLITE_TRANSIENT); //value
				
				
				// Execute the query.
				int success =sqlite3_step(statement);
				
				NSLog(@"INSERT INTO studentTrackerInstanceRecord VALUES (%i,%i,%i,%@)",trackerID,[[localInstanceRecordArray objectAtIndex:2] intValue],[[[localDateRecordArray objectAtIndex:columnNumber] objectAtIndex:0] intValue],[[buttonArray objectAtIndex:columnNumber] titleForState:UIControlStateNormal]);
				
				
				// Reset the query for the next use.
				sqlite3_reset(statement);
				columnNumber +=1;
			}
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	[pool release];
	
}


- (void)setTrackerID:(int)withID {
	trackerID = withID;
}

- (void)setRowNumberInParentTable:(int)withRowNumber {
	rowNumberInParentTable = withRowNumber;
}

- (void)dealloc {
	[trackerScaleLabel release];
	[localInstanceRecordArray release];
	[buttonArray release];
	[cellValuesArray release];
	[localDateRecordArray release];
	[studentNameBackground release];
	[parentStudentTrackerController release];
    [super dealloc];
}


@end
