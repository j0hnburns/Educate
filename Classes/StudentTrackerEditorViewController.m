//
//  StudentTrackerEditorViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "StudentTrackerEditorViewController.h"
#import "EducateAppDelegate.h"
#import "StudentTrackerStudentListTableViewController.h"
#import "CustomNavigationHeader.h"



@implementation StudentTrackerEditorViewController

@synthesize trackerID;
@synthesize trackerScaleSelector;
@synthesize trackerNameField;
@synthesize editStudentsButton;
@synthesize localStudentTrackerInstanceArray;
@synthesize customNavHeader;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		trackerID = [NSNumber numberWithInteger:0];
    }
	
	
	
	// Settings Fields & Labels
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Tracker Detail";
	customNavHeader.upperSubHeading.text = @"Tracker";
	//customNavHeader.lowerSubHeading.text = [NSString stringWithFormat:@"%@",[[[appDelegate structureArray] objectAtIndex:[periodID intValue]] objectAtIndex:2]];
	customNavHeader.lowerSubHeading.text = @"";
	[self.view addSubview:customNavHeader];
	//[customNavHeader release];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 40);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	lowerViewBackground.frame = CGRectMake(0,134,320,330);
	[self.view addSubview:lowerViewBackground];
	//[lowerViewBackground release];
	
	
	UILabel* labelTrackerScale = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 224.0, 310.0, 30)];
	labelTrackerScale.text = @"Tracker Scale:";
	labelTrackerScale.backgroundColor = [UIColor clearColor];
	labelTrackerScale.textColor = [UIColor darkGrayColor];
	labelTrackerScale.textAlignment = UITextAlignmentCenter;
	labelTrackerScale.font = [UIFont boldSystemFontOfSize:15];
	[self.view addSubview:labelTrackerScale];
	//[labelPeriodType release];
	
	NSArray *segmentedControlArray = [[NSArray arrayWithObjects:
									   @"Attend.",
									   @"A+",
									   @"C / NYC",
									   @"Numeric",
									   @"Custom",
									   nil] retain];
	
	trackerScaleSelector = [[UISegmentedControl alloc] initWithItems:segmentedControlArray];
	trackerScaleSelector.frame = CGRectMake(20.0, 254.0, 280.0, 30);
	trackerScaleSelector.selectedSegmentIndex = 0;
	trackerScaleSelector.segmentedControlStyle = UISegmentedControlStyleBar;
	[trackerScaleSelector addTarget:self action:@selector(changeScaleType) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:trackerScaleSelector];
	//[periodTypeSelector release];
	
	UILabel* labelTrackerName = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 154.0, 310.0, 30)];
	labelTrackerName.text = @"Tracker Name:";
	labelTrackerName.backgroundColor = [UIColor clearColor];
	labelTrackerName.textColor = [UIColor darkGrayColor];
	labelTrackerName.textAlignment = UITextAlignmentCenter;
	labelTrackerName.font = [UIFont boldSystemFontOfSize:15];
	[self.view addSubview:labelTrackerName];
	//[labelPeriodName release];
	
	trackerNameField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 184, 240.0, 30)];
	trackerNameField.backgroundColor = [UIColor clearColor];
	trackerNameField.textColor = [UIColor blackColor];
	trackerNameField.textAlignment = UITextAlignmentLeft;
	trackerNameField.borderStyle = UITextBorderStyleRoundedRect;
	//[periodNameField addTarget:self action:@selector(slideViewUpForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
	trackerNameField.delegate = self;
	[trackerNameField setReturnKeyType:UIReturnKeyDone];
	trackerNameField.autocorrectionType=UITextAutocorrectionTypeNo;
	[self.view addSubview:trackerNameField];	
	//[periodNameField release];
	
	
	editStudentsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	editStudentsButton.frame = CGRectMake(89.0, 304.0, 142, 45);
	[editStudentsButton setTitle:@"Edit Student List" forState:UIControlStateNormal];
	[editStudentsButton setBackgroundColor:[UIColor clearColor]];
	[editStudentsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[editStudentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	editStudentsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[editStudentsButton addTarget:self action:@selector(editStudentList) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:editStudentsButton];
	
	
	
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

- (void)editStudentList {
//EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	StudentTrackerStudentListTableViewController *studentTrackerStudentListTableViewController = [StudentTrackerStudentListTableViewController alloc];    
	studentTrackerStudentListTableViewController.title = @"Student List";
	
	//studentTrackerStudentListTableViewController.trackerID = trackerID;

	[[self navigationController] pushViewController:studentTrackerStudentListTableViewController animated:YES];
	
	[studentTrackerStudentListTableViewController populateStudentListForTracker:[trackerID intValue]];
	
	[studentTrackerStudentListTableViewController release];
	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)changeScaleType {

	
	if (trackerScaleSelector.selectedSegmentIndex == 0) {
		[localStudentTrackerInstanceArray replaceObjectAtIndex:2 withObject:@"Attendance"];
	} else if (trackerScaleSelector.selectedSegmentIndex == 1) {
		[localStudentTrackerInstanceArray replaceObjectAtIndex:2 withObject:@"A+"];
	} else if (trackerScaleSelector.selectedSegmentIndex == 2) {
		[localStudentTrackerInstanceArray replaceObjectAtIndex:2 withObject:@"C/NYC"];
	} else if (trackerScaleSelector.selectedSegmentIndex == 3) {
		[localStudentTrackerInstanceArray replaceObjectAtIndex:2 withObject:@"Numeric"];
	} else {
		[localStudentTrackerInstanceArray replaceObjectAtIndex:2 withObject:@"Custom"];
	}
	
	customNavHeader.lowerSubHeading.text = [localStudentTrackerInstanceArray objectAtIndex:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == trackerNameField) {
		[trackerNameField resignFirstResponder];
		
		[localStudentTrackerInstanceArray replaceObjectAtIndex:1 withObject:trackerNameField.text];
		self.title = trackerNameField.text;
		
		customNavHeader.upperSubHeading.text = [localStudentTrackerInstanceArray objectAtIndex:1];

	}
	
	return YES;
	
}	
- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"StudentTrackerEditorViewController viewWillAppear");
	
	
	
	trackerNameField.text = [localStudentTrackerInstanceArray objectAtIndex:1];
	customNavHeader.upperSubHeading.text = [localStudentTrackerInstanceArray objectAtIndex:1];
	customNavHeader.lowerSubHeading.text = [localStudentTrackerInstanceArray objectAtIndex:2];
	
	if ([[localStudentTrackerInstanceArray objectAtIndex:2] isEqualToString:@"Attendance"]) {
		trackerScaleSelector.selectedSegmentIndex = 0;
	} else if ([[localStudentTrackerInstanceArray objectAtIndex:2] isEqualToString:@"A+"]) {
		trackerScaleSelector.selectedSegmentIndex = 1;
	} else if ([[localStudentTrackerInstanceArray objectAtIndex:2] isEqualToString:@"C/NYC"]) {
		trackerScaleSelector.selectedSegmentIndex = 2;
	} else if ([[localStudentTrackerInstanceArray objectAtIndex:2] isEqualToString:@"Numeric"]) {
		trackerScaleSelector.selectedSegmentIndex = 3;
	} else {
		trackerScaleSelector.selectedSegmentIndex = 4;
	}
	
}
	

- (void)viewWillDisappear:(BOOL)animated {

	NSLog(@"StudentTrackerEditorViewController viewWillDisappear");
	
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;

	if (trackerNameField.isEditing) {
		[trackerNameField resignFirstResponder];
		
		[localStudentTrackerInstanceArray replaceObjectAtIndex:1 withObject:trackerNameField.text];
		self.title = trackerNameField.text;
		
		customNavHeader.upperSubHeading.text = [localStudentTrackerInstanceArray objectAtIndex:1];
		
	}
	
	
	
// The database is stored in the application bundle. 
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];

// Now open a connection and do an insert into the database for each row in the array
// Open the database. The database was prepared outside the application.
if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
	// Get the primary key for all books.
	const char *sql = "UPDATE studentTracker SET trackerName = ?, trackerScale = ? WHERE trackerID = ?";
	sqlite3_stmt *statement;
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
	// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
	if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
		
		
		int success = 0;
		
		
		// Bind the trackerID variable.
		sqlite3_bind_text(statement, 1, [[localStudentTrackerInstanceArray objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, 2, [[localStudentTrackerInstanceArray objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(statement, 3, [trackerID intValue]);
		
		// Execute the query.
		success =sqlite3_step(statement);
		
		// Reset the query for the next use.
		sqlite3_reset(statement);
		
		
	}
	// "Finalize" the statement - releases the resources associated with the statement.
	sqlite3_finalize(statement);
	sqlite3_close(educateDatabase);
} else {
	// Even though the open failed, call close to properly clean up resources.
	sqlite3_close(educateDatabase);
	NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
	// Additional error handling, as appropriate...
}
[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
[pool release];
}




- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[trackerID release];
	[trackerScaleSelector release];
	[trackerNameField release];
	[editStudentsButton release];
	[localStudentTrackerInstanceArray release];
	[customNavHeader release];
    [super dealloc];
}


@end
