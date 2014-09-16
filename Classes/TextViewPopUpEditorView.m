//
//  TextViewPopUpEditorView.m
//  GAY
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextViewPopUpEditorView.h"
//#import "GAYAppDelegate.h"


@implementation TextViewPopUpEditorView

@synthesize backgroundImage;
@synthesize textCellBackgroundImage;
@synthesize textView;
@synthesize cancelButton;
@synthesize clearButton;
@synthesize deleteColumnButton;
@synthesize saveButton;
@synthesize editingField;




// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor grayColor]];
    self.view = view;
    [view release];
		

	
	// Background Image
	
	CGRect frame = CGRectMake(0, 0, 320, 480);
	backgroundImage = [[UIImageView alloc] initWithFrame:frame];
	backgroundImage.image = [UIImage imageNamed:@"scrollBackground.png"];
	[backgroundImage setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:backgroundImage];
	[backgroundImage release];
	

	textCellBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,5,320,190)];
	textCellBackgroundImage.image = [UIImage imageNamed:@"edit-text-input-field.png"];
	[textCellBackgroundImage setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:textCellBackgroundImage];
	[textCellBackgroundImage release];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
	textView.backgroundColor = [UIColor clearColor];
	textView.textColor = [UIColor colorWithRed:0.3828 green:0.3828 blue:0.3789 alpha:1];
	textView.font = [UIFont boldSystemFontOfSize:14];
	[textView setReturnKeyType:UIReturnKeyDefault];
	textView.editable = NO;
	textView.editable = YES;
	[self.view addSubview:textView];
	[textView release];
	
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
	
	deleteColumnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	deleteColumnButton.frame = CGRectMake(130, 200, 100, 40);
	[deleteColumnButton setTitle:@"Delete Column" forState:UIControlStateNormal];
	[deleteColumnButton setBackgroundColor:[UIColor redColor]];
	[deleteColumnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[deleteColumnButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[deleteColumnButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[deleteColumnButton addTarget:self action:@selector(deleteColumnFromTracker) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:deleteColumnButton];
	
	saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	saveButton.frame = CGRectMake(240, 200, 50, 40);
	[saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[saveButton setBackgroundColor:[UIColor clearColor]];
	[saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[saveButton setBackgroundImage:[UIImage imageNamed:@"profile-buttons.png"] forState:UIControlStateNormal];
	[saveButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[saveButton addTarget:self action:@selector(saveTextAndClose) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveButton];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidAppear:(BOOL)animated {
	//textView.text = textReturnString;
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

- (void)deleteColumnFromTracker {
	[textView resignFirstResponder];
	
	
	[self dismissModalViewControllerAnimated:YES];
	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	//[backgroundImage release];
	//[textCellBackgroundImage release];
	//[textView release];
	[cancelButton release];
	[clearButton release];
	[deleteColumnButton release];
	[saveButton release];
	[editingField release];
    [super dealloc];
}


@end
