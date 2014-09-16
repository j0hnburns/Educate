//
//  DailyPlannerLessonInstanceNotesHistoryController.m
//  Educate
//
//  Created by James Hodge on 10/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DailyPlannerLessonInstanceNotesHistoryController.h"
#import "EducateAppDelegate.h"
#import "DailyPlannerLessonInstanceNotesHistoryCell.h"


@implementation DailyPlannerLessonInstanceNotesHistoryController


@synthesize localWeeklyPlannerArrayRow;
@synthesize notesHistoryArray;
@synthesize weeklyPlannerTableView;
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Notes History";
	[self.view addSubview:customNavHeader];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	weeklyPlannerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,51,495,395) style:UITableViewStylePlain];
	weeklyPlannerTableView.delegate = self;
	weeklyPlannerTableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	weeklyPlannerTableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	weeklyPlannerTableView.rowHeight = 40;
	weeklyPlannerTableView.backgroundColor = [UIColor clearColor];
	weeklyPlannerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:weeklyPlannerTableView];
	
	localWeeklyPlannerArrayRow = [NSNumber numberWithInt:0];
	
	// load temporary notesHistoryArray which will be edited when the view controller is configured with the period & weekday
	// array format: ID, period, weekdayName, date, note
	
	notesHistoryArray = [[NSMutableArray arrayWithObjects:
						  [[NSMutableArray arrayWithObjects:
							@"",
							@"",
							@"",
							@"9 Feb 08",
							@"Some Notes",
							nil] retain],
						  nil] retain];
	}
    return self;

	
	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
		
}


- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"Notes History Did Appear");
	[weeklyPlannerTableView reloadData];
 	//[self configureHistoryArray];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notesHistoryArray count];
	NSLog(@"History Table Returning %i Rows", [notesHistoryArray count]);
}



// will need to implement this when we have variable height table cells (ie expanding message bubbles)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat		result = 70;
	NSString*	text = nil;
	CGFloat		width = 225;
	text = [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:2];
	
	if (text)
	{
		// The notes can be of any height
		// This needs to work for both portrait and landscape orientations.
		// Calls to the table view to get the current cell and the rect for the 
		// current row are recursive and call back this method.
		CGSize		textSize = { width, 20000.0f };		// width and height of text area
		CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
		
		size.height += 27.0f;			// top and bottom margin
		
		result = MAX(size.height, 70);	// at least one row
	}
	
	return result;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DailyPlannerLessonInstanceNotesHistoryCell *cell = (DailyPlannerLessonInstanceNotesHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"DailyPlannerLessonInstanceNotesHistoryCell"];
	if (cell == nil) {
		cell = [[[DailyPlannerLessonInstanceNotesHistoryCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DailyPlannerLessonInstanceNotesHistoryCell"] autorelease];
	}
	// Configure the cell
	
	cell.noteContent.text = [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:2];	
	cell.noteDate.text =  [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:1];
	
	
	[cell setLeftAlignment];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

- (void)setLocalValues:(int)withPeriodID andWeekday:(int)withWeekday {
	periodID = withPeriodID;
	weekday = withWeekday;
	NSLog(@"History Setting Local Values: sentPeriod %i, localPeriod %i, sentWeekday %i, localWeekday %i",withPeriodID, periodID, withWeekday, weekday);
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)configureHistoryArray:(NSNumber *)withWeeklyPlannerRow {	
	// setup the history array
	// first clear out the dummy data placed in the init function
	// then build the array using the appDelegate weeklyPlannerNotesArray
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	
	while ([notesHistoryArray count] > 0) {
		[notesHistoryArray removeLastObject];
	}
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	
	//  query notes database and return the all notes entries sorted by date
	// the notes values will be appended to the local array as object 0 (noteID), 1 (date) and 2 (note)
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT rowid, date, note FROM weeklyPlannerNotes WHERE periodID = ? AND weekday = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, periodID);
			sqlite3_bind_int(statement, 2, weekday);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT rowid, date, note from weeklyPlannerNotes where periodID = %i and weekday = %i", periodID, weekday);
			
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int rowNoteID = sqlite3_column_int(statement, 0);
				char *rowDate = (char *)sqlite3_column_text(statement, 1);
				char *rowNote = (char *)sqlite3_column_text(statement, 2);	
				
				[notesHistoryArray addObject:[[NSMutableArray arrayWithObjects:
											   [NSNumber numberWithInt:rowNoteID],
											   (rowDate) ? [NSString stringWithUTF8String:rowDate] : @"",
											   (rowNote) ? [NSString stringWithUTF8String:rowNote] : @"",
											   nil] retain]];
				
				NSLog(@"Notes Query Returned Row %i, %@, %@ for current array count of %i", rowNoteID,(rowDate) ? [NSString stringWithUTF8String:rowDate] : @"",(rowNote) ? [NSString stringWithUTF8String:rowNote] : @"" , [notesHistoryArray count]);
				
				rowNumber +=1;
			}
			
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Notes History Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	
	
	[weeklyPlannerTableView reloadData];
	[pool release];
	
}


- (void)dealloc {
	
	[localWeeklyPlannerArrayRow release];
	[notesHistoryArray release];
	[weeklyPlannerTableView release];
	[customNavHeader release];
	[viewBackground release];
    [super dealloc];
}


@end

