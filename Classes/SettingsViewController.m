//
//  SettingsViewController.m
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "SettingsViewController.h"
#import "CustomNavigationHeader.h"
#import "EducateAppDelegate.h"
// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					150.0

@implementation SettingsViewController

@synthesize viewBackground;
@synthesize customNavHeader;
@synthesize emailRollButton;
@synthesize googleButton;
@synthesize moodleButton;
@synthesize sectionHeaderLabel;
@synthesize firstFieldLabel;
@synthesize secondFieldLabel;
@synthesize thirdFieldLabel;
@synthesize googleDocsHintLabel;
@synthesize backupDatabaseButton;
@synthesize personalFullNameField;
@synthesize personalEmailField;
@synthesize moodleEmailField;
@synthesize moodlePasswordField;
@synthesize moodleURLField;
@synthesize googleEmailField;
@synthesize googlePasswordField;
@synthesize blackboardURLField;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		
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
    [super viewDidLoad];
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Settings";
	[self.view addSubview:customNavHeader];
	
	/*
	 UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	 backButton.frame = CGRectMake(0, 0, 53, 40);
	 [backButton setTitle:@"" forState:UIControlStateNormal];
	 [backButton setBackgroundColor:[UIColor clearColor]];
	 [backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
	 [backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	 [customNavHeader addSubview:backButton];
	 */
	
	emailRollButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	emailRollButton.frame = CGRectMake(10, 60, 102, 45);
	[emailRollButton setTitle:@"Email Roll" forState:UIControlStateNormal];
	[emailRollButton setBackgroundColor:[UIColor clearColor]];
	[emailRollButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[emailRollButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
	[emailRollButton addTarget:self action:@selector(showPersonalSettings) forControlEvents:UIControlEventTouchUpInside];
	emailRollButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:emailRollButton];
	
	moodleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	moodleButton.frame = CGRectMake(110, 60, 102, 45);
	[moodleButton setTitle:@"Moodle" forState:UIControlStateNormal];
	[moodleButton setBackgroundColor:[UIColor clearColor]];
	[moodleButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[moodleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[moodleButton addTarget:self action:@selector(showMoodleSettings) forControlEvents:UIControlEventTouchUpInside];
	moodleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	//[self.view addSubview:moodleButton];
	
	googleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	googleButton.frame = CGRectMake(110, 60, 102, 45);
	[googleButton setTitle:@"Google Docs" forState:UIControlStateNormal];
	[googleButton setBackgroundColor:[UIColor clearColor]];
	[googleButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[googleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[googleButton addTarget:self action:@selector(showGoogleSettings) forControlEvents:UIControlEventTouchUpInside];
	googleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[self.view addSubview:googleButton];
	
	
	sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 144.0, 150.0, 40)];
	sectionHeaderLabel.text = @"Email Roll:";
	sectionHeaderLabel.backgroundColor = [UIColor clearColor];
	sectionHeaderLabel.textColor = [UIColor darkGrayColor];
	sectionHeaderLabel.textAlignment = UITextAlignmentLeft;
	sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:22];
	[self.view addSubview:sectionHeaderLabel];
	//[sectionHeaderLabel release];
	
	firstFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 280.0, 250.0, 30)];
	firstFieldLabel.text = @"Contact Email:";
	firstFieldLabel.backgroundColor = [UIColor clearColor];
	firstFieldLabel.textColor = [UIColor darkGrayColor];
	firstFieldLabel.textAlignment = UITextAlignmentLeft;
	firstFieldLabel.font = [UIFont boldSystemFontOfSize:16];
	[self.view addSubview:firstFieldLabel];
	//[firstFieldLabel release];
	
	
	personalFullNameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 230.0, 30)];
	personalFullNameField.backgroundColor = [UIColor clearColor];
	personalFullNameField.textColor = [UIColor blackColor];
	personalFullNameField.textAlignment = UITextAlignmentLeft;
	personalFullNameField.borderStyle = UITextBorderStyleRoundedRect;
	personalFullNameField.delegate = self;
	[personalFullNameField setReturnKeyType:UIReturnKeyDone];
	personalFullNameField.autocorrectionType=UITextAutocorrectionTypeNo;
	personalFullNameField.text = appDelegate.settings_personalFullName;
	//[self.view addSubview:personalFullNameField];	
	//[personalFullNameField release];
	
	moodleEmailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 230.0, 30)];
	moodleEmailField.backgroundColor = [UIColor clearColor];
	moodleEmailField.textColor = [UIColor blackColor];
	moodleEmailField.textAlignment = UITextAlignmentLeft;
	moodleEmailField.borderStyle = UITextBorderStyleRoundedRect;
	moodleEmailField.delegate = self;
	[moodleEmailField setReturnKeyType:UIReturnKeyDone];
	[moodleEmailField setKeyboardType:UIKeyboardTypeURL];
	moodleEmailField.autocorrectionType=UITextAutocorrectionTypeNo;
	moodleEmailField.text = appDelegate.settings_moodleEmail;
	moodleEmailField.hidden = YES;
	[self.view addSubview:moodleEmailField];	
	//[moodleEmailField release];
	
	googleEmailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, 230.0, 30)];
	googleEmailField.backgroundColor = [UIColor clearColor];
	googleEmailField.textColor = [UIColor blackColor];
	googleEmailField.textAlignment = UITextAlignmentLeft;
	googleEmailField.borderStyle = UITextBorderStyleRoundedRect;
	googleEmailField.delegate = self;
	[googleEmailField setReturnKeyType:UIReturnKeyDone];
	googleEmailField.autocorrectionType=UITextAutocorrectionTypeNo;
	googleEmailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	[googleEmailField setKeyboardType:UIKeyboardTypeURL];
	googleEmailField.text = appDelegate.settings_googleEmail;
	googleEmailField.placeholder = @"eg educateapp@gmail.com";
	googleEmailField.hidden = YES;
	[self.view addSubview:googleEmailField];	
	//[blackboardEmailField release];
	
	
	
	secondFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 240.0, 250.0, 30)];
	secondFieldLabel.text = @"Contact Email:";
	secondFieldLabel.backgroundColor = [UIColor clearColor];
	secondFieldLabel.textColor = [UIColor darkGrayColor];
	secondFieldLabel.textAlignment = UITextAlignmentLeft;
	secondFieldLabel.font = [UIFont boldSystemFontOfSize:16];
	secondFieldLabel.hidden = YES;
	[self.view addSubview:secondFieldLabel];
	//[secondFieldLabel release];
	
	
	personalEmailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 310, 230.0, 30)];
	personalEmailField.backgroundColor = [UIColor clearColor];
	personalEmailField.textColor = [UIColor blackColor];
	personalEmailField.textAlignment = UITextAlignmentLeft;
	personalEmailField.borderStyle = UITextBorderStyleRoundedRect;
	personalEmailField.delegate = self;
	[personalEmailField setReturnKeyType:UIReturnKeyDone];
	personalEmailField.autocorrectionType=UITextAutocorrectionTypeNo;
	personalEmailField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	[personalEmailField setKeyboardType:UIKeyboardTypeURL];
	personalEmailField.text = appDelegate.settings_personalEmail;
	[self.view addSubview:personalEmailField];	
	//[personalEmailField release];
	
	moodlePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 270, 230.0, 30)];
	moodlePasswordField.backgroundColor = [UIColor clearColor];
	moodlePasswordField.textColor = [UIColor blackColor];
	moodlePasswordField.textAlignment = UITextAlignmentLeft;
	moodlePasswordField.borderStyle = UITextBorderStyleRoundedRect;
	moodlePasswordField.delegate = self;
	[moodlePasswordField setReturnKeyType:UIReturnKeyDone];
	moodlePasswordField.autocorrectionType=UITextAutocorrectionTypeNo;
	moodlePasswordField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	moodlePasswordField.text = appDelegate.settings_moodlePassword;
	moodlePasswordField.secureTextEntry = YES;
	[self.view addSubview:moodlePasswordField];	
	moodlePasswordField.hidden = YES;
	//[moodlePasswordField release];
	
	googlePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 270, 230.0, 30)];
	googlePasswordField.backgroundColor = [UIColor clearColor];
	googlePasswordField.textColor = [UIColor blackColor];
	googlePasswordField.textAlignment = UITextAlignmentLeft;
	googlePasswordField.borderStyle = UITextBorderStyleRoundedRect;
	googlePasswordField.delegate = self;
	[googlePasswordField setReturnKeyType:UIReturnKeyDone];
	googlePasswordField.autocorrectionType=UITextAutocorrectionTypeNo;
	googlePasswordField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	googlePasswordField.text = appDelegate.settings_googlePassword;
	googlePasswordField.secureTextEntry = YES;
	[self.view addSubview:googlePasswordField];	
	googlePasswordField.hidden = YES;
	//[blackboardPasswordField release];
	
	// database backup to email button
	
	googleDocsHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 160, 280.0, 140)];
	googleDocsHintLabel.text = @"This feature allows you to email class rolls to admin staff. Enter the contact email address here and then simply click the email icon within an attendance Tracker to send the roll.";
	googleDocsHintLabel.backgroundColor = [UIColor clearColor];
	googleDocsHintLabel.textColor = [UIColor darkGrayColor];
	googleDocsHintLabel.textAlignment = UITextAlignmentLeft;
	googleDocsHintLabel.numberOfLines = 0;
	googleDocsHintLabel.lineBreakMode = UILineBreakModeWordWrap;
	googleDocsHintLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:googleDocsHintLabel];
	//[backupDatabaseLabel release];	
	
	backupDatabaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backupDatabaseButton.frame = CGRectMake(20, 305, 230, 45);
	[backupDatabaseButton setTitle:@"Backup Database To My Email" forState:UIControlStateNormal];
	[backupDatabaseButton setBackgroundColor:[UIColor clearColor]];
	[backupDatabaseButton setBackgroundImage:[UIImage imageNamed:@"blue_button_background.png"] forState:UIControlStateNormal];
	[backupDatabaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backupDatabaseButton addTarget:self action:@selector(backupDatabaseToEmail) forControlEvents:UIControlEventTouchUpInside];
	backupDatabaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	//[self.view addSubview:backupDatabaseButton];
	
	
	
	thirdFieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 300.0, 280.0, 30)];
	thirdFieldLabel.text = @"Your Moodle Home URL";
	thirdFieldLabel.backgroundColor = [UIColor clearColor];
	thirdFieldLabel.textColor = [UIColor darkGrayColor];
	thirdFieldLabel.textAlignment = UITextAlignmentLeft;
	thirdFieldLabel.font = [UIFont boldSystemFontOfSize:16];
	thirdFieldLabel.hidden = YES;
	[self.view addSubview:thirdFieldLabel];
	//[thirdFieldLabel release];
	
	
	moodleURLField = [[UITextField alloc] initWithFrame:CGRectMake(20, 330, 230.0, 30)];
	moodleURLField.backgroundColor = [UIColor clearColor];
	moodleURLField.textColor = [UIColor blackColor];
	moodleURLField.textAlignment = UITextAlignmentLeft;
	moodleURLField.borderStyle = UITextBorderStyleRoundedRect;
	moodleURLField.delegate = self;
	[moodleURLField setReturnKeyType:UIReturnKeyDone];
	moodleURLField.autocorrectionType=UITextAutocorrectionTypeNo;
	moodleURLField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	[moodleURLField setKeyboardType:UIKeyboardTypeURL];
	moodleURLField.text = appDelegate.settings_moodleURL;
	moodleURLField.placeholder = @"eg: demo.moodle.org";
	[self.view addSubview:moodleURLField];	
	moodleURLField.hidden = YES;
	//[moodleURLField release];
	
	blackboardURLField = [[UITextField alloc] initWithFrame:CGRectMake(20, 330, 230.0, 30)];
	blackboardURLField.backgroundColor = [UIColor clearColor];
	blackboardURLField.textColor = [UIColor blackColor];
	blackboardURLField.textAlignment = UITextAlignmentLeft;
	blackboardURLField.borderStyle = UITextBorderStyleRoundedRect;
	blackboardURLField.delegate = self;
	[blackboardURLField setReturnKeyType:UIReturnKeyDone];
	blackboardURLField.autocorrectionType=UITextAutocorrectionTypeNo;
	blackboardURLField.autocapitalizationType=UITextAutocapitalizationTypeNone;
	blackboardURLField.text = appDelegate.settings_blackboardURL;
	blackboardURLField.placeholder = @"eg: coursesites.blackboard.com";
	[self.view addSubview:blackboardURLField];	
	blackboardURLField.hidden = YES;
	//[moodlePasswordField release];
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)backupDatabaseToEmail {
		// builds a .csv file containing the tracker data and sends it to the email script on the server
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	if ([personalEmailField.text length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Configure Your Settings" message:@"Before you can backup your database you need to configure your email address in the text field above." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
	NSMutableString* databaseExportFileContentString = [NSMutableString stringWithCapacity:0];	
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "select t.trackerID, t.trackerName, t.trackerScale, r.creationDate, r.dateLabel, l.studentName, v.recordValue from studentTracker t, studentTrackerDateRecord r, studentTrackerInstanceRecord v, studentTrackerStudentList l where t.trackerID = r.studentTrackerID and t.trackerID = v.studentTrackerID and t.trackerID = l.studentTrackerID and l.studentNameID = v.studentID and v.studentTrackerDateID = r.studentTrackerDateID order by t.trackerID asc, l.studentNameID asc, r.studentTrackerDateID";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			//int success =sqlite3_step(statement);
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *rowTrackerID = (char *)sqlite3_column_text(statement, 0);
				char *rowTrackerName = (char *)sqlite3_column_text(statement, 1);
				char *rowTrackerScale = (char *)sqlite3_column_text(statement, 2);
				char *rowCreationDate = (char *)sqlite3_column_text(statement, 3);
				char *rowDateLabel = (char *)sqlite3_column_text(statement, 4);
				char *rowStudentName = (char *)sqlite3_column_text(statement, 5);
				char *rowRecordValue = (char *)sqlite3_column_text(statement, 6);
				
				
				[databaseExportArray addObject:[[NSMutableArray arrayWithObjects:
												(rowTrackerID) ? [NSString stringWithUTF8String:rowTrackerID] : @"",
												 (rowTrackerName) ? [NSString stringWithUTF8String:rowTrackerName] : @"",
												 (rowTrackerScale) ? [NSString stringWithUTF8String:rowTrackerScale] : @"",
												 (rowCreationDate) ? [NSString stringWithUTF8String:rowCreationDate] : @"",
												 (rowDateLabel) ? [NSString stringWithUTF8String:rowDateLabel] : @"",
												 (rowStudentName) ? [NSString stringWithUTF8String:rowStudentName] : @"",
												 (rowRecordValue) ? [NSString stringWithUTF8String:rowRecordValue] : @"",
														nil] retain]];
				
				NSLog(@"databaseExportArray Row: %@, %@,%@, %@,%@, %@, %@", [NSString stringWithUTF8String:rowTrackerID], [NSString stringWithUTF8String:rowTrackerName],[NSString stringWithUTF8String:rowTrackerScale],[NSString stringWithUTF8String:rowCreationDate],[NSString stringWithUTF8String:rowDateLabel],[NSString stringWithUTF8String:rowStudentName],[NSString stringWithUTF8String:rowRecordValue]);
				
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
	
	// now loop through the new array and add each line into a comma separated text line with a newline character at the end
	int i=0;
	while ([databaseExportArray count] > i) {
		[databaseExportFileContentString appendFormat:@"%@,%@,%@,%@,%@,%@,%@\r\n", [[databaseExportArray objectAtIndex:i] objectAtIndex:0], [[databaseExportArray objectAtIndex:i] objectAtIndex:1], [[databaseExportArray objectAtIndex:i] objectAtIndex:2], [[databaseExportArray objectAtIndex:i] objectAtIndex:3], [[databaseExportArray objectAtIndex:i] objectAtIndex:4], [[databaseExportArray objectAtIndex:i] objectAtIndex:5], [[databaseExportArray objectAtIndex:i] objectAtIndex:6]];
		i +=1;
	} 
	
	// now save that string into a file on the iPhone's file system
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	[fileManager createFileAtPath:[documentsDirectory stringByAppendingPathComponent:@"myTracker.csv"] contents:[NSData dataWithBytes:[databaseExportFileContentString UTF8String] length:[databaseExportFileContentString length]] attributes:nil];
			
	// now send that file to the webserver
	
	
	
	
	NSString *urlString = @"http://ikonstrukt.crudigital.com.au/email_backup.php";
	//NSString *urlString = @"http://www.f-i-s-h.biz/email_backup.php";
	// location of database in application documents directory

    path = [documentsDirectory stringByAppendingPathComponent:@"myTracker.csv"];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] globallyUniqueString]];
	
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"database\"; filename=\"myTracker.csv\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	//[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: text/plainr\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

	[body appendData:[NSData dataWithContentsOfFile:path]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"emailAddress\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",appDelegate.settings_personalEmail] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"Sending Database To Backup Script");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Backup Complete" message:@"The backup operation was successful and you should receive an email with the database backup shortly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
	
	}
	
}

- (void)showPersonalSettings {
	// first set button text colours to match selected section
	[emailRollButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
	[moodleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[googleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	sectionHeaderLabel.text = @"Email Roll:";
	firstFieldLabel.text = @"Contact Email:";
	firstFieldLabel.frame = CGRectMake(20.0, 280.0, 250.0, 30);
	personalFullNameField.hidden = YES;
	moodleEmailField.hidden = YES;
	googleEmailField.hidden = YES;
	secondFieldLabel.text = @"Your Email Address";
	secondFieldLabel.hidden = YES;
	personalEmailField.hidden = NO;
	moodlePasswordField.hidden = YES;
	googlePasswordField.hidden = YES;
	googleDocsHintLabel.hidden = NO;
	googleDocsHintLabel.text = @"This feature allows you to email class rolls to admin or colleagues.  Enter your email address below and then simply tap the 'Home' icon in the top right corner of any Tracker.";
	googleDocsHintLabel.frame = CGRectMake(20.0, 160.0, 280.0, 140);
	backupDatabaseButton.hidden = NO;
	moodleURLField.hidden = YES;
	blackboardURLField.hidden = YES;
	thirdFieldLabel.hidden = YES;
	
}

- (void)showMoodleSettings {
	// first set button text colours to match selected section
	[emailRollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[moodleButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
	[googleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	sectionHeaderLabel.text = @"Moodle:";
	firstFieldLabel.text = @"Your Username:";
	personalFullNameField.hidden = YES;
	moodleEmailField.hidden = NO;
	googleEmailField.hidden = YES;
	secondFieldLabel.text = @"Your Login Password";
	secondFieldLabel.hidden = NO;
	personalEmailField.hidden = YES;
	moodlePasswordField.hidden = NO;
	googlePasswordField.hidden = YES;
	googleDocsHintLabel.hidden = YES;
	backupDatabaseButton.hidden = YES;
	moodleURLField.hidden = NO;
	blackboardURLField.hidden = YES;
	thirdFieldLabel.hidden = NO;
}

- (void)showGoogleSettings {
	// first set button text colours to match selected section
	[emailRollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[moodleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[googleButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
	sectionHeaderLabel.text = @"Google Docs:";
	firstFieldLabel.text = @"Email Address:";
	firstFieldLabel.frame = CGRectMake(20.0, 180.0, 250.0, 30);
	personalFullNameField.hidden = YES;
	moodleEmailField.hidden = YES;
	googleEmailField.hidden = NO;
	secondFieldLabel.text = @"Password";
	secondFieldLabel.hidden = NO;
	personalEmailField.hidden = YES;
	moodlePasswordField.hidden = YES;
	googlePasswordField.hidden = NO;
	googleDocsHintLabel.hidden = NO;
	googleDocsHintLabel.text = @"Include your Google Docs (gmail) login details above to sync your Tracker data.";
	googleDocsHintLabel.frame = CGRectMake(20.0, 280.0, 280.0, 140);
	backupDatabaseButton.hidden = YES;
	moodleURLField.hidden = YES;
	blackboardURLField.hidden = YES;
	thirdFieldLabel.hidden = YES;
	
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	appDelegate.settings_personalFullName = personalFullNameField.text;
	[[NSUserDefaults standardUserDefaults] setObject:personalFullNameField.text forKey:@"settings_personalFullName"];
	[personalFullNameField resignFirstResponder];
	
	appDelegate.settings_personalEmail = personalEmailField.text;
	[[NSUserDefaults standardUserDefaults] setObject:personalEmailField.text forKey:@"settings_personalEmail"];
	[personalEmailField resignFirstResponder];
	
	appDelegate.settings_moodleEmail = moodleEmailField.text;
	[[NSUserDefaults standardUserDefaults] setObject:moodleEmailField.text forKey:@"settings_moodleEmail"];
	[moodleEmailField resignFirstResponder];

	appDelegate.settings_moodlePassword = moodlePasswordField.text;
	[[NSUserDefaults standardUserDefaults] setObject:moodlePasswordField.text forKey:@"settings_moodlePassword"];
	[moodlePasswordField resignFirstResponder];
	
	appDelegate.settings_googleEmail = googleEmailField.text;
	[[NSUserDefaults standardUserDefaults] setObject:googleEmailField.text forKey:@"settings_blackboardEmail"];
	[googleEmailField resignFirstResponder];
	
	appDelegate.settings_googlePassword = googlePasswordField.text;
	[[NSUserDefaults standardUserDefaults] setObject:googlePasswordField.text forKey:@"settings_blackboardPassword"];
	[googlePasswordField resignFirstResponder];
	
	appDelegate.settings_blackboardURL = blackboardURLField.text;
	[[NSUserDefaults standardUserDefaults] setObject:blackboardURLField.text forKey:@"settings_blackboardURL"];
	[blackboardURLField resignFirstResponder];
	
	appDelegate.settings_moodleURL = moodleURLField.text;
	[[NSUserDefaults standardUserDefaults] setObject:moodleURLField.text forKey:@"settings_moodleURL"];
	[moodleURLField resignFirstResponder];
	backupDatabaseButton.enabled = YES;
	[self setViewMovedUp:NO];

	return YES;
	
}	





// Animate the entire view up or down, to prevent the keyboard from covering the bottom fields.
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)slideViewUpForKeyboard {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
	if (rect.origin.y >= 0)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	
    self.view.frame = rect;
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 100, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
	
	
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	CGRect rect = self.view.frame;
	if (rect.origin.y == 0) {
           [self setViewMovedUp:YES];
	}
	backupDatabaseButton.enabled = NO;
   
 
	return YES;
	
}


- (void)dealloc {
	[viewBackground release];
	[customNavHeader release];
	[emailRollButton release];
	[googleButton release];
	[moodleButton release];
	[sectionHeaderLabel release];
	[firstFieldLabel release];
	[secondFieldLabel release];
	[thirdFieldLabel release];
	[googleDocsHintLabel release];
	[backupDatabaseButton release];
	[personalFullNameField release];
	[personalEmailField release];
	[moodleEmailField release];
	[moodlePasswordField release];
	[moodleURLField release];
	[googleEmailField release];
	[googlePasswordField release];
	[blackboardURLField release];
	
    [super dealloc];
}


@end
