//
//  StudentTrackerInstanceRecordViewController.m
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerInstanceRecordViewController.h"
#import "StudentTrackerInstanceRecordCell.h"
#import "StudentTrackerInstanceNameRecordCell.h"
#import "CustomNavigationHeaderThin.h"
#import "StudentTrackerInstanceHeaderCell.h"
#import "StudentTrackerInstanceNameHeaderCell.h"
#import "StudentTrackerStudentListTableViewController.h"
#import "StudentTrackerEditorViewController.h"
#import "EducateAppDelegate.h"


@implementation StudentTrackerInstanceRecordViewController

@synthesize localStudentNameArray;
@synthesize localDateRecordArray;
@synthesize scaleType;
@synthesize trackerID;
@synthesize customNavHeader;
@synthesize trackerScrollView;
@synthesize trackerTableView;
@synthesize trackerNameTableView;
@synthesize emailToStudentsButton;
@synthesize emailTrackerButton;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		// navigation header
		trackerID = [NSNumber numberWithInt:0];
		trackerIDint = 0;
		hasPushedStudentListEditor = NO;
		popControllerAfterDismissingAlert = NO;
		
		UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
		customNavHeader.viewHeader.text = @"Tracker Detail";
		[self.view addSubview:customNavHeader];
		
		customNavHeader.viewHeader.textAlignment = UITextAlignmentLeft;
		customNavHeader.viewHeader.frame = CGRectMake(60, 8, 260, 26);
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		emailToStudentsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		emailToStudentsButton.frame = CGRectMake(280, 5, 38, 30);
		[emailToStudentsButton setBackgroundColor:[UIColor clearColor]];
		[emailToStudentsButton setBackgroundImage:[UIImage imageNamed:@"emailButton.png"] forState:UIControlStateNormal];
		[emailToStudentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		emailToStudentsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[emailToStudentsButton addTarget:self action:@selector(composeEmailToStudentsInTracker) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:emailToStudentsButton];
		[emailToStudentsButton release];
		
		emailTrackerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		emailTrackerButton.frame = CGRectMake(240, 5, 38, 30);
		[emailTrackerButton setBackgroundColor:[UIColor clearColor]];
		[emailTrackerButton setBackgroundImage:[UIImage imageNamed:@"emailTrackerButton.png"] forState:UIControlStateNormal];
		[emailTrackerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		emailTrackerButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[emailTrackerButton addTarget:self action:@selector(backupDatabaseToEmail) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:emailTrackerButton];
		[emailTrackerButton release];
		
		
		trackerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(160, 44, 180, 360)];
		//trackerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 360)];
		[trackerScrollView setCanCancelContentTouches:NO];
		trackerScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		//trackerScrollView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
		trackerScrollView.scrollEnabled = YES;
		trackerScrollView.directionalLockEnabled = YES;
		trackerScrollView.alwaysBounceVertical = NO;
		trackerScrollView.pagingEnabled = NO;
		trackerScrollView.delegate = self;
		trackerScrollView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:trackerScrollView];
		//[trackerScrollView release];
		
		
		trackerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,(([localDateRecordArray count]+1)*85),(40*([localStudentNameArray count]+2))) style:UITableViewStylePlain];
		trackerTableView.delegate = self;
		trackerTableView.dataSource = self;
		//self.view.autoresizesSubviews = YES;
		trackerTableView.scrollEnabled = YES;
		//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		trackerTableView.rowHeight = 40;
		trackerTableView.backgroundColor = [UIColor clearColor];
		trackerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		//trackerTableView.bounces = NO;
		
		[trackerScrollView addSubview:trackerTableView];
		
		
		
		
		trackerNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,160,360) style:UITableViewStylePlain];
		trackerNameTableView.delegate = self;
		trackerNameTableView.dataSource = self;
		//self.view.autoresizesSubviews = YES;
		trackerNameTableView.scrollEnabled = YES;
		//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		trackerNameTableView.rowHeight = 40;
		trackerNameTableView.backgroundColor = [UIColor clearColor];
		trackerNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		//trackerNameTableView.bounces = NO;
		
		[self.view addSubview:trackerNameTableView];
		
		
		
		trackerTableView.frame = CGRectMake(0,0,(([localDateRecordArray count]+1)*85),(40*([localStudentNameArray count]+2)));
		[trackerScrollView setContentSize:CGSizeMake((([localDateRecordArray count]+1)*85), (40*([localStudentNameArray count]+2)))];
		
    }
    return self;
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	/*
	// show student list editor
	StudentTrackerStudentListTableViewController *studentTrackerStudentListTableViewController = [StudentTrackerStudentListTableViewController alloc];    
	studentTrackerStudentListTableViewController.title = @"Student List";
	[[self navigationController] pushViewController:studentTrackerStudentListTableViewController animated:YES];
	[studentTrackerStudentListTableViewController populateStudentListForTracker:trackerIDint];
	[studentTrackerStudentListTableViewController release];
	*/
	
	if (popControllerAfterDismissingAlert) {
		[self callPopBackToPreviousView];
	}
		/*
	// show tracker editor
	StudentTrackerEditorViewController *studentTrackerEditorViewController = [[StudentTrackerEditorViewController alloc] initWithNibName:nil bundle:nil];    
	studentTrackerEditorViewController.title = [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1];
	studentTrackerEditorViewController.trackerID = trackerIDint;		
	
	studentTrackerEditorViewController.localStudentTrackerInstanceArray = [studentTrackerArray objectAtIndex:indexPath.row];
	[[self navigationController] pushViewController:studentTrackerEditorViewController animated:YES];
	[studentTrackerEditorViewController release];
	*/
	
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	if (scrollView == trackerTableView) {
		
		[trackerTableView setContentOffset:CGPointMake(0,[trackerNameTableView contentOffset].y)];
		[trackerScrollView setContentOffset:CGPointMake([trackerScrollView contentOffset].x,0)];
		//[trackerScrollView setContentOffset:CGPointMake([scrollView contentOffset].x,[trackerNameTableView contentOffset].y)];
		//NSLog(@"trackerTableView did scroll");
		
	} else if (scrollView == trackerNameTableView) {
		
		[trackerTableView setContentOffset:CGPointMake(0,[scrollView contentOffset].y)];
		[trackerScrollView setContentOffset:CGPointMake([trackerScrollView contentOffset].x,0)];
		//NSLog(@"trackerNameTableView did scroll");
		
	} else if (scrollView == trackerScrollView) {
		
		[trackerScrollView setContentOffset:CGPointMake([scrollView contentOffset].x,0)];
		//[trackerNameTableView setContentOffset:CGPointMake(0,[scrollView contentOffset].y)];
		//NSLog(@"trackerScrollView did scroll");
	} 	
}


- (void)viewDidLoad {
    	
	
	
	
	[super viewDidLoad];
	
	
	

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self initialiseStudentListArray];
	trackerTableView.frame = CGRectMake(0,0,(([localDateRecordArray count]+1)*85),(40*([localStudentNameArray count]+2)));
	[trackerScrollView setContentSize:CGSizeMake((([localDateRecordArray count]+1)*85), (40*([localStudentNameArray count]+2)))];
	[trackerNameTableView setContentSize:CGSizeMake(160, (40*([localStudentNameArray count]+2)))];
	if ([localDateRecordArray count] != 0) {
		[trackerScrollView setContentOffset:CGPointMake((([localDateRecordArray count]-1)*85),0) animated:YES];
	} else {
		[trackerScrollView setContentOffset:CGPointMake(0,0) animated:YES];
	}
	[trackerTableView reloadData];
	
	
}


 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
		 
}
 

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// start a thread to save the array to the database
	//[NSThread detachNewThreadSelector:@selector(saveStudentListArrayToDatabase) toTarget:self withObject:nil];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		return [localStudentNameArray count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tableView == trackerTableView) {
	
	if (indexPath.section == 0) {
		
		// header row
		
		static NSString *CellIdentifier = @"studentTrackerInstanceHeaderCell";
		
		StudentTrackerInstanceHeaderCell *cell = (StudentTrackerInstanceHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[StudentTrackerInstanceHeaderCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		while ([cell.localDateRecordArray count] > 0) {
			[cell.localDateRecordArray removeLastObject];
		}
		
		[cell.localDateRecordArray addObjectsFromArray:self.localDateRecordArray];
		[cell populateHeaderLabelsFromArray];
		[cell updateValueFromTextEditor];
		cell.localTrackerTableView = trackerTableView;
		cell.localControllerInstance = self;
		[cell setTrackerID:trackerIDint];
		cell.backgroundColor = [UIColor clearColor];
		return cell;
		
	} else {
		
   
	static NSString *CellIdentifier = @"StudentTrackerInstanceRecordCell";
	
	StudentTrackerInstanceRecordCell *cell = (StudentTrackerInstanceRecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[StudentTrackerInstanceRecordCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	// Set up the cell to describe each lesson
	
		cell.localInstanceRecordArray = [localStudentNameArray objectAtIndex:indexPath.row];
		cell.localDateRecordArray = self.localDateRecordArray;
		[cell setTrackerID:trackerIDint];
		cell.parentStudentTrackerController = self;
		[cell setRowNumberInParentTable:indexPath.row];
		[cell initialiseValuesArrayAndPopulateColumns];
		
		// check if row odd or even and colour accordingly
		if (indexPath.row & 1) {
			// row is odd
			[cell setRowColourScheme:YES];
		} else {
			
			// row is even
			[cell setRowColourScheme:NO];
		}
		
		
		
	return cell;
	
	}
		
	} else { 
		
		//else if (tableView == trackerNameTableView) {
		
		
		if (indexPath.section == 0) {
			
			// header row
			
			static NSString *CellIdentifier = @"studentTrackerInstanceNameHeaderCell";
			
			StudentTrackerInstanceNameHeaderCell *cell = (StudentTrackerInstanceNameHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[StudentTrackerInstanceNameHeaderCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			
			cell.backgroundColor = [UIColor clearColor];
			return cell;
			
		} else {
			
			
			static NSString *CellIdentifier = @"StudentTrackerInstanceNameRecordCell";
			
			StudentTrackerInstanceNameRecordCell *cell = (StudentTrackerInstanceNameRecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[StudentTrackerInstanceNameRecordCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			// Set up the cell to describe each lesson
			
			cell.studentNameLabel.text = [NSString stringWithFormat:@" %@, %@",[[localStudentNameArray objectAtIndex:indexPath.row] objectAtIndex:1],[[localStudentNameArray objectAtIndex:indexPath.row] objectAtIndex:4]];
			cell.localInstanceRecordArray = [localStudentNameArray objectAtIndex:indexPath.row];
			cell.localDateRecordArray = self.localDateRecordArray;
			[cell setTrackerID:trackerIDint];
			
			// check if row odd or even and colour accordingly
			if (indexPath.row & 1) {
				// row is odd, colour cream with white period name
				cell.studentNameLabel.textColor = [UIColor blackColor];
				[cell.studentNameLabel setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
			} else {
				
				// row is even, colour grey gradient with blue period name
				cell.studentNameLabel.textColor = [UIColor whiteColor];
				[cell.studentNameLabel setBackgroundColor:[UIColor colorWithRed:0.0039 green:0.3203 blue:0.7815 alpha:1]];
			}
			
			[cell initialiseContactOptionsArray];
			
			
			return cell;
			
		}
	}
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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

- (void)populateStudentListForTracker:(int)localTrackerID withScaleType:(NSString *)localScaleType {
	
	trackerID = [NSNumber numberWithInt:localTrackerID];
	trackerIDint = localTrackerID;
	scaleType = localScaleType;
	
	[self initialiseStudentListArray];
	trackerTableView.frame = CGRectMake(0,0,(([localDateRecordArray count]+1)*85),(40*([localStudentNameArray count]+2)));
	[trackerScrollView setContentSize:CGSizeMake((([localDateRecordArray count]+1)*85), (40*([localStudentNameArray count]+2)))];
	[trackerNameTableView setContentSize:CGSizeMake(160, (40*([localStudentNameArray count]+2)))];
	[trackerTableView reloadData];
	
		
}

- (void)createNewRecordDateForTrackerAndReloadArray {
	// unused function in version 2.0+
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseStudentListArray {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if (localStudentNameArray == nil) {
		localStudentNameArray = [[NSMutableArray alloc] init];
	} else {
		while ([localStudentNameArray count] > 0) {
			[localStudentNameArray removeLastObject];
		}
	}
	
	if (localDateRecordArray == nil) {
		localDateRecordArray = [[NSMutableArray alloc] init];
	} else {
		while ([localDateRecordArray count] > 0) {
			[localDateRecordArray removeLastObject];
		}
	}
	
	
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Retrieve the maximum studentTrackerDateID and increment it for the new record
	latestDateRecordID = 0;
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT studentTrackerDateID, dateLabel FROM studentTrackerDateRecord WHERE studentTrackerID = ? ORDER BY studentTrackerDateID DESC";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// bind the query variables
			sqlite3_bind_int(statement, 1, trackerIDint);
			
			// Execute the query.
			int i = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				if (i == 0) {
				latestDateRecordID = (int)sqlite3_column_int(statement, 0);
				}
				
					
					char *dateLabel = (char *)sqlite3_column_text(statement, 1);
					[localDateRecordArray insertObject:[[NSMutableArray arrayWithObjects:
													  [NSNumber numberWithInt:(int)sqlite3_column_int(statement, 0)],
													  (dateLabel) ? [NSString stringWithUTF8String:dateLabel] : @"",													  nil] retain]
					 atIndex:0];
					NSLog(@"Adding row #%i To localDateRecordArray: %@",i, (dateLabel) ? [NSString stringWithUTF8String:dateLabel] : @"");
				i +=1;	 
				
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
	
	
	// Now retrieve the list of student names for this particular date instance
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT n.studentName, n.studentFirstname, n.studentNameID FROM studentTrackerStudentList n WHERE n.studentTrackerID=? ORDER BY studentName";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Bind the trackerID variable.
			//trackerID = [NSNumber numberWithInt:1];
			sqlite3_bind_int(statement, 1, trackerIDint);
			
			// Execute the query.
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *returnedStudentName = (char *)sqlite3_column_text(statement, 0);
				char *returnedStudentFirstname = (char *)sqlite3_column_text(statement, 1);
				char *returnedStudentID = (char *)sqlite3_column_text(statement, 2);
				[localStudentNameArray addObject:[[NSMutableArray arrayWithObjects:
														[NSString stringWithFormat:@"%i",rowNumber],
														(returnedStudentName) ? [NSString stringWithUTF8String:returnedStudentName] : @"",
														(returnedStudentID) ? [NSString stringWithUTF8String:returnedStudentID] : @"",
														scaleType,
														(returnedStudentFirstname) ? [NSString stringWithUTF8String:returnedStudentFirstname] : @"",
														nil] retain]];
				rowNumber +=1;
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
	
	/*
	// now check whether the array has any entries - if not then create a new recordDate and fill the entries
	if ([localStudentNameArray count] == 0) {
		[self createNewRecordDateForTrackerAndReloadArray];
	}
	*/
	
	trackerTableView.frame = CGRectMake(0,0,(([localDateRecordArray count]+1)*85),(40*([localStudentNameArray count]+2)));
	[trackerScrollView setContentSize:CGSizeMake((([localDateRecordArray count]+1)*85), (40*([localStudentNameArray count]+2)))];
	[trackerNameTableView setContentSize:CGSizeMake(160, (40*([localStudentNameArray count]+2)))];
	if ([localDateRecordArray count] != 0) {
		[trackerScrollView setContentOffset:CGPointMake((([localDateRecordArray count]-1)*85),0) animated:YES];
	} else {
		[trackerScrollView setContentOffset:CGPointMake(0,0) animated:YES];
	}
	[trackerTableView reloadData];
	
	// check if there are no students in the list - if so show an alert and then push the student list edit controller for this tracker
	if ([localStudentNameArray count] == 0) {
		
		if (!hasPushedStudentListEditor) {
			popControllerAfterDismissingAlert = YES;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Student Tracker" message:@"This tracker has no students configured.  Please return to the Student List editor to add students to this tracker before editing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			
			hasPushedStudentListEditor = YES;
		}
		
		
	}
	
	
    [pool release];


}

- (void)shrinkTableViewsForKeyboardAndScrollToRow:(int)rowNumber{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	trackerScrollView.frame = CGRectMake(160, 44, 180, 205);
	trackerNameTableView.frame = CGRectMake(0,44,160,205);
	[UIView commitAnimations];
	
	[trackerNameTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (void)expandTableViewsForKeyboard {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	trackerScrollView.frame = CGRectMake(160, 44, 180, 360);
	trackerNameTableView.frame = CGRectMake(0,44,160,360);
	
	NSLog(@"expandTableViewsForKeyboard");
	
	
	
	
	[UIView commitAnimations];
	
}

- (void)saveStudentListArrayToDatabase {
	// unused function
}


- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)composeEmailToStudentsInTracker {
	// prepare a list of all student email addresses and compose a blank email with all students BCC:d on the email
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([appDelegate.settings_personalEmail length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Email Address" message:@"Before you can email students from your tracker you need to configure the Email Roll address in the application settings section." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	}
	
	else if (appDelegate.internetConnectionStatus == NotReachable) {
		
		// if first offline failure then notify user with alert box
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to email students from your tracker.  You will not be able to use the email feature until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	} else {
		
		
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		
		// first build the email list by querying the database for this tracker and building the temporary array as per a normal export which includes the email address
		
		NSMutableArray* databaseExportArray = [[NSMutableArray alloc] init];
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
		
		// Open the database. The database was prepared outside the application.
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "select l.studentEmail from studentTrackerStudentList l where l.studentTrackerID=?";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				
				// bind the query variables
				sqlite3_bind_int(statement, 1, trackerIDint);
				
				// Execute the query.
				//int success =sqlite3_step(statement);
				int rowNumber = 0;
				while (sqlite3_step(statement) == SQLITE_ROW) {
					char *rowStudentEmail = (char *)sqlite3_column_text(statement, 0);
					
					if (![(rowStudentEmail) ? [NSString stringWithUTF8String:rowStudentEmail] : @"" isEqualToString:@""]) {
						[databaseExportArray addObject:(rowStudentEmail) ? [NSString stringWithUTF8String:rowStudentEmail] : @""];
					}
					
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
		
			
		// now create a new email using the array of email addresses as the bcc: recipients field and the personal settings email as the to: field
		
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil)
		{
			// We must always check whether the current device is configured for sending emails
			if ([mailClass canSendMail])
			{
				
				MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
				picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
				picker.mailComposeDelegate = self;
				
				[picker setSubject:customNavHeader.viewHeader.text];  // tracker name
				
				// Set up recipients
				NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
				
				[picker setToRecipients:toRecipients];
				
				[picker setBccRecipients:databaseExportArray];
				
				// Fill out the email body text
				NSString *emailBody = @"";
				[picker setMessageBody:emailBody isHTML:NO];
				
				[self presentModalViewController:picker animated:YES];
				[picker release];
				
				
				
			}
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to email this tracker as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
			}
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to email this tracker as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
		
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[pool release];
		
	}
	
}

- (void)backupDatabaseToEmail {
	// builds a .csv file containing the tracker data and sends it to the email script on the server
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if ([appDelegate.settings_personalEmail length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Email Address" message:@"Before you can backup your database you need to configure the Email Roll address in the application settings section." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	}
	
	else if (appDelegate.internetConnectionStatus == NotReachable) {
		
		// if first offline failure then notify user with alert box
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to backup your database.  You will not be able to use the backup feature until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	} else {
		
		
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		// first build the .csv file by grabbing an array using an SQL query, then populating a string from the array
		
		NSMutableArray* databaseExportArray = [[NSMutableArray alloc] init];
		NSMutableArray* databaseHeaderArray = [[NSMutableArray alloc] init];
		NSMutableString* databaseExportFileContentString = [NSMutableString stringWithCapacity:0];	
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
		
		// build and run the query for the header rows
		// we use the values in the array to build the value query in the next step
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "select r.studentTrackerDateID, r.creationDate, r.dateLabel from studentTrackerDateRecord r where r.studentTrackerID=? order by r.studentTrackerDateID asc";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				
				// bind the query variables
				sqlite3_bind_int(statement, 1, trackerIDint);
				
				// Execute the query.
				//int success =sqlite3_step(statement);
				int rowNumber = 0;
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					int rowTrackerDateID = sqlite3_column_int(statement, 0);
					char *rowCreationDate = (char *)sqlite3_column_text(statement, 1);
					char *rowDateLabel = (char *)sqlite3_column_text(statement, 2);
					
					
					
					[databaseHeaderArray addObject:[[NSMutableArray arrayWithObjects:
													 [NSNumber numberWithInt:rowTrackerDateID],
													 (rowCreationDate) ? [NSString stringWithUTF8String:rowCreationDate] : @"",
													 (rowDateLabel) ? [NSString stringWithUTF8String:rowDateLabel] : @"",
													 nil] retain]];
					
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
		
		// now build and run the query for the value rows
		// Open the database. The database was prepared outside the application.
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			NSMutableString *sqlStatementString = [[NSMutableString alloc] initWithCapacity:0];
			[sqlStatementString appendFormat:@"select t.trackerID, t.trackerName, t.trackerScale, l.studentNameID, l.studentName, l.studentFirstname, l.studentEmail, l.phone1, l.parentName, l.guardianEmail, l.phone2"];
			
			int i = 0;
			while ([databaseHeaderArray count] > i) {
				
				[sqlStatementString appendFormat:@", (select v.recordValue from studentTrackerInstanceRecord v where v.studentID = l.studentNameID and v.studentTrackerDateID = %i and v.studentTrackerID = %i)", [[[databaseHeaderArray objectAtIndex:i] objectAtIndex:0] intValue], trackerIDint];
				i +=1;
			}
			
			[sqlStatementString appendFormat:@" from studentTracker t, studentTrackerStudentList l where t.trackerID = l.studentTrackerID AND t.trackerID=%i order by t.trackerID asc, l.studentNameID asc", trackerIDint];
			
			//const char *sql = "select t.trackerID, t.trackerName, t.trackerScale, r.creationDate, r.dateLabel, l.studentNameID, l.studentName, l.studentFirstname, l.studentEmail, l.phone1, l.parentName, l.phone2, v.recordValue from studentTracker t, studentTrackerDateRecord r, studentTrackerInstanceRecord v, studentTrackerStudentList l where t.trackerID = r.studentTrackerID and t.trackerID = v.studentTrackerID and t.trackerID = l.studentTrackerID and l.studentNameID = v.studentID and v.studentTrackerDateID = r.studentTrackerDateID AND t.studentTrackerID=? order by t.trackerID asc, l.studentNameID asc, r.studentTrackerDateID";
			const char *sql = [sqlStatementString UTF8String];
			
			NSLog(@"SQL Export String:\r\r%@", sqlStatementString);
			
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// bind the query variables
				sqlite3_bind_int(statement, 1, trackerIDint);
				
				// Execute the query.
				//int success =sqlite3_step(statement);
				int rowNumber = 0;
				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					char *rowTrackerID = (char *)sqlite3_column_text(statement, 0);
					char *rowTrackerName = (char *)sqlite3_column_text(statement, 1);
					char *rowTrackerScale = (char *)sqlite3_column_text(statement, 2);
					int localStudentNameID = sqlite3_column_int(statement, 3);
					char *rowStudentName = (char *)sqlite3_column_text(statement, 4);
					char *studentFirstname = (char *)sqlite3_column_text(statement, 5);
					char *studentEmail = (char *)sqlite3_column_text(statement, 6);
					char *phone1 = (char *)sqlite3_column_text(statement, 7);
					char *parentName = (char *)sqlite3_column_text(statement, 8);
					char *guardianEmail = (char *)sqlite3_column_text(statement, 9);
					char *phone2 = (char *)sqlite3_column_text(statement, 10);
					
					
					
					[databaseExportArray addObject:[[NSMutableArray arrayWithObjects:
													 (rowTrackerID) ? [NSString stringWithUTF8String:rowTrackerID] : @"",
													 (rowTrackerName) ? [NSString stringWithUTF8String:rowTrackerName] : @"",
													 (rowTrackerScale) ? [NSString stringWithUTF8String:rowTrackerScale] : @"",
													 [NSNumber numberWithInt:localStudentNameID],
													 (rowStudentName) ? [NSString stringWithUTF8String:rowStudentName] : @"",
													 (studentFirstname) ? [NSString stringWithUTF8String:studentFirstname] : @"",
													 (studentEmail) ? [NSString stringWithUTF8String:studentEmail] : @"",
													 (phone1) ? [NSString stringWithUTF8String:phone1] : @"",
													 (parentName) ? [NSString stringWithUTF8String:parentName] : @"",
													 (guardianEmail) ? [NSString stringWithUTF8String:guardianEmail] : @"",
													 (phone2) ? [NSString stringWithUTF8String:phone2] : @"",
													 nil] retain]];
					
					int i = 0;
					while ([databaseHeaderArray count] > i) {
						char *newValue = (char *)sqlite3_column_text(statement, 11+i);
						NSString *newValueString = (newValue) ? [NSString stringWithUTF8String:newValue] : @"";
						[[databaseExportArray lastObject] addObject:newValueString];
						i +=1;
					}
					
					
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
		
		// now we need to build the CSV file with the database contents
		
		
		[databaseExportFileContentString appendFormat:@"Surname, First Name, Email, Phone, Guardian Name, Guardian Email, Guardian Phone"];
		
		// now loop through the new array and add each line into a comma separated text line with a newline character at the end
		int j=0;
		while ([databaseHeaderArray count] > j) {
			[databaseExportFileContentString appendFormat:@",%@", [[databaseHeaderArray objectAtIndex:j] objectAtIndex:2]];
			j +=1;
		} 
		
		[databaseExportFileContentString appendFormat:@"\r\n"];
		
		
		
		
		// now loop through the new array and add each line into a comma separated text line with a newline character at the end
		int i=0;
		while ([databaseExportArray count] > i) {
			[databaseExportFileContentString appendFormat:@"%@,%@,%@,%@,%@,%@, %@", [[databaseExportArray objectAtIndex:i] objectAtIndex:4], [[databaseExportArray objectAtIndex:i] objectAtIndex:5], [[databaseExportArray objectAtIndex:i] objectAtIndex:6], [[databaseExportArray objectAtIndex:i] objectAtIndex:7], [[databaseExportArray objectAtIndex:i] objectAtIndex:8], [[databaseExportArray objectAtIndex:i] objectAtIndex:9], [[databaseExportArray objectAtIndex:i] objectAtIndex:10]];
			
			int j=0;
			while ([databaseHeaderArray count] > j) {
				[databaseExportFileContentString appendFormat:@",%@", [[databaseExportArray objectAtIndex:i] objectAtIndex:11+j]];
				j +=1;
			} 
			
			[databaseExportFileContentString appendFormat:@"\r\n"];
			i +=1;
		} 
		
				
		// now send that file by email
		
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil)
		{
			// We must always check whether the current device is configured for sending emails
			if ([mailClass canSendMail])
			{
				[self sendEmailMessage:[NSData dataWithBytes:[databaseExportFileContentString UTF8String] length:[databaseExportFileContentString length]]];
			}
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to email this tracker as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
			}
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to email this tracker as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
		}
		
		
		 
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[pool release];
		
	}
	
}



#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)sendEmailMessage:(NSData *)withAttachedData
{
EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
	picker.mailComposeDelegate = self;
	
	[picker setSubject:customNavHeader.viewHeader.text];

	// Set up recipient - email is sent to address specified in Settings > Email Roll
	NSArray *toRecipients = [NSArray arrayWithObject:appDelegate.settings_personalEmail]; 
	[picker setToRecipients:toRecipients];
	
	// Attach the tracker attachment to the email
	[picker addAttachmentData:withAttachedData mimeType:@"text/csv" fileName:[NSString stringWithFormat:@"%@.csv",customNavHeader.viewHeader.text]];
	
	// Fill out the email body text
	NSString *emailBody = @" ";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Notice" message:@"Educate did not send the email; it has been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Email Cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Email Saved");
			alert = [[UIAlertView alloc] initWithTitle:@"Email Notice" message:@"Educate did not send the email; it has been saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
		case MFMailComposeResultSent:
			NSLog(@"Email Sent");
			alert = [[UIAlertView alloc] initWithTitle:@"Email Success" message:@"Educate has added the email to your Outbox.  If your iPhone cannot connect to your mail server to deliver the email immediately it will be queued for automatic delivery as soon as a mail connection can be made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Email Failed");
			alert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:@"Educate could not send the tracker because an email error occurred.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
		default:
			NSLog(@"Email Not Sent");
			alert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:@"Educate could not send the tracker because an email error occurred.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


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


- (void)dealloc {
	[localStudentNameArray release];
	[localDateRecordArray release];
	[scaleType release];
	[trackerID release];
	[customNavHeader release];
	[trackerTableView release];
	[trackerNameTableView release];
	[trackerScrollView release];
    [super dealloc];
}


@end

