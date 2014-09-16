//
//  DailyPlannerLessonSetupLessonListViewController.m
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerLessonSetupLessonListViewController.h"
#import "DailyPlannerLessonSetupInstanceViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"



@implementation DailyPlannerLessonSetupLessonListViewController

@synthesize lessonSetupArray;
@synthesize customNavHeader;
@synthesize viewBackground;
@synthesize settingsButton;
@synthesize trackerTableView;
 


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
 self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	pendingUploads = 0;
	
	lessonSetupArray = [[NSMutableArray alloc] init];
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Lesson Setup";
	[self.view addSubview:customNavHeader];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	
	
	
	
	
	trackerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,400) style:UITableViewStyleGrouped];
	trackerTableView.delegate = self;
	trackerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	trackerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	trackerTableView.rowHeight = 40;
	trackerTableView.backgroundColor = [UIColor clearColor];
	trackerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:trackerTableView];
	
	
    [super viewDidLoad];
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated {
	while ([lessonSetupArray count] > 0) {
		[lessonSetupArray removeLastObject];
	}
	[self initialiseStudentTrackerArray];
	[trackerTableView reloadData];
    [super viewWillAppear:animated];
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate exitLandscapeMode];
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [lessonSetupArray count];
	} else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
		cell.textLabel.text = [[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:1];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		// set cell background colour
		if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Yellow"]) {
			cell.backgroundColor = [UIColor yellowColor];
			cell.textLabel.textColor = [UIColor blackColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Blue"]) {
			cell.backgroundColor = [UIColor blueColor];
			cell.textLabel.textColor = [UIColor whiteColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Grey"]) {
			cell.backgroundColor = [UIColor grayColor];
			cell.textLabel.textColor = [UIColor whiteColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Green"]) {
			cell.backgroundColor = [UIColor colorWithRed:0.25 green:0.5 blue:0.054 alpha:1];
			cell.textLabel.textColor = [UIColor whiteColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Red"]) {
			cell.backgroundColor = [UIColor redColor];
			cell.textLabel.textColor = [UIColor whiteColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Orange"]) {
			cell.backgroundColor = [UIColor orangeColor];
			cell.textLabel.textColor = [UIColor blackColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Purple"]) {
			cell.backgroundColor = [UIColor purpleColor];
			cell.textLabel.textColor = [UIColor whiteColor];
		} else if ([[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:3] isEqualToString:@"Black"]) {
			cell.backgroundColor = [UIColor blackColor];
			cell.textLabel.textColor = [UIColor whiteColor];
		}  else {
			cell.backgroundColor = [UIColor whiteColor];
			cell.textLabel.textColor = [UIColor blackColor];
		}
			
			
    return cell;
		
	} else {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell...
		cell.textLabel.text = @"Add Lesson";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.backgroundColor = [UIColor whiteColor];
		cell.textLabel.textColor = [UIColor blackColor];
		return cell;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// prepare the studentTrackerInstanceRecord view and push it onto the view controller
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	if (indexPath.section == 0) {

			// push the lesson setup instance editor
	
			DailyPlannerLessonSetupInstanceViewController *dailyPlannerLessonSetupInstanceViewController = [[DailyPlannerLessonSetupInstanceViewController alloc] initWithNibName:nil bundle:nil];    
			dailyPlannerLessonSetupInstanceViewController.title = [NSString stringWithFormat:@"%@",[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:1]];
			
			dailyPlannerLessonSetupInstanceViewController.localLessonSetupArray = [lessonSetupArray objectAtIndex:indexPath.row];			
			[[self navigationController] pushViewController:dailyPlannerLessonSetupInstanceViewController animated:YES];
			//[dailyPlannerLessonSetupInstanceViewController release];
			
	
	
	} else {
			// add new lesson to database
		[self addNewLessonToDatabase];
		
	}


}

- (void)addNewLessonToDatabase {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	int returnedMaxLessonID = 0;
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT max(lessonID) as maxLessonID FROM weeklyPlannerLessonSetup";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			int success =sqlite3_step(statement);

			returnedMaxLessonID = sqlite3_column_int(statement, 0);
			
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
	
	// increment returnedMaxLessonID to find the next lessonID
	returnedMaxLessonID +=1;
	
	
	// now insert new lesson into database
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "INSERT INTO weeklyPlannerLessonSetup values (?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			
			sqlite3_bind_int(statement, 1, returnedMaxLessonID);
			sqlite3_bind_text(statement, 2, [@"New Lesson" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [@"Classroom" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 4, [@"White" UTF8String], -1, SQLITE_TRANSIENT);
			
			// Execute the query.
			int success =sqlite3_step(statement);

			
				[lessonSetupArray addObject:[[NSMutableArray arrayWithObjects:
											  [NSString stringWithFormat:@"%i",returnedMaxLessonID],
											  @"New Lesson",
											  @"Classroom",
											  @"White",
											  nil] retain]];
			
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
	
	
	[trackerTableView reloadData];
	[pool release];
}



- (void)deleteLesson:(int)deletedLessonID {
	
	NSLog(@"Deleting Entry %i", deletedLessonID);
	
	// now add entry into database
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Now open a connection and do an insert into the database for each row in the array
	// Open the database. The database was prepared outside the application.
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		// Get the primary key for all books.
		const char *sql = "DELETE FROM weeklyPlannerLessonSetup WHERE lessonID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"DELETE FROM weeklyPlannerLessonSetup WHERE lessonID = %i", deletedLessonID);
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, deletedLessonID);
			
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// You can't edit the 'Add Tracker' row
	if (indexPath.section == 0) {
		return YES;
	} else {
		return NO;
	}
	
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self deleteLesson:[[[lessonSetupArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue]];
		[lessonSetupArray removeObjectAtIndex:indexPath.row];
		// Now animate the deletion from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseStudentTrackerArray {
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
				[lessonSetupArray addObject:[[NSMutableArray arrayWithObjects:
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
	[trackerTableView reloadData];
	[pool release];
}

- (void)saveStudentTrackerArrayToDatabase {
// old code unused function in version 2.0+
	 }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
	NSLog(@"DailyPlannerLessonSetupLessonListViewController didReceiveMemoryWarning");
}


- (void)dealloc {
	[lessonSetupArray release];
	[customNavHeader release];
	[settingsButton release];
	[trackerTableView release];
    [super dealloc];
}


@end
