//
//  StudentTrackerSettingsViewController.m
//  Educate
//
//  Created by James Hodge on 16/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerSettingsViewController.h"
#import "StudentTrackerEditorViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeader.h"



@implementation StudentTrackerSettingsViewController

@synthesize studentTrackerArray;
@synthesize settingsButton;
@synthesize trackerTableView;
@synthesize customNavHeader;
@synthesize viewBackground;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Tracker Setup";
	customNavHeader.upperSubHeading.frame = CGRectMake(20, 55, 280, 40);
	customNavHeader.upperSubHeading.numberOfLines = 2;
	customNavHeader.upperSubHeading.text = @"Configure your tracker\rand student lists:";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:16];
	customNavHeader.upperSubHeading.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:customNavHeader];
	
	UIButton* addNewPeriodButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	addNewPeriodButton.frame = CGRectMake(200, 55, 107, 30);
	[addNewPeriodButton setBackgroundColor:[UIColor clearColor]];
	[addNewPeriodButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[addNewPeriodButton setTitle:@"Add Tracker" forState:UIControlStateNormal];
	[addNewPeriodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[addNewPeriodButton addTarget:self action:@selector(addNewTracker) forControlEvents:UIControlEventTouchUpInside];
	addNewPeriodButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:addNewPeriodButton];
	
	
	
	
	
	trackerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,134,320,330) style:UITableViewStyleGrouped];
	trackerTableView.delegate = self;
	trackerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	trackerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	trackerTableView.rowHeight = 40;
	trackerTableView.backgroundColor = [UIColor clearColor];
	trackerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:trackerTableView];
	
	
	settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(260, 5, 57, 30);
	[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	[settingsButton setBackgroundColor:[UIColor clearColor]];
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[settingsButton addTarget:self action:@selector(toggleEditing) forControlEvents:UIControlEventTouchUpInside];
	settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	//[customNavHeader addSubview:settingsButton];
	
	UIButton* closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	closeButton.frame = CGRectMake(5, 5, 57, 30);
	[closeButton setTitle:@"Save" forState:UIControlStateNormal];
	[closeButton setBackgroundColor:[UIColor clearColor]];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
	closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[customNavHeader addSubview:closeButton];
	
		
	
	
}



- (void)viewWillAppear:(BOOL)animated {
	[trackerTableView reloadData];
	[self initialiseStudentTrackerArray];
    [super viewWillAppear:animated];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
		return [studentTrackerArray count];

	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
		
		static NSString *CellIdentifier = @"TrackerCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell...
		cell.textLabel.text = [NSString stringWithFormat:@"%@",
					 [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
		
		
}


- (void)addNewTracker {
	[studentTrackerArray addObject:[[NSMutableArray arrayWithObjects:
									 [NSString stringWithFormat:@"%i",[ studentTrackerArray count]+1],
									 @"New Tracker",
									 @"C/NYC",
									 @"",
									 nil] retain]];
	
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
		const char *sql = "INSERT INTO studentTracker (trackerID, trackerName, trackerScale) VALUES (?, ?, ?)";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, [studentTrackerArray count]);
			sqlite3_bind_text(statement, 2, [@"New Tracker" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [@"C/NYC" UTF8String], -1, SQLITE_TRANSIENT);
			
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
	
	[self createNewResultsColumn];
	
	// now refresh the table to reflect the new entry
	[trackerTableView reloadData];
	
	// now scroll to the bottom of the table where the new entry will be visible
	[trackerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[studentTrackerArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)createNewResultsColumn {
	// create a new entry in the studentTrackerDateRecord table and refresh the table view to display that column.
	
	//  check if the first-time alert message has been displayed, and if not display it now
	
		// now create the column itself
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Retrieve the maximum studentTrackerDateID and increment it for the new record
	int latestDateRecordID = 0;
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT max(studentTrackerDateID) FROM studentTrackerDateRecord";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			int success =sqlite3_step(statement);
			
			if (success == SQLITE_ROW) {
				latestDateRecordID = (int)sqlite3_column_int(statement, 0);
				latestDateRecordID +=1;
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
	
	// create the dateRecord entry with today's date and a the date as the description
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "INSERT INTO studentTrackerDateRecord (studentTrackerID, studentTrackerDateID, creationDate, dateLabel) values (?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// setup navigation header and settings button
			NSDate *now = [NSDate date];
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
			[dateFormatter setDateFormat:@"yyyy-MM-dd"];
			NSDateFormatter *shortDateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
			[shortDateFormatter setDateFormat:@"dd/MM"];
			//[dateFormatter release];
			//[now release];
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, [studentTrackerArray count]);
			sqlite3_bind_int(statement, 2, latestDateRecordID);
			sqlite3_bind_text(statement, 3, [[dateFormatter stringFromDate:now] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 4, [[shortDateFormatter stringFromDate:now] UTF8String], -1, SQLITE_TRANSIENT);
			
			// Execute the query.
			int success =sqlite3_step(statement);
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
	
	
	
    [pool release];
	
}


- (void)deleteTracker:(int)deletedTrackerID {
	
	NSLog(@"Deleting Entry %i", deletedTrackerID);
	
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
		const char *sql = "DELETE FROM studentTracker WHERE trackerID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"DELETE FROM studentTracker WHERE trackerID = %i", deletedTrackerID);
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, deletedTrackerID);
			
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
	
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		// Get the primary key for all books.
		const char *sql = "DELETE FROM studentTrackerDateRecord WHERE studentTrackerID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"DELETE FROM studentTrackerDateRecord WHERE studentTrackerID = %i", deletedTrackerID);
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, deletedTrackerID);
			
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
	
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		// Get the primary key for all books.
		const char *sql = "DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerID = %i", deletedTrackerID);
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, deletedTrackerID);
			
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
	
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		// Get the primary key for all books.
		const char *sql = "DELETE FROM studentTrackerStudentList WHERE studentTrackerID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			NSLog(@"DELETE FROM studentTrackerStudentList WHERE studentTrackerID = %i", deletedTrackerID);
			int success = 0;
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, deletedTrackerID);			
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath	animated:NO];
	// if selected cell in the lesson list, create and push the lesson editor controller
	
		
		StudentTrackerEditorViewController *studentTrackerEditorViewController = [[StudentTrackerEditorViewController alloc] initWithNibName:nil bundle:nil];    
		studentTrackerEditorViewController.title = [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1];
		studentTrackerEditorViewController.trackerID = [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:0];		
		
		studentTrackerEditorViewController.localStudentTrackerInstanceArray = [studentTrackerArray objectAtIndex:indexPath.row];
		[[self navigationController] pushViewController:studentTrackerEditorViewController animated:YES];
		[studentTrackerEditorViewController release];
		
	
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // You can't edit the 'Add Tracker' row

 return YES;
 
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[self deleteTracker:[[[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue]];
		[studentTrackerArray removeObjectAtIndex:indexPath.row];
		// Now animate the deletion from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// swap the items in the structureArray to represent new order
		
	[studentTrackerArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)closeSettingsViewController {
		/*
	// update array and set periodID equal to new position in the row
	int i;
	while ([[appDelegate studentTrackerArray] count] > i) {
		[[[appDelegate studentTrackerArray] objectAtIndex:i] replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i",i]];
		i +=1;
	}
	
	 
	
	// as structure has changed, delete studentTrackerInstanceArray contents and re-create with new structure
	
	// create day-of-week array
	
	NSArray* daysOfWeek = [[NSMutableArray arrayWithObjects:
							@"Monday",
							@"Tuesday",
							@"Wednesday",
							@"Thursday",
							@"Friday",
							nil] retain];	
	
	while ([[appDelegate weeklyPlannerArray] count] > 0) {
		[[appDelegate weeklyPlannerArray] removeLastObject];
	}
	int j = 0;
	i = 0;
	while ([[appDelegate structureArray] count] > i) {
		
		j = 0;
		while ([daysOfWeek count] > j) {
			
			[[appDelegate weeklyPlannerArray] addObject: [[NSMutableArray arrayWithObjects:
														   [[[appDelegate structureArray] objectAtIndex:i] objectAtIndex:2],
														   [daysOfWeek objectAtIndex:j],
														   @"Subject",
														   @"",
														   nil] retain]];
			j +=1;
			
		}
		
		i+=1;
	}
	
	
	
	// debugging - dump both planner arrays to NSLog output
	
	i = 0;
	while ([[appDelegate structureArray] count] > i) {
		NSLog(@"Structure Row %i: %@, %@, %@",i, [[[appDelegate structureArray] objectAtIndex:i] objectAtIndex:0], [[[appDelegate structureArray] objectAtIndex:i] objectAtIndex:1], [[[appDelegate structureArray] objectAtIndex:i] objectAtIndex:2]);
		i +=1;
	}
	
	i = 0;
	while ([[appDelegate weeklyPlannerArray] count] > i) {
		NSLog(@"Planner Row %i: %@, %@, %@",i, [[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:0], [[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:1], [[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:2]);
		i +=1;
	}
	
	*/
	

	[self dismissModalViewControllerAnimated:YES];
	
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseStudentTrackerArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	studentTrackerArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT trackerID, trackerName, trackerScale FROM studentTracker";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *returnedTrackerID = (char *)sqlite3_column_text(statement, 0);
				char *retrnedTrackerName = (char *)sqlite3_column_text(statement, 1);
				char *retrnedTrackerScale = (char *)sqlite3_column_text(statement, 2);
				[studentTrackerArray addObject:[[NSMutableArray arrayWithObjects:
												 (returnedTrackerID) ? [NSString stringWithUTF8String:returnedTrackerID] : @"",
												 (retrnedTrackerName) ? [NSString stringWithUTF8String:retrnedTrackerName] : @"",
												 (retrnedTrackerScale) ? [NSString stringWithUTF8String:retrnedTrackerScale] : @"",
												 nil] retain]];
				NSLog(@"studentTracker TrackerID %@ Name %@ Scale %@", (returnedTrackerID) ? [NSString stringWithUTF8String:returnedTrackerID] : @"", (retrnedTrackerName) ? [NSString stringWithUTF8String:retrnedTrackerName] : @"",	 (retrnedTrackerScale) ? [NSString stringWithUTF8String:retrnedTrackerScale] : @"");	
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
	/*
	 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	 [UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	 
	 // The database is stored in the application bundle. 
	 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	 
	 // First open the database connection and delete the previous records
	 // Open the database. The database was prepared outside the application.
	 if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
	 // Get the primary key for all books.
	 const char *sql = "DELETE FROM studentTrackerStudentList WHERE studentTrackerID=?";
	 sqlite3_stmt *statement;
	 // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
	 // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
	 if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
	 
	 // Bind the trackerID variable.
	 //trackerID = [NSNumber numberWithInt:1];
	 sqlite3_bind_int(statement, 1, [trackerID intValue]);
	 
	 // Execute the query.
	 int success =sqlite3_step(statement);
	 
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
	 
	 // Now open a connection and do an insert into the database for each row in the array
	 // Open the database. The database was prepared outside the application.
	 if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
	 // Get the primary key for all books.
	 const char *sql = "INSERT INTO studentTrackerStudentList (studentTrackerID, studentNameID, studentName) VALUES (?, ?, ?)";
	 sqlite3_stmt *statement;
	 // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
	 // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
	 if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
	 
	 int i = 0;
	 int success = 0;
	 while ([studentListForTrackerArray count] > i) {
	 NSLog(@"Writing array item %i of %i with name %@",i,[studentListForTrackerArray count],[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:1] );
	 // Bind the trackerID variable.
	 sqlite3_bind_int(statement, 1, [trackerID intValue]);
	 sqlite3_bind_int(statement, 2, i);
	 sqlite3_bind_text(statement, 3, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
	 
	 // Execute the query.
	 success =sqlite3_step(statement);
	 
	 // Reset the query for the next use.
	 sqlite3_reset(statement);
	 
	 i +=1;
	 }
	 
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
	 */
}


- (void)toggleEditing {
	if ([trackerTableView isEditing]) {
		[trackerTableView setEditing:NO animated:YES];
		[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	} else {
		[trackerTableView setEditing:YES animated:YES];
		[settingsButton setTitle:@"Done" forState:UIControlStateNormal];
	}
	
}


- (void)dealloc {
	[studentTrackerArray release];
	[settingsButton release];
	[trackerTableView release];
    [super dealloc];
}


@end

