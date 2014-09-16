//
//  ELearningBrowserMoodleImagePostViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "ELearningBrowserMoodleImagePostViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeader.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					210.0

#define kTextFieldWidth							100.0	// initial width, but the table cell will dictact the actual width

// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.30

#define kUITextField_Section					0
#define kUITextField_Rounded_Custom_Section		1
#define kUITextField_Secure_Section				2


@implementation ELearningBrowserMoodleImagePostViewController

@synthesize periodID;
@synthesize weekday;
@synthesize periodTypeSelector;
@synthesize periodNameField;
@synthesize classroomField;
@synthesize notesView;
@synthesize notesViewBackground;
@synthesize showNotesHistoryButton;
@synthesize localPlannerSubjectArray;
@synthesize customNavHeader;
@synthesize saveEditButton;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		periodID = [NSNumber numberWithInteger:0];
		// navigation header
		
		currentlyEditing = NO;
		
		customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeader.viewHeader.text = @"Moodle";
		customNavHeader.upperSubHeading.text = @"Upload An Image";
		[self.view addSubview:customNavHeader];
		[customNavHeader release];
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 40);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		
		
		// Settings Fields & Labels
		
		UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		lowerViewBackground.frame = CGRectMake(0,134,320,328);
		[self.view addSubview:lowerViewBackground];
		[lowerViewBackground release];
		
		UILabel* labelPeriodName = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 144.0, 50.0, 30)];
		labelPeriodName.text = @"Subject:";
		labelPeriodName.backgroundColor = [UIColor clearColor];
		labelPeriodName.textColor = [UIColor darkGrayColor];
		labelPeriodName.textAlignment = UITextAlignmentLeft;
		labelPeriodName.font = [UIFont boldSystemFontOfSize:14];
		[self.view addSubview:labelPeriodName];
		//[labelPeriodName release];
		
		periodNameField = [[UITextField alloc] initWithFrame:CGRectMake(75, 144, 230.0, 30)];
		periodNameField.backgroundColor = [UIColor clearColor];
		periodNameField.textColor = [UIColor blackColor];
		periodNameField.textAlignment = UITextAlignmentLeft;
		periodNameField.borderStyle = UITextBorderStyleNone;
		periodNameField.userInteractionEnabled = NO;
		//[periodNameField addTarget:self action:@selector(slideViewUpForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
		periodNameField.delegate = self;
		[periodNameField setReturnKeyType:UIReturnKeyDone];
		periodNameField.autocorrectionType=UITextAutocorrectionTypeNo;
		[self.view addSubview:periodNameField];	
		//[periodNameField release];
		
		showNotesHistoryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		showNotesHistoryButton.frame = CGRectMake(20, 184, 230, 30);
		[showNotesHistoryButton setTitle:@"Select Image..." forState:UIControlStateNormal];
		[showNotesHistoryButton setBackgroundColor:[UIColor clearColor]];
		[showNotesHistoryButton setBackgroundImage:[UIImage imageNamed:@"blue_button_medium.png"] forState:UIControlStateNormal];
		[showNotesHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[showNotesHistoryButton setFont:[UIFont boldSystemFontOfSize:14]];
		[showNotesHistoryButton addTarget:self action:@selector(showNotesHistory) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:showNotesHistoryButton];
		
		
		
		notesViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textViewBackground.png"]];	
		notesViewBackground.frame = CGRectMake(12,225,296,180);
		notesViewBackground.hidden = YES;
		[self.view addSubview:notesViewBackground];
		
		notesView = [[UITextView alloc] initWithFrame:CGRectMake(20.0, 230, 280.0, 170)];
		notesView.backgroundColor = [UIColor clearColor];
		notesView.textColor = [UIColor blackColor];
		notesView.textAlignment = UITextAlignmentLeft;
		notesView.delegate = self;
		notesView.font = [UIFont systemFontOfSize:18];
		[notesView setReturnKeyType:UIReturnKeyDefault];
		notesView.autocorrectionType=UITextAutocorrectionTypeNo;
		notesView.userInteractionEnabled = NO;
		[self.view addSubview:notesView];	
		//[periodNameField release];
		
		saveEditButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		saveEditButton.frame = CGRectMake(170, 60, 63, 45);
		[saveEditButton setTitle:@"Edit" forState:UIControlStateNormal];
		[saveEditButton setBackgroundColor:[UIColor clearColor]];
		[saveEditButton setBackgroundImage:[UIImage imageNamed:@"blue_button_medium.png"] forState:UIControlStateNormal];
		[saveEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[saveEditButton setFont:[UIFont boldSystemFontOfSize:14]];
		[saveEditButton addTarget:self action:@selector(togglePageEditing) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:saveEditButton];
		
		showNotesHistoryButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		showNotesHistoryButton.frame = CGRectMake(240, 60, 63, 45);
		[showNotesHistoryButton setTitle:@"Archive" forState:UIControlStateNormal];
		[showNotesHistoryButton setBackgroundColor:[UIColor clearColor]];
		[showNotesHistoryButton setBackgroundImage:[UIImage imageNamed:@"blue_button_medium.png"] forState:UIControlStateNormal];
		[showNotesHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[showNotesHistoryButton setFont:[UIFont boldSystemFontOfSize:14]];
		[showNotesHistoryButton addTarget:self action:@selector(showNotesHistory) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:showNotesHistoryButton];
		
		UIButton* saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		saveButton.frame = CGRectMake(20, 415, 57, 30);
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[saveButton setBackgroundColor:[UIColor clearColor]];
		[saveButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
		[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[saveButton addTarget:self action:@selector(saveNotes) forControlEvents:UIControlEventTouchUpInside];
		saveButton.font = [UIFont boldSystemFontOfSize:14];
		[self.view addSubview:saveButton];
		
		UIButton* newNoteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		newNoteButton.frame = CGRectMake(90, 415, 102, 30);
		[newNoteButton setTitle:@"New Note" forState:UIControlStateNormal];
		[newNoteButton setBackgroundColor:[UIColor clearColor]];
		[newNoteButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
		[newNoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[newNoteButton addTarget:self action:@selector(newNote) forControlEvents:UIControlEventTouchUpInside];
		newNoteButton.font = [UIFont boldSystemFontOfSize:14];
		[self.view addSubview:newNoteButton];
		
		
		
    }
    return self;
}
 

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	if ([localPlannerSubjectArray count] == 1) {
		self.periodNameField.text = [[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:2];
		classroomField.text = [[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:3];
		notesView.text = [[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:6];
		
		// Now Display Weekday
		if ([weekday intValue] == 1) {
			customNavHeader.upperSubHeading.text = @"Monday";
		} else if ([weekday intValue] == 2) {
			customNavHeader.upperSubHeading.text = @"Tuesday";
		} else if ([weekday intValue] == 3) {
			customNavHeader.upperSubHeading.text = @"Wednesday";
		} else if ([weekday intValue] == 4) {
			customNavHeader.upperSubHeading.text = @"Thursday";
		} else if ([weekday intValue] == 5) {
			customNavHeader.upperSubHeading.text = @"Friday";
		}
		
		
		
		
	}
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)togglePageEditing {
	// get the currently editing state for the page
	// if editing, then hide the frames and set the text fields to prevent interaction
	// if not editing, do the reverse
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.	
	
	if (currentlyEditing) {
		[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:periodNameField.text];
		[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:classroomField.text];
		[self saveLocalPlannerArrayToDatabase];
		
		[saveEditButton setTitle:@"Edit" forState:UIControlStateNormal];
		periodNameField.userInteractionEnabled = NO;
		periodNameField.borderStyle = UITextBorderStyleNone;
		classroomField.userInteractionEnabled = NO;
		classroomField.borderStyle = UITextBorderStyleNone;
		notesViewBackground.hidden = YES;
		notesView.backgroundColor = [UIColor clearColor];
		notesView.userInteractionEnabled = NO;
		currentlyEditing = NO;
		
	} else {
		[saveEditButton setTitle:@"Save" forState:UIControlStateNormal];
		periodNameField.userInteractionEnabled = YES;
		periodNameField.borderStyle = UITextBorderStyleRoundedRect;
		classroomField.userInteractionEnabled = YES;
		classroomField.borderStyle = UITextBorderStyleRoundedRect;
		notesViewBackground.hidden = NO;
		notesView.backgroundColor = [UIColor whiteColor];
		notesView.userInteractionEnabled = YES;
		currentlyEditing = YES;
	}

[UIView commitAnimations];

}

- (void)changePeriodType {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (periodTypeSelector.selectedSegmentIndex == 0) {
		[[[appDelegate structureArray] objectAtIndex:[periodID integerValue]] replaceObjectAtIndex:1 withObject:@"Lesson"];
	} else {
		[[[appDelegate structureArray] objectAtIndex:[periodID integerValue]] replaceObjectAtIndex:1 withObject:@"Break"];
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	[self slideViewUpForKeyboard];
}


- (void)textViewDidEndEditing:(UITextView *)textView {
	
	
	if (textView == notesView) {
		
					[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:6 withObject:notesView.text];
		
	}
		
		
		// now update the array to the database
	
	[self saveLocalPlannerNotesToDatabase];
		
	
	
	
}


/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return YES;
}
 */

- (void)saveNotes {
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:6 withObject:notesView.text];
	[self saveLocalPlannerNotesToDatabase];
	[self setViewMovedUp:NO];
	[notesView resignFirstResponder];
}

- (void)newNote {
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:6 withObject:notesView.text];
	[self saveLocalPlannerNotesToDatabase];
	[self createNewNoteForPeriod];
	notesView.text = @"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
		
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == periodNameField) {
		
		[periodNameField resignFirstResponder];
	} else if (theTextField == classroomField) {
			[classroomField resignFirstResponder];
	}
	
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:periodNameField.text];
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:classroomField.text];
	[self saveLocalPlannerArrayToDatabase];
	return YES;
	
}	



// Animate the entire view up or down, to prevent the keyboard from covering the bottom fields.
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)slideViewUpForKeyboard {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
	if (rect.origin.y >= 0)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	
    self.view.frame = rect;
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
	
	
}


- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the username or password fields, adjust the display so that the
    // fields will not be covered by the keyboard.
    if (self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
		
    }
	else if (self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:NO];
    }
	
	
	
}

- (void)showNotesHistory {
	// create and pop the view controller showing the history for the notes field from previous weeks
	
	DailyPlannerLessonInstanceNotesHistoryController *dailyPlannerLessonInstanceNotesHistoryController = [[DailyPlannerLessonInstanceNotesHistoryController alloc] initWithNibName:nil bundle:nil];    
	dailyPlannerLessonInstanceNotesHistoryController.title = @"Notes History";	
	
	dailyPlannerLessonInstanceNotesHistoryController.localWeeklyPlannerArrayRow = periodID;
	[dailyPlannerLessonInstanceNotesHistoryController setLocalValues:[periodID intValue] andWeekday:[weekday intValue]];
	NSLog(@"Create History View with period %i on weekday %i",[self.periodID integerValue],[self.weekday intValue]);
	
	[dailyPlannerLessonInstanceNotesHistoryController configureHistoryArray:periodID];
	
	[[self navigationController] pushViewController:dailyPlannerLessonInstanceNotesHistoryController animated:YES];
	
	//[dailyPlannerLessonInstanceNotesHistoryController release];
	
	
}


// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseLocalPlannerArray {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	localPlannerSubjectArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT periodID, weekday, subjectName, classroom FROM weeklyPlannerValues WHERE periodID = ? AND weekday = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, [periodID intValue]);
			sqlite3_bind_int(statement, 2, [weekday intValue]);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT periodID, weekday, subjectName, classroom FROM weeklyPlannerValues WHERE periodID = %i and weekday = %i", [periodID intValue], [weekday intValue]);
			
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *rowPeriodID = (char *)sqlite3_column_text(statement, 0);
				char *rowWeekday = (char *)sqlite3_column_text(statement, 1);
				char *rowSubjectName = (char *)sqlite3_column_text(statement, 2);
				char *rowClassroom = (char *)sqlite3_column_text(statement, 3);
				[localPlannerSubjectArray addObject:[[NSMutableArray arrayWithObjects:
												  (rowPeriodID) ? [NSString stringWithUTF8String:rowPeriodID] : @"",
												  (rowWeekday) ? [NSString stringWithUTF8String:rowWeekday] : @"",
												  (rowSubjectName) ? [NSString stringWithUTF8String:rowSubjectName] : @"",
												  (rowClassroom) ? [NSString stringWithUTF8String:rowClassroom] : @"",
												  nil] retain]];
				NSLog(@"Period Query Returned Row %i: %@, %@, %@, %@", rowNumber,[NSString stringWithUTF8String:rowPeriodID],[NSString stringWithUTF8String:rowWeekday],[NSString stringWithUTF8String:rowSubjectName],[NSString stringWithUTF8String:rowClassroom] );
				
				rowNumber +=1;
			}
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Cell Instance Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	// now query notes database and return the most recent notes entry (as sorted by date)
	// the notes value will be appended to the local array as object 4 (noteID, 5 (date) and 6 (note)
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT rowid, date, note FROM weeklyPlannerNotes WHERE periodID = ? AND weekday = ? AND date = (SELECT max(date) FROM weeklyPlannerNotes WHERE periodID = ? AND weekday = ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, [periodID intValue]);
			sqlite3_bind_int(statement, 2, [weekday intValue]);
			sqlite3_bind_int(statement, 3, [periodID intValue]);
			sqlite3_bind_int(statement, 4, [weekday intValue]);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT rowid, date, note from weeklyPlannerNotes where periodID = %i and weekday = %i and date = (select max(date) from weeklyPlannerNotes where periodID = %i and weekday = %i) order by rowid desc", [periodID intValue], [weekday intValue], [periodID intValue], [weekday intValue]);
			
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW && rowNumber < 1) {
				int rowNoteID = sqlite3_column_int(statement, 0);
				char *rowDate = (char *)sqlite3_column_text(statement, 1);
				char *rowNote = (char *)sqlite3_column_text(statement, 2);
				
				[[localPlannerSubjectArray objectAtIndex:0] addObject:													  [NSNumber numberWithInt:rowNoteID]];
					[[localPlannerSubjectArray objectAtIndex:0] addObject:													  (rowDate) ? [NSString stringWithUTF8String:rowDate] : @""];			[[localPlannerSubjectArray objectAtIndex:0] addObject:													  (rowNote) ? [NSString stringWithUTF8String:rowNote] : @""];
				
				NSLog(@"Notes Query Returned Row %i, %@, %@", rowNoteID,(rowDate) ? [NSString stringWithUTF8String:rowDate] : @"",(rowNote) ? [NSString stringWithUTF8String:rowNote] : @"" );
				
				rowNumber +=1;
			}
			
			// check if rowNumber ==0 - if so then no results returned which means no note exists for this period
			// in which case call the function to create a new note and set the array objects accordingly
			if ([[localPlannerSubjectArray objectAtIndex:0] count] == 4) {
				[[localPlannerSubjectArray objectAtIndex:0] addObject:[NSNumber numberWithInt:0]];
				[[localPlannerSubjectArray objectAtIndex:0] addObject:@""];
				[[localPlannerSubjectArray objectAtIndex:0] addObject:@""];
				[self createNewNoteForPeriod];
			}
			
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Cell Instance Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        //NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
		NSLog(@"Cell Instance Error Message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	// configure field values
	NSLog(@"Period Values: %@, %@",[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:2],[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:3]);
	if ([localPlannerSubjectArray count] == 1) {
	self.periodNameField.text = [[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:2];
	classroomField.text = [[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:3];
	
	}
	
	[pool release];
}


- (void)createNewNoteForPeriod {
	
	// create a new note for this period, save it to the database and set the local array objects accordingly
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate.sql"];
	
	// Open a connection and insert a new note into the database.  As we use rowid which is the sqlite autoincrement field, we don't need to test for a unique ID and increment it manually.
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        const char *sql = "INSERT into weeklyPlannerNotes (periodID, weekday, date, note) VALUES (?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"Insert Query OK");
			int success = 0;
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, [periodID intValue]);
			sqlite3_bind_int(statement, 2, [weekday intValue]);
			
			
			NSDate* noteDate = [NSDate date];
			NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			NSString* formattedDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:noteDate]];
			
			NSLog(@"Date Format: %@",formattedDate);
			
			sqlite3_bind_text(statement, 3, [formattedDate UTF8String], -1, SQLITE_TRANSIENT);
			
			sqlite3_bind_text(statement, 4, [@"" UTF8String], -1, SQLITE_TRANSIENT);
			
			NSLog(@"INSERT into weeklyPlannerNotes (periodID, weekday, date, note) VALUES (%i,%i,%@,%@): STATUS %i",[periodID intValue],[weekday intValue],formattedDate,@" ", success);
			

			// Execute the query.
			success =sqlite3_step(statement);
						// Reset the query for the next use.
			sqlite3_reset(statement);
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	// now retrieve the rowID for the new note and update it to make sure we save changes to the right note
	
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT max(rowid) FROM weeklyPlannerNotes WHERE periodID = ? AND weekday = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, [periodID intValue]);
			sqlite3_bind_int(statement, 2, [weekday intValue]);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT max(rowid) FROM weeklyPlannerNotes WHERE periodID = %' AND weekday = %i", [periodID intValue], [weekday intValue]);
			
			int success = 0;
			success =sqlite3_step(statement);

				int rowNoteID = sqlite3_column_int(statement, 0);
				
				[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:rowNoteID]];
				
			
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Cell Instance Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	

	
}



- (void)saveLocalPlannerArrayToDatabase {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate.sql"];
	
	// Open a connection and do an update into the database for this period
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "UPDATE weeklyPlannerValues SET subjectName = ?, classroom = ? WHERE periodID = ? and weekday = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			NSLog(@"Update Query OK");
			int success = 0;
			// Bind the query variables.
			sqlite3_bind_text(statement, 1, [[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
			
			sqlite3_bind_text(statement, 2, [[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
			
			sqlite3_bind_int(statement, 3, [periodID intValue]);
			sqlite3_bind_int(statement, 4, [weekday intValue]);
			
			
			// Execute the query.
			success =sqlite3_step(statement);
			NSLog(@"UPDATE weeklyPlannerValues SET subjectName = %@, classroom = %@ WHERE periodID = %i and weekday = %i: STATUS %i",[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:2],[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:3],[periodID intValue],[weekday intValue], success);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// start a thread to save the array to the database
	//[NSThread detachNewThreadSelector:@selector(saveLocalPlannerArrayToDatabase) toTarget:self withObject:nil];
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:2 withObject:periodNameField.text];
	[[localPlannerSubjectArray objectAtIndex:0] replaceObjectAtIndex:3 withObject:classroomField.text];
	[self saveLocalPlannerArrayToDatabase];
	
	[self saveLocalPlannerArrayToDatabase];
}

- (void)saveLocalPlannerNotesToDatabase {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate.sql"];
	
	// Open a connection and do an update into the database for this period
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "UPDATE weeklyPlannerNotes SET note = ? WHERE rowid = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			NSLog(@"Update Query OK");
			int success = 0;
			// Bind the query variables.
			sqlite3_bind_text(statement, 1, [[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:6] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(statement, 2, [[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:4] intValue]);			
			
			// Execute the query.
			success =sqlite3_step(statement);
			NSLog(@"UPDATE weeklyPlannerNotes SET note = %@ WHERE rowid = %i: STATUS %i",[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:6],[[[localPlannerSubjectArray objectAtIndex:0] objectAtIndex:4] intValue], success);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        //NSAssert1(0, @"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
		NSLog(@"Save Database Error '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[periodID release];
	[weekday release];
	[periodTypeSelector release];
	[periodNameField release];
	[classroomField release];
	[notesView release];
	[notesViewBackground release];
	[showNotesHistoryButton release];
	[saveEditButton release];
	[localPlannerSubjectArray release];
	[customNavHeader release];
    [super dealloc];
}


@end
