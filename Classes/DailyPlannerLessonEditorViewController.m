//
//  DailyPlannerLessonEditorViewController.m
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerLessonEditorViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeader.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					55.0

@implementation DailyPlannerLessonEditorViewController

@synthesize periodID;
@synthesize periodTypeSelector;
@synthesize periodNameField;
@synthesize localPeriodArray;
@synthesize customNavHeader;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		periodID = [NSNumber numberWithInteger:0];
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
	
	// Settings Fields & Labels
	
	customNavHeader = [[CustomNavigationHeader alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Overview";
	customNavHeader.upperSubHeading.text = @"Period Editor";
	//customNavHeader.lowerSubHeading.text = [NSString stringWithFormat:@"%@",[[[appDelegate structureArray] objectAtIndex:[periodID intValue]] objectAtIndex:2]];
	customNavHeader.lowerSubHeading.text = @"";
	customNavHeader.lowerSubHeading.hidden = YES;
	[self.view addSubview:customNavHeader];
	[customNavHeader release];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 40);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButtonSmall.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	UIImageView* lowerViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	lowerViewBackground.frame = CGRectMake(0,134,320,330);
	[self.view addSubview:lowerViewBackground];
	[lowerViewBackground release];
	
	UILabel* labelPeriodType = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 150.0, 310.0, 30)];
	labelPeriodType.text = @"Period Type:";
	labelPeriodType.backgroundColor = [UIColor clearColor];
	labelPeriodType.textColor = [UIColor darkGrayColor];
	labelPeriodType.textAlignment = UITextAlignmentCenter;
	labelPeriodType.font = [UIFont boldSystemFontOfSize:15];
	[self.view addSubview:labelPeriodType];
	//[labelPeriodType release];
	
	NSArray *segmentedControlArray = [[NSArray arrayWithObjects:
									   @"Lesson",
									   @"Break",
									   nil] retain];
	
	periodTypeSelector = [[UISegmentedControl alloc] initWithItems:segmentedControlArray];
	periodTypeSelector.frame = CGRectMake(40.0, 180.0, 240.0, 30);
	periodTypeSelector.selectedSegmentIndex = 0;
	periodTypeSelector.segmentedControlStyle = UISegmentedControlStyleBar;
	[periodTypeSelector addTarget:self action:@selector(changePeriodType) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:periodTypeSelector];
	//[periodTypeSelector release];
	
	UILabel* labelPeriodName = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 220.0, 310.0, 30)];
	labelPeriodName.text = @"Specify Period Name:";
	labelPeriodName.backgroundColor = [UIColor clearColor];
	labelPeriodName.textColor = [UIColor darkGrayColor];
	labelPeriodName.textAlignment = UITextAlignmentCenter;
	labelPeriodName.font = [UIFont boldSystemFontOfSize:15];
	[self.view addSubview:labelPeriodName];
	//[labelPeriodName release];
	
	periodNameField = [[UITextField alloc] initWithFrame:CGRectMake(40.0, 250, 240.0, 30)];
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
	
	periodNameField.text = [localPeriodArray objectAtIndex:1];
	
	if ([[localPeriodArray objectAtIndex:2] isEqualToString:@"Lesson"]) {
		periodTypeSelector.selectedSegmentIndex = 0;
	} else {
		periodTypeSelector.selectedSegmentIndex = 1;
	}
	
	
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)changePeriodType {
		if (periodTypeSelector.selectedSegmentIndex == 0) {
		[localPeriodArray replaceObjectAtIndex:2 withObject:@"Lesson"];
	} else {
		[localPeriodArray replaceObjectAtIndex:2 withObject:@"Break"];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	[self slideViewUpForKeyboard];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == periodNameField) {
		[periodNameField resignFirstResponder];
		
		[localPeriodArray replaceObjectAtIndex:1 withObject:periodNameField.text];
	}
	
	if  (self.view.frame.origin.y < 0)
	{
		[self setViewMovedUp:NO];
	}
	
	return YES;
	
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
		if (rect.origin.y >= 0)
		{
			rect.origin.y -= kOFFSET_FOR_KEYBOARD;
			rect.size.height += kOFFSET_FOR_KEYBOARD;
		}
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
		if (rect.origin.y < 0) {
			rect.origin.y += kOFFSET_FOR_KEYBOARD;
			rect.size.height -= kOFFSET_FOR_KEYBOARD;
		}
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[periodID release];
	[periodTypeSelector release];
	[periodNameField release];
	[localPeriodArray release];
	[customNavHeader release];
    [super dealloc];
}


@end
