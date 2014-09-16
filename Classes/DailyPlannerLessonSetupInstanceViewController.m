//
//  DailyPlannerLessonSetupInstanceViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerLessonSetupInstanceViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeader.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					210.0

#define kTextFieldWidth							100.0	// initial width, but the table cell will dictact the actual width

// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.30

#define kUITextField_Section					0
#define kUITextField_Rounded_Custom_Section		1
#define kUITextField_Secure_Section				2


@implementation DailyPlannerLessonSetupInstanceViewController


@synthesize colourPicker;
@synthesize periodNameField;
@synthesize classroomField;
@synthesize localLessonSetupArray;
@synthesize customNavHeaderThin;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		
		pickerColourOptionArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		[pickerColourOptionArray addObject:@"Black"];
		[pickerColourOptionArray addObject:@"Blue"];
		[pickerColourOptionArray addObject:@"Green"];
		[pickerColourOptionArray addObject:@"Grey"];
		[pickerColourOptionArray addObject:@"Orange"];
		[pickerColourOptionArray addObject:@"Purple"];
		[pickerColourOptionArray addObject:@"Red"];
		[pickerColourOptionArray addObject:@"White"];
		[pickerColourOptionArray addObject:@"Yellow"];
		
		customNavHeaderThin = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeaderThin.viewHeader.text = @"Lesson Setup";
		[self.view addSubview:customNavHeaderThin];
		[customNavHeaderThin release];
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 40);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeaderThin addSubview:backButton];
		
		
		
		// Settings Fields & Labels
		
		UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		lowerViewBackground.frame = CGRectMake(0,44,320,420);
		[self.view addSubview:lowerViewBackground];
		[lowerViewBackground release];
		
		UILabel* labelPeriodName = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60, 50.0, 30)];
		labelPeriodName.text = @"Name:";
		labelPeriodName.backgroundColor = [UIColor clearColor];
		labelPeriodName.textColor = [UIColor darkGrayColor];
		labelPeriodName.textAlignment = UITextAlignmentLeft;
		labelPeriodName.font = [UIFont boldSystemFontOfSize:14];
		[self.view addSubview:labelPeriodName];
		//[labelPeriodName release];
		
		periodNameField = [[UITextField alloc] initWithFrame:CGRectMake(75, 60, 230.0, 30)];
		periodNameField.backgroundColor = [UIColor clearColor];
		periodNameField.textColor = [UIColor blackColor];
		periodNameField.textAlignment = UITextAlignmentLeft;
		periodNameField.borderStyle = UITextBorderStyleRoundedRect;
		//[periodNameField addTarget:self action:@selector(slideViewUpForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
		periodNameField.delegate = self;
		[periodNameField setReturnKeyType:UIReturnKeyDone];
		periodNameField.autocorrectionType=UITextAutocorrectionTypeNo;
		[self.view addSubview:periodNameField];	
		//[periodNameField release];
		
		UILabel* labelClassroom = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 120, 50.0, 30)];
		labelClassroom.text = @"Room:";
		labelClassroom.backgroundColor = [UIColor clearColor];
		labelClassroom.textColor = [UIColor darkGrayColor];
		labelClassroom.textAlignment = UITextAlignmentLeft;
		labelClassroom.font = [UIFont boldSystemFontOfSize:15];
		[self.view addSubview:labelClassroom];
		//[labelPeriodName release];
		
		classroomField = [[UITextField alloc] initWithFrame:CGRectMake(75, 120, 230.0, 30)];
		classroomField.backgroundColor = [UIColor clearColor];
		classroomField.textColor = [UIColor blackColor];
		classroomField.textAlignment = UITextAlignmentLeft;
		classroomField.borderStyle = UITextBorderStyleRoundedRect;
		//[periodNameField addTarget:self action:@selector(slideViewUpForKeyboard) forControlEvents:UIControlEventEditingDidBegin];
		classroomField.delegate = self;
		[classroomField setReturnKeyType:UIReturnKeyDone];
		classroomField.autocorrectionType=UITextAutocorrectionTypeNo;
		[self.view addSubview:classroomField];	
		//[periodNameField release];
		
		
		UILabel* labelColour = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 180, 100.0, 30)];
		labelColour.text = @"Colour:";
		labelColour.backgroundColor = [UIColor clearColor];
		labelColour.textColor = [UIColor darkGrayColor];
		labelColour.textAlignment = UITextAlignmentLeft;
		labelColour.font = [UIFont boldSystemFontOfSize:15];
		[self.view addSubview:labelColour];
		//[labelPeriodName release];
		
		
		colourPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		CGSize pickerSize = [colourPicker sizeThatFits:CGSizeZero];
		colourPicker.frame = [self pickerFrameWithSize:pickerSize];
		
		colourPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		colourPicker.delegate = self;
		colourPicker.showsSelectionIndicator = YES;	// note this is default to NO
		
		[self.view addSubview:colourPicker];
		
		
		
    }
    return self;
}
 

// return the picker frame based on its size, positioned at the top of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect pickerRect = CGRectMake(	0.0,
								   220,
								   size.width,
								   size.height);
	return pickerRect;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	

		periodNameField.text = [localLessonSetupArray objectAtIndex:1];
		classroomField.text = [localLessonSetupArray objectAtIndex:2];
	
		
		 int i = 0;
		 while ([pickerColourOptionArray count] > i) {
			 if ([[pickerColourOptionArray objectAtIndex:i] isEqualToString:[localLessonSetupArray objectAtIndex:3]]) {
				 [colourPicker selectRow:i inComponent:0 animated:YES];
				 break;
			 }
			 i +=1;
		 }
		 
		
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];	
	[self saveLessonToDatabase];
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[localLessonSetupArray replaceObjectAtIndex:3 withObject:[pickerColourOptionArray objectAtIndex:row]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [pickerColourOptionArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 320;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 35.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	
	return [pickerColourOptionArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
		
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == periodNameField) {
		
		[periodNameField resignFirstResponder];
	} else if (theTextField == classroomField) {
			[classroomField resignFirstResponder];
	}
	
	[localLessonSetupArray replaceObjectAtIndex:1 withObject:periodNameField.text];
	[localLessonSetupArray replaceObjectAtIndex:2 withObject:classroomField.text];
	[self saveLessonToDatabase];
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


- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the username or password fields, adjust the display so that the
    // fields will not be covered by the keyboard.
    if (self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
		
    }
	else if (self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:NO];
    }
	
	
	
}



- (void)saveLessonToDatabase {
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	// The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open a connection and do an update into the database for this period
	
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "UPDATE weeklyPlannerLessonSetup SET lessonName = ?, classroom = ?, colour = ? WHERE lessonID = ?";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			NSLog(@"Update Query OK");
			int success = 0;
			// Bind the query variables.
			sqlite3_bind_text(statement, 1, [[localLessonSetupArray objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 2, [[localLessonSetupArray objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(statement, 3, [[localLessonSetupArray objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(statement, 4, [[localLessonSetupArray objectAtIndex:0] intValue]);
			
			
			// Execute the query.
			success =sqlite3_step(statement);
			
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Save Database Response '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[pool release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[colourPicker release];
	[periodNameField release];
	[classroomField release];
	[localLessonSetupArray release];
	[customNavHeaderThin release];
    [super dealloc];
}


@end
