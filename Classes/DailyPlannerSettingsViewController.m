//
//  DailyPlannerSettingsViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerSettingsViewController.h"
#import "EducateAppDelegate.h"
#import "DailyPlannerTableViewController.h"
#import "DailyPlannerLessonEditorViewController.h"
#import "DailyPlannerLessonSetupLessonListViewController.h"
#import "CustomNavigationHeader.h"
#import "DailyPlannerSettingsCyclePicker.h"


@implementation DailyPlannerSettingsViewController

@synthesize localPlannerStructureArray;
@synthesize weeklyPlannerTableView;
@synthesize settingsButton;

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
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = @"Schedule Setup";
	weeklyPlannerTableView.delegate = self;
	weeklyPlannerTableView.dataSource = self;

    // Place edit and save buttons on the top navigation bar
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(closeSettingsViewController)];
	
	//[self.navigationItem setLeftBarButtonItem:closeButton animated:YES];
	//[closeButton release];
	
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Timetable Setup";
	customNavHeader.upperSubHeading.frame = CGRectMake(20, 45, 280, 80);
	customNavHeader.upperSubHeading.numberOfLines = 4;
	customNavHeader.upperSubHeading.text = [NSString stringWithFormat:@"%i Day Cycle\r\rConfigure the structure\rof your timetable:", [appDelegate.settings_plannerDayCycleLength intValue]];
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:16];
	customNavHeader.upperSubHeading.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:customNavHeader];
	
	UIButton* changePlannerDayCycleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	changePlannerDayCycleButton.frame = CGRectMake(180, 45, 127, 30);
	[changePlannerDayCycleButton setBackgroundColor:[UIColor clearColor]];
	[changePlannerDayCycleButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[changePlannerDayCycleButton setTitle:@"Change Cycle" forState:UIControlStateNormal];
	[changePlannerDayCycleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[changePlannerDayCycleButton addTarget:self action:@selector(changePlannerDayCycleLength) forControlEvents:UIControlEventTouchUpInside];
	changePlannerDayCycleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:changePlannerDayCycleButton];
	
	UIButton* configureLessonsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	configureLessonsButton.frame = CGRectMake(180, 85, 127, 30);
	[configureLessonsButton setBackgroundColor:[UIColor clearColor]];
	[configureLessonsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[configureLessonsButton setTitle:@"Lesson Setup" forState:UIControlStateNormal];
	[configureLessonsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[configureLessonsButton addTarget:self action:@selector(showLessonConfigurationViewController) forControlEvents:UIControlEventTouchUpInside];
	configureLessonsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:configureLessonsButton];
	
	settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(260, 5, 57, 30);
	[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	[settingsButton setBackgroundColor:[UIColor clearColor]];
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[settingsButton addTarget:self action:@selector(toggleEditing) forControlEvents:UIControlEventTouchUpInside];
	settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	//[customNavHeader addSubview:settingsButton];
	
	UIButton* closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	closeButton.frame = CGRectMake(5, 5, 57, 30);
	[closeButton setTitle:@"Save" forState:UIControlStateNormal];
	[closeButton setBackgroundColor:[UIColor clearColor]];
	[closeButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
	closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[customNavHeader addSubview:closeButton];
	
	weeklyPlannerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,134,320,330) style:UITableViewStyleGrouped];
	weeklyPlannerTableView.delegate = self;
	weeklyPlannerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	weeklyPlannerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	weeklyPlannerTableView.rowHeight = 40;
	weeklyPlannerTableView.backgroundColor = [UIColor clearColor];
	weeklyPlannerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:weeklyPlannerTableView];
	
	
	
	[self initialiseLocalPlannerArray];
	
	[weeklyPlannerTableView reloadData];
	
}

- (void)toggleEditing {
	if ([weeklyPlannerTableView isEditing]) {
		[weeklyPlannerTableView setEditing:NO animated:YES];
		[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	} else {
		[weeklyPlannerTableView setEditing:YES animated:YES];
		[settingsButton setTitle:@"Done" forState:UIControlStateNormal];
	}
		
}

- (void)viewWillAppear:(BOOL)animated {
	[weeklyPlannerTableView reloadData];
    [super viewWillAppear:animated];
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	customNavHeader.upperSubHeading.text = [NSString stringWithFormat:@"%i Day Cycle\r\rConfigure the structure\rof your timetable:", [appDelegate.settings_plannerDayCycleLength intValue]];
	
}


- (void)showLessonConfigurationViewController {
		// display the view controller that allows lessons (subject, classroom & colour) to be configured
	DailyPlannerLessonSetupLessonListViewController *dailyPlannerLessonSetupLessonListViewController = [[DailyPlannerLessonSetupLessonListViewController alloc] initWithNibName:nil bundle:nil];    
	[[self navigationController] pushViewController:dailyPlannerLessonSetupLessonListViewController animated:YES];
	//[dailyPlannerLessonSetupLessonListViewController release];
	
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
	// one section for content, next section for the 'new item' button
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		
	if (section == 0) {
		return [localPlannerStructureArray count];
	} else {
		return 1;
	}
		
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	if (indexPath.section == 0) {
		
		static NSString *CellIdentifier = @"PeriodCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell...
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",
							   [[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:1],[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:2]];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return cell;
		
		
	} else {
		
		static NSString *CellIdentifier = @"AddPeriodCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell...
		
		cell.textLabel.text = @"Add New Period";
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		return cell;	
	}

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 0) {
			
	
	// if selected cell in the lesson list, create and push the lesson editor controller
		
		DailyPlannerLessonEditorViewController *dailyPlannerLessonEditorViewController = [DailyPlannerLessonEditorViewController alloc];    
		dailyPlannerLessonEditorViewController.title = [[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:1];
		dailyPlannerLessonEditorViewController.periodID = [[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:3];
		dailyPlannerLessonEditorViewController.localPeriodArray = [localPlannerStructureArray objectAtIndex:indexPath.row];
		
		[[self navigationController] pushViewController:dailyPlannerLessonEditorViewController animated:YES];
		//[dailyPlannerLessonEditorViewController release];
		
	} else {
		[self createNewPeriod];
	}
	
	
}


- (void)createNewPeriod {	
	// update the database by adding the new period and adding values for that period
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Retrieve the maximum periodID and increment it for the new record
	int latestPeriodID = 0;
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT max(periodID) FROM weeklyPlannerStructure";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			int success =sqlite3_step(statement);
			
			if (success == SQLITE_ROW) {
				latestPeriodID = (int)sqlite3_column_int(statement, 0);
				latestPeriodID +=1;
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
        const char *sql = "INSERT into weeklyPlannerStructure (periodOrder, periodName, periodType, periodID) VALUES (?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {

				
				NSLog(@"Prepare Query OK");
				int success = 0;
				// Bind the variables
				sqlite3_bind_int(statement, 1, [localPlannerStructureArray count]);
			sqlite3_bind_text(statement, 2, [[NSString stringWithFormat:@"Period %i",[localPlannerStructureArray count]+1] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [@"Lesson" UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(statement, 4, latestPeriodID);
			
			NSLog(@"INSERT into weeklyPlannerStructure (periodOrder, periodName, periodType, periodID) VALUES (%i, %@, %@, %i)", [localPlannerStructureArray count], [NSString stringWithFormat:@"Period %i",[localPlannerStructureArray count]+1], @"Lesson", latestPeriodID);
			
				
				// Execute the query.
				success =sqlite3_step(statement);
				// Reset the query for the next use.
				sqlite3_reset(statement);
				
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
	
	
	// insert new period values into the database
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		const char *sql = "INSERT into weeklyPlannerValues (periodID, weekday, subjectName, classroom) VALUES (?, ?, ?, 'Classroom')";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int j = 0;
			
				while ([appDelegate.settings_plannerDayCycleLength intValue] > j) {
					
					// insert weeklyPlannerValues into database
					
					int success = 0;
					// Bind the variables
					sqlite3_bind_int(statement, 1, latestPeriodID);
					sqlite3_bind_int(statement, 2, j);
					NSString* localSubjectName = @"Lesson";
					
					sqlite3_bind_text(statement, 3, [localSubjectName UTF8String], -1, SQLITE_TRANSIENT);
					// Execute the query.
					success =sqlite3_step(statement);
					// Reset the query for the next use.
					sqlite3_reset(statement);
					[localSubjectName release];
					
					j +=1;
					
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
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
	
	
	// now create the new entry in the array
	[localPlannerStructureArray addObject:[[NSMutableArray arrayWithObjects:
											[NSNumber numberWithInt:[localPlannerStructureArray count]],
											[NSString stringWithFormat:@"Period %i",[localPlannerStructureArray count]+1],
											@"Lesson",
											[NSNumber numberWithInt:latestPeriodID],
											nil] retain]];
	
	
	// now refresh the table to reflect the new entry
	[weeklyPlannerTableView reloadData];
	
	// now scroll to the bottom of the table where the new entry will be visible
	[weeklyPlannerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[localPlannerStructureArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // You can't edit the 'Add Period' row
	if (indexPath.section == 1) {
		return NO;
	} else {
		return YES;
	}	
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// now delete the period and any values from the database
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
		
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
		
		// first delete the period from the weeklyPlannerStructure table
		
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			const char *sql = "DELETE from weeklyPlannerStructure where periodID = ?";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				NSLog(@"Insert Query OK");
				int success = 0;
				// bind variables
				sqlite3_bind_int(statement, 1, [[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:3] intValue]);
				
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
		
				
		// now clear weeklyPlannerValues table for that period
		
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			const char *sql = "DELETE from weeklyPlannerValues where periodID = ?";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				NSLog(@"Insert Query OK");
				int success = 0;
				// bind variables
				sqlite3_bind_int(statement, 1, [[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:3] intValue]);
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
		
	
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[pool release];
		
        // Delete the row from the local data source array
		[localPlannerStructureArray removeObjectAtIndex:indexPath.row];
		
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
	[localPlannerStructureArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
	
	// update the order in the database to match the new array order
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	localPlannerStructureArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "UPDATE weeklyPlannerStructure SET periodOrder = ? WHERE periodID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			int success = 0;
			// Bind the variables
			sqlite3_bind_int(statement, 1, toIndexPath.row);
			sqlite3_bind_int(statement, 2, [[[localPlannerStructureArray objectAtIndex:fromIndexPath.row] objectAtIndex:3] intValue]);
			
			// Execute the query.
			success =sqlite3_step(statement);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
		
			// Bind the variables
			sqlite3_bind_int(statement, 1, fromIndexPath.row);
			sqlite3_bind_int(statement, 2, [[[localPlannerStructureArray objectAtIndex:toIndexPath.row] objectAtIndex:3] intValue]);
			
			// Execute the query.
			success =sqlite3_step(statement);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
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


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)closeSettingsViewController {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	
	[[NSUserDefaults standardUserDefaults] setObject:localPlannerStructureArray forKey:@"structureArray"];
	
	
	// update localPlannerStructureArray to database
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        const char *sql = "UPDATE weeklyPlannerStructure set periodName = ?, periodType = ?, periodOrder = ? where periodID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int i = 0;
			while ([localPlannerStructureArray count] > i) {
			
			NSLog(@"Prepare Query OK");
			int success = 0;
			// Bind the variables
				sqlite3_bind_text(statement, 1, [[[localPlannerStructureArray objectAtIndex:i] objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 2, [[[localPlannerStructureArray objectAtIndex:i] objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(statement, 3, i);
				sqlite3_bind_int(statement, 4, [[[localPlannerStructureArray objectAtIndex:i] objectAtIndex:3] intValue]);
						
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
		NSLog(@"Insert Row Database Response '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Insert Row Database Response '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	// as structure has changed, delete weeklyPlannerValues database contents and re-create with new structure
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
		const char *sql = "UPDATE weeklyPlannerValues set subjectName = '', classroom = '' where periodID = ?";
		sqlite3_stmt *statement;
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
		if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
	int i = 0;
	while ([localPlannerStructureArray count] > i) {

		
			// if the periodType for this row is 'Break', then we want to clear the subjectName and classroom values for the individual lessons for this period
			// if it is not 'Break', do not change anything
							
			if ([[[localPlannerStructureArray objectAtIndex:i] objectAtIndex:2] isEqualToString:@"Break"]) {	
				
				int success = 0;
				// Bind the variable
				sqlite3_bind_int(statement, 1, [[[localPlannerStructureArray objectAtIndex:i] objectAtIndex:3] intValue]);
				// Execute the query.
				success =sqlite3_step(statement);
				// Reset the query for the next use.
				sqlite3_reset(statement);
				
				}
			i+=1;
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
				
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];

	
	[self dismissModalViewControllerAnimated:YES];
	
}


// Open the database connection and retrieve array contents
- (void)initialiseLocalPlannerArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	localPlannerStructureArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT periodOrder, periodName, periodType, periodID FROM weeklyPlannerStructure ORDER BY periodOrder";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			//int success =sqlite3_step(statement);
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int rowPeriodOrder = sqlite3_column_int(statement, 0);
				char *rowPeriodName = (char *)sqlite3_column_text(statement, 1);
				char *rowPeriodType = (char *)sqlite3_column_text(statement, 2);
				int rowPeriodID = sqlite3_column_int(statement, 3);
				[localPlannerStructureArray addObject:[[NSMutableArray arrayWithObjects:
														[NSNumber numberWithInt:rowPeriodOrder],
														(rowPeriodName) ? [NSString stringWithUTF8String:rowPeriodName] : @"",
														(rowPeriodType) ? [NSString stringWithUTF8String:rowPeriodType] : @"",
														[NSNumber numberWithInt:rowPeriodID],
														nil] retain]];
				
				NSLog(@"Structure Row: %i, %@, %@, %i", rowPeriodOrder, [NSString stringWithUTF8String:rowPeriodName], [NSString stringWithUTF8String:rowPeriodType], rowPeriodID);
				
				rowNumber +=1;
			}
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
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


- (void)changePlannerDayCycleLength {

	
	DailyPlannerSettingsCyclePicker *dailyPlannerSettingsCyclePicker = [[DailyPlannerSettingsCyclePicker alloc] initWithNibName:nil bundle:nil];    
	dailyPlannerSettingsCyclePicker.title = @"Change Planner Day Cycle";
	
	[[self navigationController] pushViewController:dailyPlannerSettingsCyclePicker animated:YES];
	//[dailyPlannerSettingsCyclePicker release];
	
	
}


- (void)dealloc {
	[localPlannerStructureArray release];
	[weeklyPlannerTableView release];
	[settingsButton release];
    [super dealloc];
}


@end

