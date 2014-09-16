//
//  StudentTrackerInstanceNameRecordCell.m
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudentTrackerInstanceNameRecordCell.h"
#import "TrackerStudentNameContactActionSelectionAlertView.h"
#import "EducateAppDelegate.h"


@implementation StudentTrackerInstanceNameRecordCell


@synthesize localInstanceRecordArray;
@synthesize studentNameButton;
@synthesize studentNameLabel;
@synthesize contactOptionsArray;
@synthesize localDateRecordArray;
@synthesize studentNameBackground;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
	
	studentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,160,40)];
	studentNameLabel.text = @"";
	studentNameLabel.font = [UIFont systemFontOfSize:18];
	studentNameLabel.textAlignment = UITextAlignmentLeft;
	studentNameLabel.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:studentNameLabel];
	
	frame = CGRectMake(0,0, 160, 40);
	studentNameButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	studentNameButton.frame = frame;
	[studentNameButton setTitle:@"" forState:UIControlStateNormal];
	[studentNameButton setBackgroundColor:[UIColor clearColor]];
	[studentNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[studentNameButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
	studentNameButton.titleLabel.textAlignment = UITextAlignmentLeft;
	[studentNameButton addTarget:self action:@selector(showStudentContactActionSelectorAlert) forControlEvents:UIControlEventTouchUpInside];
	[self.contentView addSubview:studentNameButton];
	
	editingButton = 0;
	
	contactOptionsArray = [[NSMutableArray alloc] initWithCapacity:0];

	
	
	
    return self;
}

- (void)setTrackerID:(int)withID {
	trackerID = withID;
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

		if (buttonIndex == 1) {
			// phone student
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[contactOptionsArray objectAtIndex:0]]]];
			
		} else if (buttonIndex == 2) {
			// phone guardian
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[contactOptionsArray objectAtIndex:1]]]];
		} else if (buttonIndex == 3) {
			// email student
			
			Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
			if (mailClass != nil)
			{
				// We must always check whether the current device is configured for sending emails
				if ([mailClass canSendMail])
				{
					
					MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
					picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
					picker.mailComposeDelegate = self;
					[picker setSubject:@""];  // tracker name
					
					// Set up recipients
					NSArray *toRecipients = [NSArray arrayWithObject:[contactOptionsArray objectAtIndex:2]]; 
					
					[picker setToRecipients:toRecipients];
					
					// Fill out the email body text
					NSString *emailBody = @"";
					[picker setMessageBody:emailBody isHTML:NO];
					
					[[[[appDelegate tabBarController] selectedViewController] visibleViewController] presentModalViewController:picker animated:YES];
					[picker release];
					
					
				}
				else
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to create an email as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];	
					[alert release];
				}
			}
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to create an email as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
			}
			
		} else if (buttonIndex == 4) {
			// email guardian
			
			
			Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
			if (mailClass != nil)
			{
				// We must always check whether the current device is configured for sending emails
				if ([mailClass canSendMail])
				{
					
					MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
					picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
					picker.mailComposeDelegate = self;
					[picker setSubject:@""];  // tracker name
					
					// Set up recipients
					NSArray *toRecipients = [NSArray arrayWithObject:[contactOptionsArray objectAtIndex:3]]; 
					
					[picker setToRecipients:toRecipients];
					
					// Fill out the email body text
					NSString *emailBody = @"";
					[picker setMessageBody:emailBody isHTML:NO];
					
					[[[[appDelegate tabBarController] selectedViewController] visibleViewController] presentModalViewController:picker animated:YES];
					[picker release];
					
				
				}
				else
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to create an email as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
					[alert show];	
					[alert release];
				}
			}
			else
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"Educate is unable to create an email as your iPhone or iPod Touch does not support in-app email, or you have not created any email accounts on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];
			}
			
		} else {
			// buttonIndex == 0, therefore cancel button was pressed.
		
	}
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
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
			alert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:@"Educate could not send the email because an email error occurred.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
		default:
			NSLog(@"Email Not Sent");
			alert = [[UIAlertView alloc] initWithTitle:@"Email Failure" message:@"Educate could not send the email because an email error occurred.  Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];	
			[alert release];
			break;
	}
	[[[[appDelegate tabBarController] selectedViewController] visibleViewController] dismissModalViewControllerAnimated:YES];
}


- (void)showStudentContactActionSelectorAlert {
	
			
	// build custom view to display
	TrackerStudentNameContactActionSelectionAlertView *alert = [[TrackerStudentNameContactActionSelectionAlertView alloc] initWithTitle:@"\r\r\r\r\r\r\r" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	alert.delegate = self;
	[alert valueButtonPhoneStudent].hidden = NO;
	[alert valueButtonPhoneGuardian].hidden = NO;
	[alert valueButtonEmailStudent].hidden = NO;
	[alert valueButtonEmailGuardian].hidden = NO;

	
	if ([contactOptionsArray count] == 4) {
	// hide buttons that are not applicable due to those values not existing in the database for this student
	
	if ([[contactOptionsArray objectAtIndex:0] isEqualToString:@""]) { // student phone
		[alert valueButtonPhoneStudent].hidden = YES;
	}
	if ([[contactOptionsArray objectAtIndex:1] isEqualToString:@""]) { // guardian phone
		[alert valueButtonPhoneGuardian].hidden = YES;
	}
	if ([[contactOptionsArray objectAtIndex:2] isEqualToString:@""]) { // student email
		[alert valueButtonEmailStudent].hidden = YES;
	}
	if ([[contactOptionsArray objectAtIndex:3] isEqualToString:@""]) { // guardian email
		[alert valueButtonEmailGuardian].hidden = YES;
	}
	} else { // the contact options array didn't initialise, so disable all buttons
		[alert valueButtonPhoneStudent].hidden = YES;
		[alert valueButtonPhoneGuardian].hidden = YES;
		[alert valueButtonEmailStudent].hidden = YES;
		[alert valueButtonEmailGuardian].hidden = YES;
	}
	
	// now check if the device is an iPod Touch - if so remove the Phone buttons
	
	if (![[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
		[alert valueButtonPhoneStudent].hidden = YES;
		[alert valueButtonPhoneGuardian].hidden = YES;
	}
		
	
	[alert show];
	[alert release];
					
		
		
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseContactOptionsArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	while ([contactOptionsArray count] > 0) {
		[contactOptionsArray removeLastObject];
	}
	
	
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT phone1, phone2, studentEmail, guardianEmail FROM studentTrackerStudentList WHERE studentTrackerID = ? AND studentNameID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			
			
						
			// Bind the variables.
			sqlite3_bind_int(statement, 1, trackerID);
			sqlite3_bind_int(statement, 2, [[localInstanceRecordArray objectAtIndex:2] intValue]);
			
			
			// Execute the query.
			int success =sqlite3_step(statement);
			
				char *row_phone1 = (char *)sqlite3_column_text(statement, 0);
				char *row_phone2 = (char *)sqlite3_column_text(statement, 1);
				char *row_studentEmail = (char *)sqlite3_column_text(statement, 2);
				char *row_guardianEmail = (char *)sqlite3_column_text(statement, 3);
				
				
				[contactOptionsArray addObject:(row_phone1) ? [NSString stringWithUTF8String:row_phone1] : @""];
				[contactOptionsArray addObject:(row_phone2) ? [NSString stringWithUTF8String:row_phone2] : @""];
				[contactOptionsArray addObject:(row_studentEmail) ? [NSString stringWithUTF8String:row_studentEmail] : @""];
				[contactOptionsArray addObject:(row_guardianEmail) ? [NSString stringWithUTF8String:row_guardianEmail] : @""];
				
				NSLog(@"contactOptionsArray for studentID %i: %@, %@, %@, %@", [[localInstanceRecordArray objectAtIndex:2] intValue], [contactOptionsArray objectAtIndex:0], [contactOptionsArray objectAtIndex:1], [contactOptionsArray objectAtIndex:2], [contactOptionsArray objectAtIndex:3]);
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"initialiseContactOptionsArray Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"initialiseContactOptionsArray Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[pool release];
	
	
	
}



- (void)dealloc {
	[localInstanceRecordArray release];
	[studentNameButton release];
	[studentNameLabel release];
	[contactOptionsArray release];
	[localDateRecordArray release];
	[studentNameBackground release];
    [super dealloc];
}


@end
