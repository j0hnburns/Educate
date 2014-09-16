//
//  StudentTrackerStudentListTableViewController.m
//  Educate
//
//  Created by James Hodge on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerStudentListTableViewController.h"
#import "EducateAppDelegate.h"
#import "StudentTrackerStudentListNameEditorCell.h"
#import "StudentTrackerSTudentListNameTitleCell.h"
#import "CustomNavigationHeader.h"


@implementation StudentTrackerStudentListTableViewController

@synthesize studentListForTrackerArray;
@synthesize trackerID;
@synthesize trackerTableView;
@synthesize trackerScrollView;
@synthesize customNavHeader;
@synthesize viewBackground;
@synthesize settingsButton;
@synthesize deleteButton;
@synthesize trackerTableNameView;



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
	
	currentlyEditingRow = 0;
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	 
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Edit Student List";
	customNavHeader.upperSubHeading.frame = CGRectMake(20, 55, 280, 40);
	customNavHeader.upperSubHeading.numberOfLines = 2;
	customNavHeader.upperSubHeading.text = @"Configure your\rstudent list:";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:16];
	customNavHeader.upperSubHeading.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:customNavHeader];
	
	
	UIButton* addNewPeriodButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	addNewPeriodButton.frame = CGRectMake(170, 50, 137, 30);
	[addNewPeriodButton setBackgroundColor:[UIColor clearColor]];
	[addNewPeriodButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[addNewPeriodButton setTitle:@"Add Student" forState:UIControlStateNormal];
	[addNewPeriodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[addNewPeriodButton addTarget:self action:@selector(addStudentToListArray) forControlEvents:UIControlEventTouchUpInside];
	addNewPeriodButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:addNewPeriodButton];
	
	
	
	
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 40);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	


	
	
	
	trackerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70 , 320, 385)];
	[trackerScrollView setCanCancelContentTouches:NO];
	trackerScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	//trackerScrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	trackerScrollView.scrollEnabled = YES;
	trackerScrollView.directionalLockEnabled = YES;
	trackerScrollView.alwaysBounceVertical = NO;
	trackerScrollView.pagingEnabled = NO;
	trackerScrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:trackerScrollView];
	//[trackerScrollView release];
	
	
	trackerTableNameView = [[UITableView alloc] initWithFrame:CGRectMake(0,70,1560,40) style:UITableViewStylePlain];
	trackerTableNameView.delegate = self;
	trackerTableNameView.dataSource = self;
	trackerTableNameView.scrollEnabled = YES;
	trackerTableNameView.rowHeight = 40;
	trackerTableNameView.backgroundColor = [UIColor clearColor];
	trackerTableNameView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[trackerScrollView addSubview:trackerTableNameView];
	
	trackerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,110,1560,290) style:UITableViewStyleGrouped];
	trackerTableView.delegate = self;
	trackerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	trackerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	trackerTableView.rowHeight = 40;
	trackerTableView.backgroundColor = [UIColor clearColor];
	trackerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	contentXOffsetForDeleteResizing = 0;
	
	[trackerScrollView addSubview:trackerTableView];
	
	[trackerScrollView setContentSize:CGSizeMake(1560, 385)];
	
	
	
	// create the local studentList array by extracting entries from the master studentList array
	
	studentListForTrackerArray = [[NSMutableArray arrayWithObjects:nil] retain];
	
	
	deleteButton = 	[[UIButton buttonWithType:UIButtonTypeCustom] retain];
	deleteButton.frame = CGRectMake(170, 90, 137, 30);
	[deleteButton setBackgroundColor:[UIColor clearColor]];
	[deleteButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[deleteButton setTitle:@"Delete Students" forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[deleteButton addTarget:self action:@selector(toggleEditingByButton) forControlEvents:UIControlEventTouchUpInside];
	deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:deleteButton];

	
}

- (void)setCurrentlyEditingRowAndScroll:(int)toRow {
	currentlyEditingRow = toRow;
	[trackerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentlyEditingRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)populateStudentListForTracker:(int)localTrackerID {
	
	NSLog(@"populateStudentListForTracker %i", localTrackerID);
	trackerID = [NSNumber numberWithInt:localTrackerID];
	
	[self initialiseStudentListArray];
		
	[trackerTableView reloadData];
	
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[trackerTableView reloadData];
	
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// start a thread to save the array to the database
	[NSThread detachNewThreadSelector:@selector(saveStudentListArrayToDatabase) toTarget:self withObject:nil];
	//[self saveStudentListArrayToDatabase];
}

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

- (void)addStudentToListArray {
	
	// first discover highest studentNameID for the new ID
	int i = 0;
	int highestID = 0;
	while ([studentListForTrackerArray count] > i) {
		if (highestID < [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:2] intValue]) {
			// the current studentNameID is larger than the highestID int value, so update the highestID int value
			highestID = [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:2] intValue];
		}
		i +=1;
	}
	highestID +=1;
	
	[studentListForTrackerArray addObject:[[NSMutableArray arrayWithObjects:
											[NSString stringWithFormat:@"%i",[studentListForTrackerArray count]],
											@"Student", // surname
											[NSNumber numberWithInt:highestID], // student ID
											@"New", // first name
											@"", // email
											@"", // phone number
											@"", // guardian phone
											@"",	// guardian name
											@"", // guardian email
											nil] retain]];
	
	
		
	
	[trackerTableView reloadData];
	
	// now insert the new student entry into the database
	
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	
	// Now open a connection and do an insert into the database for the new row
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "INSERT INTO studentTrackerStudentList (studentTrackerID, studentName, studentFirstname, studentEmail, studentNameID) VALUES (?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			//int i = 0;
			int success = 0;
			
				// Bind the trackerID variable.
				sqlite3_bind_int(statement, 1, [trackerID intValue]);
				sqlite3_bind_text(statement, 2, [[[studentListForTrackerArray objectAtIndex:[studentListForTrackerArray count]-1] objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 3, [[[studentListForTrackerArray objectAtIndex:[studentListForTrackerArray count]-1] objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 4, [[[studentListForTrackerArray objectAtIndex:[studentListForTrackerArray count]-1] objectAtIndex:4] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(statement, 5, [[[studentListForTrackerArray objectAtIndex:[studentListForTrackerArray count]-1] objectAtIndex:2] intValue]);
				
				//NSLog(@"INSERT INTO studentTrackerStudentList (studentTrackerID, studentName, studentNameID) VALUES (%i, %@, %i) : SUCCESS %i",[trackerID intValue],[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:1],[[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:2] intValue], success);
				
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
	
	
	// now scroll to the bottom of the table where the new entry will be visible
	[trackerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[studentListForTrackerArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	if (tableView == trackerTableNameView) {
	
		return 1;
		
	} else {
		
		return 1;
		
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (tableView == trackerTableNameView) {
		
		return 1;
		
	} else {
		
		return [studentListForTrackerArray count];
		
	}
	

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == trackerTableNameView) {
		
		static NSString *CellIdentifier = @"StudentTrackerSTudentListNameTitleCell";
		
		StudentTrackerSTudentListNameTitleCell *cell = (StudentTrackerSTudentListNameTitleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[StudentTrackerSTudentListNameTitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}

		return cell;
		
	} else {
		
	
			
		static NSString *CellIdentifier = @"StudentTrackerStudentListNameEditorCell";
		
		StudentTrackerStudentListNameEditorCell *cell = (StudentTrackerStudentListNameEditorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[StudentTrackerStudentListNameEditorCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		// Set up the cell to describe each lesson
		
	cell.studentNameField.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1]];
	cell.studentFirstNameField.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:3]];
	cell.studentEmailField.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:4]];
	cell.studentPhone1Field.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:5]];
	cell.studentPhone2Field.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:6]];
		cell.studentParentNameField.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:7]];
		cell.guardianEmailField.text = [NSString stringWithFormat:@"%@",[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:8]];
		cell.localStudentNameArray = [studentListForTrackerArray objectAtIndex:indexPath.row];
	[cell setTablePointers:self andIndexPathRow:indexPath.row];
		return cell;
		
	}
		
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
	if (tableView == trackerTableNameView) {
		
		return NO;
		
	} else {
		
		return YES;
		
	}
}

- (void)toggleEditingByButton {

	if (trackerTableView.editing == YES) {
		trackerTableView.editing = NO;
		[deleteButton setTitle:@"Delete Students" forState:UIControlStateNormal];
		trackerTableView.frame = CGRectMake(0,110,1560,290);
		[trackerScrollView setContentOffset:CGPointMake(contentXOffsetForDeleteResizing,trackerScrollView.contentOffset.y) animated:YES];
	} else {
		trackerTableView.editing = YES;
		[deleteButton setTitle:@"Finish Editing" forState:UIControlStateNormal];
		trackerTableView.frame = CGRectMake(0,110,320,290);
		contentXOffsetForDeleteResizing = trackerScrollView.contentOffset.x;
		[trackerScrollView setContentOffset:CGPointMake(0,trackerScrollView.contentOffset.y) animated:YES];
	}
	
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {

	if (tableView == trackerTableView) {
		
		trackerTableView.frame = CGRectMake(0,110,320,290);
		contentXOffsetForDeleteResizing = trackerScrollView.contentOffset.x;
		[trackerScrollView setContentOffset:CGPointMake(0,trackerScrollView.contentOffset.y) animated:YES];
	}
	
	
}


- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == trackerTableView) {
		
		trackerTableView.frame = CGRectMake(0,110,1560,290);
		[trackerScrollView setContentOffset:CGPointMake(contentXOffsetForDeleteResizing,trackerScrollView.contentOffset.y) animated:YES];
	}
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tableView == trackerTableNameView) {
		
		
		
	} else {
		
			
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// first delete tracker entries for this student so they don't re-appear for new students using the same ID in the future
		[self deleteTrackerEntriesForStudent:[[[studentListForTrackerArray objectAtIndex:indexPath.row] objectAtIndex:2] intValue]];
        // Delete the row from the data source
		[studentListForTrackerArray removeObjectAtIndex:indexPath.row];
		// Now animate the deletion from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
		
	}
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// swap the items in the structureArray to represent new order
	
	if (tableView == trackerTableNameView) {
		
	} else {
		
	[studentListForTrackerArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
	}
		
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseStudentListArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	studentListForTrackerArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT studentNameID, studentName, studentFirstname, studentEmail, phone1, phone2, parentName, guardianEmail FROM studentTrackerStudentList WHERE studentTrackerID=? ORDER BY studentName";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Bind the trackerID variable.
			//trackerID = [NSNumber numberWithInt:1];
			sqlite3_bind_int(statement, 1, [trackerID intValue]);
			NSLog(@"SELECT studentNameID, studentName, studentFirstname, studentEmail, phone1, phone2, parentName, guardianEmail FROM studentTrackerStudentList WHERE studentTrackerID=%i ORDER BY studentName, studentFirstName",[trackerID intValue]);
			// Execute the query.
			//int success =sqlite3_step(statement);
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int localStudentNameID = sqlite3_column_int(statement, 0);
				char *strStudentName = (char *)sqlite3_column_text(statement, 1);
				char *strStudentFirstname = (char *)sqlite3_column_text(statement, 2);
				char *strStudentEmail = (char *)sqlite3_column_text(statement, 3);
				char *strStudentPhone1 = (char *)sqlite3_column_text(statement, 4);
				char *strStudentPhone2 = (char *)sqlite3_column_text(statement, 5);
				char *strStudentParentName = (char *)sqlite3_column_text(statement, 6);
				char *strGuardianEmail = (char *)sqlite3_column_text(statement, 7);
				// check if studentNameID is 0 - if so then set it to a unique value based upon the row number
				//if (localStudentNameID == 0) {
				//	NSLog(@"for row %i changed studentNameID from %i to %i",rowNumber, localStudentNameID, rowNumber);
				//	localStudentNameID = rowNumber;
				//}
				[studentListForTrackerArray addObject:[[NSMutableArray arrayWithObjects:
														[NSString stringWithFormat:@"%i",rowNumber],
														(strStudentName) ? [NSString stringWithUTF8String:strStudentName] : @"",
														[NSNumber numberWithInt:localStudentNameID],
														(strStudentFirstname) ? [NSString stringWithUTF8String:strStudentFirstname] : @"",
														(strStudentEmail) ? [NSString stringWithUTF8String:strStudentEmail] : @"",
														(strStudentPhone1) ? [NSString stringWithUTF8String:strStudentPhone1] : @"",
														(strStudentPhone2) ? [NSString stringWithUTF8String:strStudentPhone2] : @"",
														(strStudentParentName) ? [NSString stringWithUTF8String:strStudentParentName] : @"",
														(strGuardianEmail) ? [NSString stringWithUTF8String:strGuardianEmail] : @"",
														nil] retain]];
				//NSLog(@"studentTrackerStudentList Row %i StudentNameID %i Value %@", rowNumber, localStudentNameID, (str) ? [NSString stringWithUTF8String:str] : @"");
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
	[trackerTableView reloadData];
	[pool release];
}


- (void)saveStudentListArrayToDatabase {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	NSLog(@"Starting saveStudentListArrayToDatabase");
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Now open a connection and do an update into the database for each row in the array
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "UPDATE studentTrackerStudentList SET studentName = ?, studentFirstname = ?, studentEmail = ?, phone1 = ?, phone2 = ?, parentName = ?, guardianEmail = ? WHERE studentNameID = ? AND studentTrackerID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			int i = 0;
			int success = 0;
			while ([studentListForTrackerArray count] > i) {
			// Bind the trackerID variable.
				sqlite3_bind_text(statement, 1, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 2, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 3, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:4] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 4, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:5] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 5, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:6] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 6, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:7] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_text(statement, 7, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:8] UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(statement, 8, [[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:2] intValue]);
				sqlite3_bind_int(statement, 9, [trackerID intValue]);
				
				//NSLog(@"INSERT INTO studentTrackerStudentList (studentTrackerID, studentName, studentNameID) VALUES (%i, %@, %i) : SUCCESS %i",[trackerID intValue],[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:1],[[[studentListForTrackerArray objectAtIndex:i] objectAtIndex:2] intValue], success);
				
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
	
	NSLog(@"Finishing saveStudentListArrayToDatabase");
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void)deleteTrackerEntriesForStudent:(int)localStudentNameID {
	
	// this code is called when we are deleting a student from the tracker list
	// before removing the row from the array we need to make sure the database is purged of any tracker values for this student
	// this is to ensure a new student using the same ID doesn't inherit the old values
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
        const char *sql = "DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerID=? AND studentID=?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Bind the trackerID variable.
			//trackerID = [NSNumber numberWithInt:1];
			sqlite3_bind_int(statement, 1, [trackerID intValue]);
			sqlite3_bind_int(statement, 2, localStudentNameID);
			
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
	
	// now delete the student record from the tracker itself
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "DELETE FROM studentTrackerStudentList WHERE studentTrackerID=? AND studentNameID=?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Bind the trackerID variable.
			//trackerID = [NSNumber numberWithInt:1];
			sqlite3_bind_int(statement, 1, [trackerID intValue]);
			sqlite3_bind_int(statement, 2, localStudentNameID);
			
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
	
	
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void)dealloc {
	
    [super dealloc];
	[studentListForTrackerArray release];
	[trackerID release];
	[trackerTableView release];
	[trackerTableNameView release];
	[trackerScrollView release];
	//[settingsButton release];
}


@end

