//
//  ELearningBookmarksNewBookmarkViewController.m
//  Educate
//
//  Created by James Hodge on 14/10/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "ELearningBookmarksNewBookmarkViewController.h"
#import "SettingsViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "EducateAppDelegate.h"

@implementation ELearningBookmarksNewBookmarkViewController

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					50.0

@synthesize viewBackground;
@synthesize customNavHeader;
@synthesize bookmarkNameLabel;
@synthesize bookmarkURLLabel;
@synthesize hintLabel;
@synthesize bookmarkNameField;
@synthesize bookmarkURLField;
@synthesize localBookmarkValueArray;
@synthesize parentELearningBookmarksViewController;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
		
		localBookmarkValueArray = [[NSMutableArray alloc] initWithCapacity:0];
		parentELearningBookmarksViewController = [[parentELearningBookmarksViewController alloc] initWithNibName:nil bundle:nil];
		
		viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeader.viewHeader.text = @"Edit Bookmark";
		[self.view addSubview:customNavHeader];
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		
		bookmarkNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 80.0, 280.0, 30)];
		bookmarkNameLabel.text = @"Bookmark Name:";
		bookmarkNameLabel.backgroundColor = [UIColor clearColor];
		bookmarkNameLabel.textColor = [UIColor darkGrayColor];
		bookmarkNameLabel.textAlignment = UITextAlignmentLeft;
		bookmarkNameLabel.font = [UIFont boldSystemFontOfSize:16];
		[self.view addSubview:bookmarkNameLabel];
		
		bookmarkNameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, 280.0, 30)];
		bookmarkNameField.backgroundColor = [UIColor clearColor];
		bookmarkNameField.textColor = [UIColor blackColor];
		bookmarkNameField.textAlignment = UITextAlignmentLeft;
		bookmarkNameField.borderStyle = UITextBorderStyleRoundedRect;
		bookmarkNameField.delegate = self;
		[bookmarkNameField setReturnKeyType:UIReturnKeyDone];
		bookmarkNameField.text = @"";
		bookmarkNameField.placeholder = @"eg Educate Help Forum";
		[self.view addSubview:bookmarkNameField];			
		
		bookmarkURLLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 140.0, 280.0, 30)];
		bookmarkURLLabel.text = @"Bookmark URL:";
		bookmarkURLLabel.backgroundColor = [UIColor clearColor];
		bookmarkURLLabel.textColor = [UIColor darkGrayColor];
		bookmarkURLLabel.textAlignment = UITextAlignmentLeft;
		bookmarkURLLabel.font = [UIFont boldSystemFontOfSize:16];
		[self.view addSubview:bookmarkURLLabel];		
		
		
		bookmarkURLField = [[UITextField alloc] initWithFrame:CGRectMake(20, 170, 280.0, 30)];
		bookmarkURLField.backgroundColor = [UIColor clearColor];
		bookmarkURLField.textColor = [UIColor blackColor];
		bookmarkURLField.textAlignment = UITextAlignmentLeft;
		bookmarkURLField.borderStyle = UITextBorderStyleRoundedRect;
		bookmarkURLField.delegate = self;
		[bookmarkURLField setReturnKeyType:UIReturnKeyDone];
		bookmarkURLField.autocorrectionType=UITextAutocorrectionTypeNo;
		bookmarkURLField.autocapitalizationType=UITextAutocapitalizationTypeNone;
		[bookmarkURLField setKeyboardType:UIKeyboardTypeURL];
		bookmarkURLField.text = @"";
		bookmarkURLField.placeholder = @"eg http://www.ikonstrukt.com";
		[self.view addSubview:bookmarkURLField];			
		
		
		hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 180.0, 280.0, 140)];
		hintLabel.text = @"Enter a name for your bookmark and the URL to connect to.  Be sure to include http:// at the start of your bookmark URL.";
		hintLabel.backgroundColor = [UIColor clearColor];
		hintLabel.textColor = [UIColor darkGrayColor];
		hintLabel.textAlignment = UITextAlignmentLeft;
		hintLabel.numberOfLines = 0;
		hintLabel.lineBreakMode = UILineBreakModeWordWrap;
		hintLabel.font = [UIFont systemFontOfSize:14];
		[self.view addSubview:hintLabel];
			
		
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
	
	

	
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (localBookmarkValueArray != nil)
	{
		bookmarkNameField.text = [localBookmarkValueArray objectAtIndex:0];
		bookmarkURLField.text = [localBookmarkValueArray objectAtIndex:1];
		
		
	}
	
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	if (theTextField == bookmarkNameField) {
		[[parentELearningBookmarksViewController.localBookmarksArray objectAtIndex:bookmarkArrayRowNumber] replaceObjectAtIndex:0 withObject:theTextField.text];
		[theTextField resignFirstResponder];
	} else if (theTextField == bookmarkURLField) {
		[[parentELearningBookmarksViewController.localBookmarksArray objectAtIndex:bookmarkArrayRowNumber] replaceObjectAtIndex:1 withObject:theTextField.text];
		[theTextField resignFirstResponder];
	}
	

	[self setViewMovedUp:NO];
	
	return YES;
	
}	

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == bookmarkNameField) {
		[[parentELearningBookmarksViewController.localBookmarksArray objectAtIndex:bookmarkArrayRowNumber] replaceObjectAtIndex:0 withObject:textField.text];
	} else if (textField == bookmarkURLField) {
		[[parentELearningBookmarksViewController.localBookmarksArray objectAtIndex:bookmarkArrayRowNumber] replaceObjectAtIndex:1 withObject:textField.text];
	}
	
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
	
	if (textField == bookmarkNameField) {
		if ([bookmarkNameField.text isEqualToString:@"New Bookmark"]) {
			bookmarkNameField.text = @"";
		}
	}
	
	
	return YES;
	
}

- (void)setBookmarkArrayRowNumber:(int)withInt {
	bookmarkArrayRowNumber = withInt;
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (void)dealloc {
	//[customNavHeader release];
	[bookmarkNameLabel release];
	[bookmarkURLLabel release];
	[hintLabel release];
	[bookmarkNameField release];
	[bookmarkURLField release];
	[localBookmarkValueArray release];
	[parentELearningBookmarksViewController release];
    [super dealloc];
}


@end
