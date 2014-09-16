//
//  DailyPlannerLessonSelectionViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerLessonSelectionViewController.h"
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


@implementation DailyPlannerLessonSelectionViewController

@synthesize periodID;
@synthesize weekday;
@synthesize lessonPicker;
@synthesize lessonListArray;
@synthesize customNavHeaderThin;
@synthesize localLessonSetupArray;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		periodID = [NSNumber numberWithInt:0];
		weekday = [NSNumber numberWithInt:0];
		
		localLessonSetupArray = [[NSMutableArray alloc] initWithCapacity:0];
		lessonListArray = [[NSMutableArray alloc] initWithCapacity:0];
		customNavHeaderThin = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeaderThin.viewHeader.text = @"Select Lesson";
		[self.view addSubview:customNavHeaderThin];
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 40);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeaderThin addSubview:backButton];
		
		// Settings Fields & Labels
		
		UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		lowerViewBackground.frame = CGRectMake(0,44,320,420);
		[self.view addSubview:lowerViewBackground];
		[lowerViewBackground release];
		
		UILabel* labelColour = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60, 100.0, 30)];
		labelColour.text = @"Lesson:";
		labelColour.backgroundColor = [UIColor clearColor];
		labelColour.textColor = [UIColor darkGrayColor];
		labelColour.textAlignment = UITextAlignmentLeft;
		labelColour.font = [UIFont boldSystemFontOfSize:15];
		[self.view addSubview:labelColour];
		[labelColour release];
		
		
		lessonPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		CGSize pickerSize = [lessonPicker sizeThatFits:CGSizeZero];
		lessonPicker.frame = [self pickerFrameWithSize:pickerSize];
		
		lessonPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lessonPicker.delegate = self;
		lessonPicker.showsSelectionIndicator = YES;	// note this is default to NO
		
		[self.view addSubview:lessonPicker];
		
		
		
    }
    return self;
}
 

// return the picker frame based on its size, positioned at the top of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect pickerRect = CGRectMake(	0.0,
								   100,
								   size.width,
								   size.height);
	return pickerRect;
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
	
    [super viewWillAppear:animated];
	[self initialiseLessonList];
	
	
	
	int i = 0;
		 while ([lessonListArray count] > i) {
			 if ([[[lessonListArray objectAtIndex:i] objectAtIndex:1] isEqualToString:[localLessonSetupArray objectAtIndex:2]]) {
				 [lessonPicker selectRow:i inComponent:0 animated:YES];
				 break;
			 }
			 i +=1;
		 }
		
		
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];	
	
	// set subject name value
	[localLessonSetupArray replaceObjectAtIndex:2 withObject:[[lessonListArray objectAtIndex:[lessonPicker selectedRowInComponent:0]] objectAtIndex:1]];
	// set classroom value
	[localLessonSetupArray replaceObjectAtIndex:3 withObject:[[lessonListArray objectAtIndex:[lessonPicker selectedRowInComponent:0]] objectAtIndex:2]];
	
	[self saveLessonToDatabase];
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

#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	// set subject name value
	[localLessonSetupArray replaceObjectAtIndex:2 withObject:[[lessonListArray objectAtIndex:row] objectAtIndex:1]];
	 // set classroom value
	 [localLessonSetupArray replaceObjectAtIndex:3 withObject:[[lessonListArray objectAtIndex:row] objectAtIndex:2]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [[lessonListArray objectAtIndex:row] objectAtIndex:1];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 320;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 35.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	
	return [lessonListArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}



- (void)saveLessonToDatabase {
	
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
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
			sqlite3_bind_text(statement, 1, [[localLessonSetupArray objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
			
			sqlite3_bind_text(statement, 2, [[localLessonSetupArray objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
			
			sqlite3_bind_int(statement, 3, [periodID intValue]);
			sqlite3_bind_int(statement, 4, [weekday intValue]);
			
			
			// Execute the query.
			success =sqlite3_step(statement);
			NSLog(@"UPDATE weeklyPlannerValues SET subjectName = %@, classroom = %@ WHERE periodID = %i and weekday = %i: STATUS %i",[localLessonSetupArray objectAtIndex:2],[localLessonSetupArray objectAtIndex:3],[periodID intValue],[weekday intValue], success);
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


// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseLessonList {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT lessonID, lessonName, classroom, colour FROM weeklyPlannerLessonSetup order by lessonName";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *returnedLessonID = (char *)sqlite3_column_text(statement, 0);
				char *retrnedLessonName = (char *)sqlite3_column_text(statement, 1);
				char *retrnedClassroom = (char *)sqlite3_column_text(statement, 2);
				char *retrnedColour = (char *)sqlite3_column_text(statement, 3);
				[lessonListArray addObject:[[NSMutableArray arrayWithObjects:
											  (returnedLessonID) ? [NSString stringWithUTF8String:returnedLessonID] : @"",
											  (retrnedLessonName) ? [NSString stringWithUTF8String:retrnedLessonName] : @"",
											  (retrnedClassroom) ? [NSString stringWithUTF8String:retrnedClassroom] : @"",
											  (retrnedColour) ? [NSString stringWithUTF8String:retrnedColour] : @"",
											  nil] retain]];
			}
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Database Returned Message: '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[pool release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {	
	[periodID release];
	[weekday release];
	[lessonPicker release];
	[lessonListArray release];
	[localLessonSetupArray release];
	[customNavHeaderThin release];
    [super dealloc];
}


@end
