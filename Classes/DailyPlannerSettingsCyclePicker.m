//
//  DailyPlannerSettingsCyclePicker.m
//  Educate
//
//  Created by James Hodge on 21/10/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "DailyPlannerSettingsCyclePicker.h"
#import "EducateAppDelegate.h"


@implementation DailyPlannerSettingsCyclePicker

@synthesize dayCycleLengthPicker;
@synthesize dayCycleLengthValueOptionArray;
@synthesize dayCycleLengthValue;
@synthesize customNavHeader;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		dayCycleLengthValueInt = 0;
		dayCycleLengthValueOptionArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		int i = 1;
		
		while (i < 31) { // change counter value to set maximum number of days in the cycle
			
			[dayCycleLengthValueOptionArray addObject:[NSNumber numberWithInt:i]];
			i +=1;
		}
		
		
		UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
		customNavHeader.viewHeader.text = @"Change Day Cycle";
		[self.view addSubview:customNavHeader];
		
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		
		dayCycleLengthPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		CGSize pickerSize = [dayCycleLengthPicker sizeThatFits:CGSizeZero];
		dayCycleLengthPicker.frame = [self pickerFrameWithSize:pickerSize];
		
		dayCycleLengthPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		dayCycleLengthPicker.delegate = self;
		dayCycleLengthPicker.showsSelectionIndicator = YES;	// note this is default to NO
		
		[self.view addSubview:dayCycleLengthPicker];
		
		
		UILabel *changeDayCycleValueWarningLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 150)];
		changeDayCycleValueWarningLabel.text = @"WARNING!\r\rChanging the value below will erase all data you have stored in the Planner.\r\rPlease do this before setting up your timetable.";
		changeDayCycleValueWarningLabel.backgroundColor = [UIColor clearColor];
		changeDayCycleValueWarningLabel.textColor = [UIColor whiteColor];
		changeDayCycleValueWarningLabel.textAlignment = UITextAlignmentLeft;
		changeDayCycleValueWarningLabel.font = [UIFont boldSystemFontOfSize:14];
		changeDayCycleValueWarningLabel.shadowColor = [UIColor blackColor];
		changeDayCycleValueWarningLabel.numberOfLines = 0;
		changeDayCycleValueWarningLabel.shadowOffset = CGSizeMake(0,1);
		[self.view addSubview:changeDayCycleValueWarningLabel];
		//[changeDayCycleValueWarningLabel release];
		
		
		UILabel *changeDayCycleValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 225, 300, 20)];
		changeDayCycleValueLabel.text = @"Number of Days in Planner Cycle:";
		changeDayCycleValueLabel.backgroundColor = [UIColor clearColor];
		changeDayCycleValueLabel.textColor = [UIColor whiteColor];
		changeDayCycleValueLabel.textAlignment = UITextAlignmentLeft;
		changeDayCycleValueLabel.font = [UIFont boldSystemFontOfSize:18];
		changeDayCycleValueLabel.shadowColor = [UIColor blackColor];
		changeDayCycleValueLabel.numberOfLines = 0;
		changeDayCycleValueLabel.shadowOffset = CGSizeMake(0,1);
		[self.view addSubview:changeDayCycleValueLabel];
		//[changeDayCycleValueLabel release];
		
		
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// return the picker frame based on its size, positioned at the top of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect pickerRect = CGRectMake(	0.0,
								   250,
								   size.width,
								   size.height);
	return pickerRect;
}


- (void)saveChangesToProfile:(int)withNewNumberOfDays {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	if (hasChangedCycleLengthValue) { // only execute the function if the value has actually changed - otherwise do nothing
		
		// first save the new value to  NSUserDefaults
		appDelegate.settings_plannerDayCycleLength = [NSNumber numberWithInt:withNewNumberOfDays];
		[[NSUserDefaults standardUserDefaults] setObject:appDelegate.settings_plannerDayCycleLength forKey:@"settings_plannerDayCycleLength"];
		
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
		NSMutableArray* periodArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		// now delete  lesson values from the database
		
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			const char *sql = "DELETE from weeklyPlannerValues";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				

				int success = 0;
				// Execute the query.
				success =sqlite3_step(statement);
				// Reset the query for the next use.
				sqlite3_reset(statement);
				
			}
			// "Finalize" the statement - releases the resources associated with the statement.
			sqlite3_finalize(statement);
			sqlite3_close(educateDatabase);
			NSLog(@"Delete From Table Database Response '%s'.", sqlite3_errmsg(educateDatabase));
		} else {
			// Even though the open failed, call close to properly clean up resources.
			sqlite3_close(educateDatabase);
			NSAssert1(0, @"Delete From Table Database Response '%s'.", sqlite3_errmsg(educateDatabase));
			// Additional error handling, as appropriate...
		}
		
		
		// now create new database entries for the new period cycle
		
		
		// first build an array of all periodIDs so we can insert values for each field

		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "SELECT periodID, periodType FROM weeklyPlannerStructure";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					int newPeriodID = sqlite3_column_int(statement, 0);
					char *rowPeriodType = (char *)sqlite3_column_text(statement, 1);
					
					[periodArray addObject:[[NSMutableArray arrayWithObjects:
															[NSNumber numberWithInt:newPeriodID],
															(rowPeriodType) ? [NSString stringWithUTF8String:rowPeriodType] : @"",															nil] retain]];
					
				}
				
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
		
		
		// now add new period to structure table in database
		
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			const char *sql = "INSERT into weeklyPlannerValues (periodID, weekday, subjectName, classroom) VALUES (?, ?, ?, ?)";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				
				int success = 0;
				
				int i = 0;
				int j = 0;
				
				while ([periodArray count] > i) {
					
					while ([appDelegate.settings_plannerDayCycleLength intValue] > j) {
						// Bind the variables
						sqlite3_bind_int(statement, 1, [[[periodArray objectAtIndex:i] objectAtIndex:0] intValue]);
						sqlite3_bind_int(statement, 2, j);
						if ([[[periodArray objectAtIndex:i] objectAtIndex:1] isEqualToString:@"Lesson"]) {
							sqlite3_bind_text(statement, 3, [@"Lesson" UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 4, [@"Classroom" UTF8String], -1, SQLITE_TRANSIENT);
						} else {
							sqlite3_bind_text(statement, 3, [@"" UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 4, [@"" UTF8String], -1, SQLITE_TRANSIENT);						}
				
						NSLog(@"INSERT into weeklyPlannerValues (periodID, weekday, subjectName, classroom) VALUES (%i, %i, %@, %@)", [[[periodArray objectAtIndex:i] objectAtIndex:0] intValue], j, @"Lesson", @"Classroom");
				
				
						// Execute the query.
						success =sqlite3_step(statement);
						// Reset the query for the next use.
						sqlite3_reset(statement);
						
						j +=1;
					}
				
					j = 0;
					i +=1;
				}
					
			}
			// "Finalize" the statement - releases the resources associated with the statement.
			sqlite3_finalize(statement);
			sqlite3_close(educateDatabase);
			NSLog(@"Insert Row Database Response '%s'.", sqlite3_errmsg(educateDatabase));
		} else {
			// Even though the open failed, call close to properly clean up resources.
			sqlite3_close(educateDatabase);
			NSAssert1(0, @"Insert Row Database Response '%s'.", sqlite3_errmsg(educateDatabase));
			// Additional error handling, as appropriate...
		}
		
		
		// now reset the column header array with the new number of items
		
		NSMutableArray* plannerColumnHeaderArray = [[NSMutableArray alloc] initWithCapacity:0];
			
		int i = 0;
			
		while ([appDelegate.settings_plannerDayCycleLength intValue] > i) {
				
			[plannerColumnHeaderArray addObject:[NSString stringWithFormat:@"Day %i", i+1]];
				
			i +=1;
			
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:plannerColumnHeaderArray forKey:@"plannerColumnHeaderArray"];
		
		
		
		
	}
		
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	
		
		

	
	
	
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	
	
}
			 
			
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	//find item in picker arrays and set picker view accordingly
	
	int i = 0;
	while ([dayCycleLengthValueOptionArray count] > i) {
		if ([[dayCycleLengthValueOptionArray objectAtIndex:i] intValue] == [appDelegate.settings_plannerDayCycleLength intValue]) {
			[dayCycleLengthPicker selectRow:i inComponent:0 animated:YES];
			dayCycleLengthValue = [NSNumber numberWithInt:[[dayCycleLengthValueOptionArray objectAtIndex:i] intValue]];
			break;
		}
		i +=1;
	}
	hasChangedCycleLengthValue = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[self saveChangesToProfile:dayCycleLengthValueInt];
	
}



#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	//dayCycleLengthValue = [NSNumber numberWithInt:[[dayCycleLengthValueOptionArray objectAtIndex:row] intValue]];
	dayCycleLengthValue = [NSNumber numberWithInt:row+1];
	dayCycleLengthValueInt = row+1;
	hasChangedCycleLengthValue = YES;
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [[dayCycleLengthValueOptionArray objectAtIndex:row] stringValue];
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
	
	return [dayCycleLengthValueOptionArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[customNavHeader release];
	[dayCycleLengthPicker release];
	[dayCycleLengthValueOptionArray release];
	[dayCycleLengthValue release];
}


@end
