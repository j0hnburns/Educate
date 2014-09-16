//
//  StudentTrackerInstanceHeaderCell.m
//  Educate
//
//  Created by James Hodge on 18/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerInstanceHeaderCell.h"
#import "TrackerLabelTextViewPopUpEditorView.h"
#import "EducateAppDelegate.h"


@implementation StudentTrackerInstanceHeaderCell


@synthesize localDateRecordArray;
@synthesize buttonArray;
@synthesize mutableTitleString;
@synthesize localTrackerTableView;
@synthesize localControllerInstance;




- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		// check whether the add tracker column message has been shown by retrieving saved setting from defaults
		hasShownAddTrackerColumnArchiveMessage = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownAddTrackerColumnArchiveMessage"];
	
		localDateRecordArray = [[NSMutableArray alloc] init];
	
		
		editingColumnNumber = -1;
		
		buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

-(void)populateHeaderLabelsFromArray {
	
	// loop through the localDateRecordArray and create a new button for each instance in the array
	// add the buttons into the buttonArray so they can be referenced later
	
	while ([buttonArray count] > 0) {
		[[buttonArray lastObject] removeFromSuperview];
		[buttonArray removeLastObject];
	}
	
	int i = 0;
	
	while ([localDateRecordArray count] > i) {
		
		UIButton* headerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		headerButton.frame = CGRectMake(85*i, 0, 85, 40);
		[headerButton setTitle:[[localDateRecordArray objectAtIndex:i] objectAtIndex:1] forState:UIControlStateNormal];
		[headerButton setBackgroundColor:[UIColor whiteColor]];
		[headerButton setBackgroundImage:[UIImage imageNamed:@"tabTop.png"] forState:UIControlStateNormal];
		[headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[headerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		headerButton.tag = i;
		[headerButton addTarget:self action:@selector(setTrackerValueForColumnRepresentedBySender:) forControlEvents:UIControlEventTouchUpInside];
		[buttonArray addObject:headerButton];
		[self.contentView addSubview:headerButton];
		//[headerButton release];
		NSLog(@"Created headerButton with title %@", [[localDateRecordArray objectAtIndex:i] objectAtIndex:1]);
		
		i +=1;
		
	}
		
	// add the 'Add Column' button onto the end of the array
	
	UIButton* addColumnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	addColumnButton.frame = CGRectMake(85*i, 0, 85, 40);
	[addColumnButton setTitle:@"+" forState:UIControlStateNormal];
	[addColumnButton setBackgroundColor:[UIColor whiteColor]];
	[addColumnButton setBackgroundImage:[UIImage imageNamed:@"tabTop.png"] forState:UIControlStateNormal];
	[addColumnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[addColumnButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	addColumnButton.tag = i;
	[addColumnButton addTarget:self action:@selector(setTrackerValueForColumnRepresentedBySender:) forControlEvents:UIControlEventTouchUpInside];
	[buttonArray addObject:addColumnButton];
	[self.contentView addSubview:addColumnButton];

	
	

}


- (void)setEditingColumnNumber:(int)withColumnNumber {
	editingColumnNumber = withColumnNumber;
}

- (void)updateValueFromTextEditor {
	//if view appears and the editingColumnNumber value is configured, set that button value to the return string value
	
	if ((editingColumnNumber != -1) && ([localDateRecordArray count] > 0) && (![mutableTitleString isEqualToString:@"DONOTUPDATETHECOLUMNS"])) {
		[[buttonArray objectAtIndex:editingColumnNumber] setTitle:mutableTitleString forState:UIControlStateNormal];
		[self saveTrackerTitle:mutableTitleString forTrackerID:[[[localDateRecordArray objectAtIndex:editingColumnNumber] objectAtIndex:0] intValue]]; 
		editingColumnNumber = -1;
	}
}

- (void)setTrackerValueForColumnRepresentedBySender:(id)sender {
	
	//int i = 0;
	editingColumnNumber = [sender tag];
	
	/*
	while ([buttonArray count] > i) {
		if ([buttonArray objectAtIndex:i] == sender) {
			editingColumnNumber = i;
		}
		i += 1;
	}
	*/
	if ([localDateRecordArray count] > editingColumnNumber) {
		[self startEditingTrackerLabelValue]; // tag relates to a 'normal' column header, so display the editing code
	} else {
		[self createNewResultsColumn]; // tag relates to the 'add column' header, so add a new column
	}
}



- (void)createNewResultsColumn {
		// create a new entry in the studentTrackerDateRecord table and refresh the table view to display that column.
	editingColumnNumber = -1;
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	//  check if the first-time alert message has been displayed, and if not display it now
	
	if (!hasShownAddTrackerColumnArchiveMessage) {
		// we no longer display the archive message as we show unlimited columns
		/*
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Student Tracker" message:@"The Student Tracker can store an unlimited number of columns but only the most recent 6 columns are displayed.  Export your database (from the Settings tab) to obtain the full archive of your tracker entries." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		*/
		hasShownAddTrackerColumnArchiveMessage = YES;
		[[NSUserDefaults standardUserDefaults] setBool:hasShownAddTrackerColumnArchiveMessage forKey:@"hasShownAddTrackerColumnArchiveMessage"];
	}
	
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
			sqlite3_bind_int(statement, 1, trackerID);
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
	

	[[[[appDelegate tabBarController] selectedViewController] visibleViewController] initialiseStudentListArray];
	
    [pool release];
	
}

- (void)setTrackerID:(int)withTrackerID {
	trackerID = withTrackerID;
}


- (void)startEditingTrackerLabelValue {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	mutableTitleString = [NSMutableString stringWithCapacity:1];
	[mutableTitleString setString:[[localDateRecordArray objectAtIndex:editingColumnNumber] objectAtIndex:1]];
	
	TrackerLabelTextViewPopUpEditorView* textViewPopUpEditorView = [[TrackerLabelTextViewPopUpEditorView alloc] initWithNibName:nil bundle:nil];    
	textViewPopUpEditorView.title = @"Edit Tracker Heading";
	textViewPopUpEditorView.textReturnString = mutableTitleString;
	textViewPopUpEditorView.textView.text = [[localDateRecordArray objectAtIndex:0] objectAtIndex:1];
	textViewPopUpEditorView.textView.delegate = self;
	textViewPopUpEditorView.editingField = @"aboutMe";
	[textViewPopUpEditorView.view setAlpha:0.8];
	
	[textViewPopUpEditorView setLocalEditingColumn:[[[localDateRecordArray objectAtIndex:editingColumnNumber] objectAtIndex:0] intValue]];
	[textViewPopUpEditorView setLocalTrackerID:trackerID];
	
	[[appDelegate tabBarController] presentModalViewController:textViewPopUpEditorView animated:YES];
	
	[textViewPopUpEditorView release];
	
}


- (void)saveTrackerTitle:(NSString *)title forTrackerID:(int)localTrackerID {

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
			const char *sql = "UPDATE studentTrackerDateRecord SET dateLabel = ? WHERE studentTrackerDateID=?";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// Bind the trackerID variable.
				
				sqlite3_bind_text(statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
				sqlite3_bind_int(statement, 2, localTrackerID);
				
				// Execute the query.
				int success =sqlite3_step(statement);
				NSLog(@"Update studentTrackerDateRecord Returned %i",success);
				
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
	[localDateRecordArray release];
	[buttonArray release];
	[mutableTitleString release];
	[localTrackerTableView release];
	[localControllerInstance release];
    [super dealloc];
	
}


@end