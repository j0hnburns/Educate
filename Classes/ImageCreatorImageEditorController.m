//
//  ImageCreatorImageEditorController.m
//  Educate
//
//  Created by James Hodge on 26/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageCreatorImageEditorController.h"
#import "CustomNavigationHeaderThin.h"
#import "ImageCreatorTextOverlay.h"
#import <QuartzCore/QuartzCore.h>


@implementation ImageCreatorImageEditorController

@synthesize imagePicker;
@synthesize currentEditingImage;
@synthesize currentEditingImageView;
@synthesize addedObjectsArray;
@synthesize undoButton;
@synthesize textButton;
@synthesize arrowButton;
@synthesize imageEditingLayoutView;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
		
		// initialise the added objects array, then empty it
		// when items are added to the view, they are added into this array
		// this way we can remove the last added item from the view by accessing the array
		addedObjectsArray = [[NSMutableArray arrayWithObjects:
								  [[NSMutableArray arrayWithObjects:
									@"0",
									@"Period 1",
									@"Monday",
									@"01 Jan 2009",
									@"Notes",
									nil] retain],
								  nil] retain];
		
		while ([addedObjectsArray count] > 0) {
			[addedObjectsArray removeLastObject];
		}
		
		
		
		UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		
		CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
		customNavHeader.viewHeader.text = @"";
		customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
		[self.view addSubview:customNavHeader];
		[customNavHeader release];
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(chooseBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		imageEditingLayoutView = [[UIView alloc] initWithFrame:CGRectMake(0,51,320,361)];
		[self.view addSubview:imageEditingLayoutView];
		
		currentEditingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black.png"]];
		currentEditingImageView.frame = CGRectMake(0,0,320,361);
		currentEditingImageView.contentMode = UIViewContentModeScaleAspectFit;
		[imageEditingLayoutView addSubview:currentEditingImageView];
		
		
		undoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		undoButton.frame = CGRectMake(245, 30, 49, 49);
		[undoButton setTitle:@"" forState:UIControlStateNormal];
		[undoButton setBackgroundColor:[UIColor clearColor]];
		[undoButton setImage:[UIImage imageNamed:@"imageButton_undo.png"] forState:UIControlStateNormal];
		[undoButton addTarget:self action:@selector(removeObjectsFromViewInReverseOrder) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:undoButton];
		
		textButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		textButton.frame = CGRectMake(190, 30, 49, 49);
		[textButton setTitle:@"" forState:UIControlStateNormal];
		[textButton setBackgroundColor:[UIColor clearColor]];
		[textButton setImage:[UIImage imageNamed:@"imageButton_text.png"] forState:UIControlStateNormal];
		[textButton addTarget:self action:@selector(createNewTextObject) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:textButton];
		
		
		arrowButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		arrowButton.frame = CGRectMake(135, 30, 49, 49);
		[arrowButton setTitle:@"" forState:UIControlStateNormal];
		[arrowButton setBackgroundColor:[UIColor clearColor]];
		[arrowButton setImage:[UIImage imageNamed:@"imageButton_arrow.png"] forState:UIControlStateNormal];
		[arrowButton addTarget:self action:@selector(createNewArrowObject) forControlEvents:UIControlEventTouchUpInside];
		arrowButton.hidden = YES;
		[self.view addSubview:arrowButton];
		
		
    }
    return self;
}

- (void)createNewArrowObject {
	
}

- (void)createNewTextObject {
	// create a new text label and add it to the view
	// we create our labels as custom classes which handle the touch actions
	ImageCreatorTextOverlay* newTextObject = [[ImageCreatorTextOverlay alloc] initWithFrame:CGRectMake(170, 165, 120, 30)];
	[imageEditingLayoutView addSubview:newTextObject];
	[addedObjectsArray addObject:newTextObject];
	[newTextObject release];
}

- (void)removeObjectsFromViewInReverseOrder {
	
	if ([addedObjectsArray count] > 0) {
	
		[[addedObjectsArray lastObject] removeFromSuperview];
		[addedObjectsArray removeLastObject];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	int i = 0;
	while ([addedObjectsArray count] > i) {
		[[addedObjectsArray objectAtIndex:i] setNeedsDisplay];
		i +=1;
	}
	
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)chooseBackButtonAction {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Edited Image?" message:@"Save this edited image to your photo roll before closing the editor?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Image", @"Don't Save Image", nil];
	[alert show];
	[alert release];
	
	
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 2) {
		[self callPopBackToPreviousView];
	} else if (buttonIndex == 1) {
		[self saveImageToPhotoRoll];
		[self callPopBackToPreviousView];
	}
}


- (void)saveImageToPhotoRoll {
	// code to save the image
	// grab the image context from the imageEditingLayoutView and save the image into the photo roll
	UIGraphicsBeginImageContext(imageEditingLayoutView.bounds.size);
	[imageEditingLayoutView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}


- (void)callPopBackToPreviousView {
	//  pop off this viewController
	[[self navigationController] popViewControllerAnimated:YES];

}


- (void)showCameraPicker:(BOOL)useCamera {
	
    imagePicker = [[UIImagePickerController alloc] init];
	if (useCamera) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else {
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
	imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
    // Picker is displayed asynchronously.
    [[self navigationController] presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
	
	
	
	
	
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	
	NSLog(@"IMAGE PICKER CODE RUNNING");
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// update local image cache with new image
	currentEditingImage = image;
		
	currentEditingImageView.image = currentEditingImage;
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    
	
	[pool release];
	
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	// set image to a blank image to prevent objects from being dealloced prematurely
	currentEditingImage = [UIImage imageNamed:@"black.png"];
	currentEditingImageView.image = currentEditingImage;
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[self callPopBackToPreviousView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[currentEditingImage release];
	[currentEditingImageView release];
	//[addedObjectsArray release];
	//[undoButton release];
	//[arrowButton release];
	//[textButton release];
	//[imageEditingLayoutView release];
    [super dealloc];
}


@end
