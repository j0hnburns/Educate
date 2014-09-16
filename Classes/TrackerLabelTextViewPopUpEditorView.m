//
//  TrackerLabelTextViewPopUpEditorView.m
//  GAY
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrackerLabelTextViewPopUpEditorView.h"
#import "EducateAppDelegate.h"


@implementation TrackerLabelTextViewPopUpEditorView

@synthesize backgroundImage;
@synthesize textCellBackgroundImage;
@synthesize textView;
@synthesize textReturnString;
@synthesize cancelButton;
@synthesize clearButton;
@synthesize saveButton;
@synthesize deleteButton;
@synthesize editingField;




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.textReturnString = [NSMutableString stringWithCapacity:1];
		
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor grayColor]];
	//[self.view setAlpha:0.5];
    self.view = view;
    [view release];
	
	// Background Image
	
	CGRect frame = CGRectMake(0, 0, 320, 480);
	backgroundImage = [[UIImageView alloc] initWithFrame:frame];
	backgroundImage.image = [UIImage imageNamed:@"scrollBackground.png"];
	[backgroundImage setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:backgroundImage];

	textCellBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,320,190)];
	textCellBackgroundImage.image = [UIImage imageNamed:@"edit-text-input-field.png"];
	[textCellBackgroundImage setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:textCellBackgroundImage];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
	textView.backgroundColor = [UIColor clearColor];
	textView.textColor = [UIColor colorWithRed:0.3828 green:0.3828 blue:0.3789 alpha:1];
	textView.font = [UIFont boldSystemFontOfSize:14];
	[textView setReturnKeyType:UIReturnKeyDefault];
	textView.editable = NO;
	textView.editable = YES;
	[self.view addSubview:textView];
	//[aboutMeLabel release];
	
	cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	cancelButton.frame = CGRectMake(10, 200, 50, 40);
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton setBackgroundColor:[UIColor clearColor]];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[cancelButton addTarget:self action:@selector(cancelChangesAndClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelButton];
	
	clearButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	clearButton.frame = CGRectMake(70, 200, 50, 40);
	[clearButton setTitle:@"Clear" forState:UIControlStateNormal];
	[clearButton setBackgroundColor:[UIColor clearColor]];
	[clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[clearButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[clearButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[clearButton addTarget:self action:@selector(clearTextValue) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:clearButton];
	
	deleteButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	deleteButton.frame = CGRectMake(130, 200, 100, 40);
	[deleteButton setTitle:@"Delete Column" forState:UIControlStateNormal];
	[deleteButton setBackgroundColor:[UIColor clearColor]];
	[deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[deleteButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[deleteButton addTarget:self action:@selector(deleteColumnAndClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:deleteButton];
	
	saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	saveButton.frame = CGRectMake(240, 200, 50, 40);
	[saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[saveButton setBackgroundColor:[UIColor clearColor]];
	[saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[saveButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[saveButton addTarget:self action:@selector(saveTextAndClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveButton];
	
	
	localEditingColumn = 0;
	localTrackerID = 0;
	
	
}


- (void)setLocalEditingColumn:(int)withInt {
	localEditingColumn = withInt;
}

- (void)setLocalTrackerID:(int)withInt {
	localTrackerID = withInt;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidAppear:(BOOL)animated {
	textView.text = textReturnString;
	[super viewDidAppear:animated];
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)saveTextAndClose {
	[textReturnString setString:textView.text];
	
		[textView resignFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)clearTextValue {
	textView.text = @"";
}

- (void)cancelChangesAndClose {
	[textView resignFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)deleteColumnAndClose {
	[textView resignFirstResponder];
	
	// set textReturnString to NULL so the calling class (title row) knows not to try to update the column value after it has been deleted
	[textReturnString setString:@"DONOTUPDATETHECOLUMNS"];
	//[textView.delegate setEditingColumnNumber:-1];
	
	// delete column from tracker
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	
	
	// delete the dateRecord
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "DELETE FROM studentTrackerDateRecord WHERE studentTrackerDateID = ? AND studentTrackerID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, localEditingColumn);
			sqlite3_bind_int(statement, 2, localTrackerID);
			
			// Execute the query.
			int success =sqlite3_step(statement);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			//NSLog(@"DELETE FROM studentTrackerDateRecord WHERE studentTrackerDateID = %i AND studentTrackerID = %i: success %i", localEditingColumn, localTrackerID, success);
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
	
	// delete the dateInstance entries
	if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerDateID = ? AND studentTrackerID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			
			
			// Bind the trackerID variable.
			sqlite3_bind_int(statement, 1, localEditingColumn);
			sqlite3_bind_int(statement, 2, localTrackerID);
			
			// Execute the query.
			int success =sqlite3_step(statement);
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			//NSLog(@"DELETE FROM studentTrackerInstanceRecord WHERE studentTrackerDateID = %i AND studentTrackerID = %i: success %i", localEditingColumn, localTrackerID, success);
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
	
	
	// now dismiss the view controller which should refresh the list without the column
	
	[self dismissModalViewControllerAnimated:YES];
	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[backgroundImage release];
	[textCellBackgroundImage release];
	[textView release];
	[textReturnString release];
	[cancelButton release];
	[clearButton release];
	[saveButton release];
	[deleteButton release];
	[editingField release];
    [super dealloc];
}


@end
