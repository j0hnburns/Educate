//
//  StudentFeedbackTableViewController.m
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "StudentFeedbackTableViewController.h"
#import "StudentTrackerEditorViewController.h"
#import	"StudentTrackerSettingsViewController.h"
#import "StudentTrackerInstanceRecordViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"
#import "GoogleDocsListViewController.h"
#import "GDataDocs.h"
#import "GDataServiceGoogleDocs.h"
#import "GDataEntryDocBase.h"
#import "GDataEntryStandardDoc.h"


@implementation StudentFeedbackTableViewController

@synthesize studentTrackerArray;
@synthesize customNavHeader;
@synthesize viewBackground;
@synthesize settingsButton;
@synthesize syncButton;
@synthesize trackerScrollView;
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
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Tracker";
	[self.view addSubview:customNavHeader];
	
	settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(250, 5, 70, 30);
	[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	[settingsButton setBackgroundColor:[UIColor clearColor]];
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[settingsButton addTarget:self action:@selector(showSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	
	syncButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	syncButton.frame = CGRectMake(10, 5, 39, 30);
	[syncButton setBackgroundColor:[UIColor clearColor]];
	[syncButton setBackgroundImage:[UIImage imageNamed:@"syncButton.png"] forState:UIControlStateNormal];
	[syncButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	syncButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[syncButton addTarget:self action:@selector(chooseSyncOption) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:syncButton];
	
	trackerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 365)];
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
	
	
	trackerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,365) style:UITableViewStyleGrouped];
	trackerTableView.delegate = self;
	trackerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	trackerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	trackerTableView.rowHeight = 40;
	trackerTableView.backgroundColor = [UIColor clearColor];
	trackerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[trackerScrollView addSubview:trackerTableView];
	
	
	[trackerScrollView setContentSize:CGSizeMake(320, 365)];
	errorWasDueToAuthentication = NO;

	// Setup Google Docs Service
	
		EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	service = [[GDataServiceGoogleDocs alloc] init];
	
	[service setUserCredentialsWithUsername:appDelegate.settings_googleEmail
								   password:appDelegate.settings_googlePassword];
	[service setUserAgent:@"iKonstrukt-Educate-20"]; // set this to yourName-appName-appVersion
	[service setShouldCacheDatedData:YES];
	[service setServiceShouldFollowNextLinks:YES];
	
		NSURL *feedURL = [NSURL URLWithString:kGDataGoogleDocsDefaultPrivateFullFeed];
		
		GDataServiceTicket *ticket;
		GDataQueryDocs *query = [GDataQueryDocs documentQueryWithFeedURL:feedURL];
		[query setMaxResults:1000];
		[query setShouldShowFolders:YES];
		
		ticket = [service fetchFeedWithQuery:query
									delegate:self
						   didFinishSelector:@selector(docListFetchTicket:finishedWithFeed:error:)];
		

	
	
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
	[self initialiseStudentTrackerArray];
	[trackerTableView reloadData];
    [super viewWillAppear:animated];
	
	
	// Setup Google Docs Service
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[service setUserCredentialsWithUsername:appDelegate.settings_googleEmail
								   password:appDelegate.settings_googlePassword];
	[service setUserAgent:@"iKonstrukt-Educate-20"]; // set this to yourName-appName-appVersion
	[service setShouldCacheDatedData:YES];
	[service setServiceShouldFollowNextLinks:YES];
	
	NSURL *feedURL = [NSURL URLWithString:kGDataGoogleDocsDefaultPrivateFullFeed];
	
	GDataServiceTicket *ticket;
	GDataQueryDocs *query = [GDataQueryDocs documentQueryWithFeedURL:feedURL];
	[query setMaxResults:1000];
	[query setShouldShowFolders:YES];
	
	ticket = [service fetchFeedWithQuery:query
								delegate:self
					   didFinishSelector:@selector(docListFetchTicket:finishedWithFeed:error:)];
	
	
	
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [studentTrackerArray count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// prepare the studentTrackerInstanceRecord view and push it onto the view controller
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	StudentTrackerInstanceRecordViewController *studentTrackerInstanceRecordViewController = [[StudentTrackerInstanceRecordViewController alloc] initWithNibName:nil bundle:nil];    
	
	[studentTrackerInstanceRecordViewController populateStudentListForTracker:[[[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue] withScaleType:[[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:2]]; 
	NSLog(@"Displaying Tracker With ID %i",[[[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue]);
	studentTrackerInstanceRecordViewController.customNavHeader.viewHeader.text = [[studentTrackerArray objectAtIndex:indexPath.row] objectAtIndex:1];
	//studentTrackerInstanceRecordViewController.customNavHeader.lowerSubHeading.text = @"";

	[[self navigationController] pushViewController:studentTrackerInstanceRecordViewController animated:YES];

	[studentTrackerInstanceRecordViewController release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
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
// old code unused function in version 2.0+
	 }

- (void)showSettingsViewController {
	// load new navigation controller and put settings view into the controller, then pop as modal controller
	StudentTrackerSettingsViewController *studentTrackerSettingsViewController = [StudentTrackerSettingsViewController alloc];
	UINavigationController *studentTrackerSettingsNavigationController = [[UINavigationController alloc] initWithRootViewController:studentTrackerSettingsViewController];
    
	// present navigation controller as modal controller
	[self.navigationController presentModalViewController:studentTrackerSettingsNavigationController animated:YES];
	// now release controller objects
	[studentTrackerSettingsNavigationController release];
    [studentTrackerSettingsViewController release];
	
	
}


// Code for Google Docs Syncing

- (void)chooseSyncOption {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"*%@*", appDelegate.settings_googleEmail);
	if ([appDelegate.settings_googleEmail length] == 0) {
		// if the Google settings 
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Google Account" message:@"Please enter your Gmail account details in the Settings page.  If you do not have a Gmail account visit www.gmail.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	} else {
	
	// display an alert asking whether to 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose Import or Export" message:@"Do you wish to Export your Trackers to Google Docs or Import a Tracker?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Export" ,@"Import", nil];
	[alert show];	
	[alert release];
	
	}
	
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) { // Export was pushed
			[self exportTrackerDatabaseToGoogleDocs];
	} else if (buttonIndex == 2) { // Import was pushed
		// run import code
		// load navigation controller for google docs module and initialise
		GoogleDocsListViewController* googleDocsListViewController = [[GoogleDocsListViewController alloc] initWithNibName:nil bundle:nil];
		[[self navigationController] pushViewController:googleDocsListViewController animated:YES];
		[googleDocsListViewController release];
		
	}
}

- (void)exportTrackerDatabaseToGoogleDocs {

	[NSThread detachNewThreadSelector:@selector(exportTrackerDatabaseToGoogleDocsInThread) toTarget:self withObject:nil];
	
}

- (void)exportTrackerDatabaseToGoogleDocsInThread {
	// retrieve a list of the trackerIDs for the tracker database
	// for each tracker ID, execute the Google export code to send an .csv export to the Google Docs server
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	shouldDisplayErrorMessageAndAbort = NO;
	hasCalledExportASecondTime = NO;
	hasDisplayedAnErrorMessage = NO;
	errorWasDueToAuthentication = NO;
	if (appDelegate.internetConnectionStatus == NotReachable) {
		
		// if first offline failure then notify user with alert box
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to export your trackers.  You will not be able to use the export feature until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	} else if ([appDelegate.settings_googleEmail length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Google Account" message:@"Please enter your Gmail account details in the Settings page.  If you do not have a Gmail account visit www.gmail.com." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	}

	else {
		
		
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		
		
		// build the array of trackerIDs
		
		NSMutableArray* trackerIDArray = [[NSMutableArray alloc] init];
		
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
		
		// build and run the query for the header rows
		// we use the values in the array to build the value query in the next step
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "select trackerID, trackerName from studentTracker order by trackerID asc";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// Execute the query.
				//int success =sqlite3_step(statement);

				
				while (sqlite3_step(statement) == SQLITE_ROW) {
					int rowTrackerID = sqlite3_column_int(statement, 0);
					char *rowTrckerName = (char *)sqlite3_column_text(statement, 1);
										
					[trackerIDArray addObject:[[NSMutableArray arrayWithObjects:
													 [NSNumber numberWithInt:rowTrackerID],
													 (rowTrckerName) ? [NSString stringWithUTF8String:rowTrckerName] : @"",
													nil] retain]];
					
					
					
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
		
		pendingUploads = 0;
		uploadHasStartedAcceptingData = NO;
					 int i = 0;
					 
					 while ([trackerIDArray count] > i) {
						 
						 //if (pendingUploads > 
						 pendingUploads += 1;
						 
						 [NSThread sleepForTimeInterval:1.5];
						 //NSLog(@"Calling exportIndividualTrackerToGoogleDocs:%i",[[trackerIDArray objectAtIndex:i] objectAtIndex:1]);
						 [self exportIndividualTrackerToGoogleDocs:[[[trackerIDArray objectAtIndex:i] objectAtIndex:0] intValue] withTrackerName:[[trackerIDArray objectAtIndex:i] objectAtIndex:1]];
						 
						 i += 1;
						 
						// [NSThread sleepForTimeInterval:0.2];
					}
		 
					 
		//[self exportIndividualTrackerToGoogleDocs:1];
		
		[NSThread detachNewThreadSelector:@selector(startProgressTimeoutTimer) toTarget:self withObject:nil];
		
		[pool release];
		
	}
	
}



- (void)exportIndividualTrackerToGoogleDocs:(int)forTrackerID withTrackerName:(NSString *)trackerName {
	// builds a .csv file containing the tracker data and sends it to the email script on the server
	
	//EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	

	
	NSLog(@"exportIndividualTrackerToGoogleDocs:%i start",forTrackerID);
		
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
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
				sqlite3_bind_int(statement, 1, forTrackerID);
				
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
				
				[sqlStatementString appendFormat:@", (select v.recordValue from studentTrackerInstanceRecord v where v.studentID = l.studentNameID and v.studentTrackerDateID = %i and v.studentTrackerID = %i)", [[[databaseHeaderArray objectAtIndex:i] objectAtIndex:0] intValue], forTrackerID];
				i +=1;
			}
			
			[sqlStatementString appendFormat:@" from studentTracker t, studentTrackerStudentList l where t.trackerID = l.studentTrackerID AND t.trackerID=%i order by t.trackerID asc, l.studentNameID asc", forTrackerID];
			
			//const char *sql = "select t.trackerID, t.trackerName, t.trackerScale, r.creationDate, r.dateLabel, l.studentNameID, l.studentName, l.studentFirstname, l.studentEmail, l.phone1, l.parentName, l.phone2, v.recordValue from studentTracker t, studentTrackerDateRecord r, studentTrackerInstanceRecord v, studentTrackerStudentList l where t.trackerID = r.studentTrackerID and t.trackerID = v.studentTrackerID and t.trackerID = l.studentTrackerID and l.studentNameID = v.studentID and v.studentTrackerDateID = r.studentTrackerDateID AND t.studentTrackerID=? order by t.trackerID asc, l.studentNameID asc, r.studentTrackerDateID";
			const char *sql = [sqlStatementString UTF8String];
			
			//NSLog(@"SQL Export String:\r\r%@", sqlStatementString);
			
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// bind the query variables
				sqlite3_bind_int(statement, 1, forTrackerID);
				
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
			//NSLog(@"Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
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
		
		//NSLog(@"exportIndividualTrackerToGoogleDocs:%i export: %@",forTrackerID, databaseExportFileContentString);
			
	NSArray* dataTransferArray = [[NSArray alloc] initWithObjects:databaseExportFileContentString,
																trackerName,
																path,
																[NSNumber numberWithInt:forTrackerID],
								  nil];
	
	[self performSelectorOnMainThread:@selector(performGoogleUploadOnMainThreadWithUploadArray:) withObject:dataTransferArray waitUntilDone:YES];
	
	
		[pool release];
		
	
	
}

- (void)performGoogleUploadOnMainThreadWithUploadArray:(NSArray *)dataTransferArray {
	
	// now send that file to Google Docs
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *errorMsg = nil;
	
	// make a new entry for the file
	
	
	NSData* uploadData = [NSData dataWithBytes:[[dataTransferArray objectAtIndex:0] UTF8String] length:[[dataTransferArray objectAtIndex:0] length]];
	NSString *trackerUploadFileName = [NSString stringWithFormat:@"ET_%@.csv", [dataTransferArray objectAtIndex:1]];
	
	
	GDataEntryDocBase *newEntry = [GDataEntryStandardDoc documentEntry];
	
	
	[newEntry setTitleWithString:trackerUploadFileName];
	
	
	if (!uploadData) {
		errorMsg = [NSString stringWithFormat:@"cannot read file %@", [dataTransferArray objectAtIndex:2]];
	}
	
	if (uploadData) {
		[newEntry setUploadData:uploadData];
		
		[newEntry setUploadMIMEType:@"text/csv"];
		[newEntry setUploadSlug:trackerUploadFileName];
		
		
		NSURL *postURL = [[mDocListFeed postLink] URL];
		
		
		// make service tickets call back into our upload progress selector
		SEL progressSel = @selector(inputStream:hasDeliveredByteCount:ofTotalByteCount:);
		[service setServiceUploadProgressSelector:progressSel];
		
		// insert the entry into the docList feed
		GDataServiceTicket *ticket;
		
		
		/*
		 ticket = [service fetchEntryByUpdatingEntry:newEntry
		 forEntryURL:(NSURL *)entryURL
		 delegate:self
		 didFinishSelector:@selector(uploadFileTicket:finishedWithEntry:error:)];
		 */
		
		
		ticket = [service fetchEntryByInsertingEntry:newEntry
										  forFeedURL:postURL
											delegate:self
								   didFinishSelector:@selector(uploadFileTicket:finishedWithEntry:error:)];
		
		
		// we don't want future tickets to always use the upload progress selector
		//[service setServiceUploadProgressSelector:nil];
		
		[self setUploadTicket:ticket];
		NSLog(@"exportIndividualTrackerToGoogleDocs:%i upload data sent",[[dataTransferArray objectAtIndex:3] intValue]);
	}
	
	
	if (errorMsg) {
		// we're currently in the middle of the file selection sheet, so defer our
		// error sheet
		NSLog(@"exportIndividualTrackerToGoogleDocs:%i error",[[dataTransferArray objectAtIndex:3] intValue]);
		shouldDisplayErrorMessageAndAbort = YES;
	}
	
	
	[pool release];
	
}

- (void)startProgressTimeoutTimer {
	
	// this function is called on a background thread to check the progress of the Google Docs export process
	// sometimes the export process 'hangs' - does not start uploading data - and running the code again tends to solve the issue
	// this function waits for 10 seconds then checks if the upload process has started accepting data
	// if no data is accepted after 10 seconds the export function is called again on the main thread
	
	[NSThread sleepForTimeInterval:10];
	
	if (shouldDisplayErrorMessageAndAbort) {
		
		if (!hasDisplayedAnErrorMessage) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export Failed" message:@"Your Google Docs account could not be accessed.  Please check your details are correctly entered in ‘Settings’ and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			hasDisplayedAnErrorMessage = YES;
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
		
		
	} else if (!uploadHasStartedAcceptingData && !hasCalledExportASecondTime) {
		NSLog(@"Reperforming the upload as no data was returned");
		[self performSelectorOnMainThread:@selector(exportTrackerDatabaseToGoogleDocs) withObject:nil waitUntilDone:NO];
		hasCalledExportASecondTime = YES; // only call the export again once - otherwise fail after that
	}
	
}


- (GDataServiceTicket *)uploadTicket {
	return mUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket {
	[mUploadTicket release];
	mUploadTicket = [ticket retain];
}



// progress callback
- (void)inputStream:(GDataProgressMonitorInputStream *)stream 
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
   ofTotalByteCount:(unsigned long long)dataLength {
	   uploadHasStartedAcceptingData = YES;
	//[mUploadProgressIndicator setMinValue:0.0];
	//[mUploadProgressIndicator setMaxValue:(double)dataLength];
	//[mUploadProgressIndicator setDoubleValue:(double)numberOfBytesRead];
	NSLog(@"Uploading File: bytes uploaded");
}

// upload finished callback
- (void)uploadFileTicket:(GDataServiceTicket *)ticket
	   finishedWithEntry:(GDataEntryDocBase *)entry
                   error:(NSError *)error {
	
	[self setUploadTicket:nil];
	//[mUploadProgressIndicator setDoubleValue:0.0];
	
	if (error == nil) {
		// refetch the current doc list
		//[self fetchDocList];
		NSLog(@"Upload Completed Successfully");
		// tell the user that the add worked
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Backup Complete" message:@"The backup operation was successful and you should receive an email with the database backup shortly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		//[alert show];	
		//[alert release];
	
	} else {
		shouldDisplayErrorMessageAndAbort = YES;
		NSLog(@"Upload Failed With Error: %@", error);
		if (!hasDisplayedAnErrorMessage) {

			if (error.code == 403) {
			
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export Failed" message:@"One or more of your Trackers could not be exported to Google Docs.  This is most likely due to an incorrect Google Docs email and/or Password.  Please check your Google Docs settings and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
				hasDisplayedAnErrorMessage = YES;
				errorWasDueToAuthentication = YES;
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				
			} else {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export Failed" message:@"One or more of your Trackers could not be exported to Google Docs.  Please check your Google Docs settings and/or try again at a later time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
				hasDisplayedAnErrorMessage = YES;
				[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
				
				
			}
		}
	}
	pendingUploads -= 1;
	NSLog(@"exportIndividualTrackerToGoogleDocs end, %i uploads remaining",pendingUploads);
	
	if (pendingUploads == 0 && !shouldDisplayErrorMessageAndAbort) {
		
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Export Success!" message:@"Your Trackers have been  exported to Google Docs.  Visit http://docs.google.com to access them." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
	}
	
	
	

} 

- (void)docListFetchTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedDocList *)feed
                     error:(NSError *)error {
	
	[self setDocListFeed:feed];
	//[self setDocListFetchError:error];
	//[self setDocListFetchTicket:nil];
	
	//[self updateUI];
}

- (GDataFeedDocList *)docListFeed {
	return mDocListFeed; 
}

- (void)setDocListFeed:(GDataFeedDocList *)feed {
	[mDocListFeed autorelease];
	mDocListFeed = [feed retain];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[studentTrackerArray release];
	[customNavHeader release];
	[viewBackground release];
	[settingsButton release];
	[syncButton release];
	[trackerTableView release];
	[trackerScrollView release];
	
	[mDocListFeed release];
	[mUploadTicket cancelTicket];
	[mUploadTicket release];
    [super dealloc];
}


@end
