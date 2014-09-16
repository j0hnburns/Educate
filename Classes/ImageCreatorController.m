//
//  ImageCreatorController.m
//  Educate
//
//  Created by James Hodge on 26/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageCreatorController.h"
#import "CustomNavigationHeaderThin.h"
#import "ImageCreatorImageEditorController.h"


@implementation ImageCreatorController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
		
		UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		
		CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
		customNavHeader.viewHeader.text = @"Image Creator";
		customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
		[self.view addSubview:customNavHeader];
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		

		
		UILabel* newFromLibraryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 285, 120, 30)];
		newFromLibraryLabel.text = @"Existing Image";
		newFromLibraryLabel.backgroundColor = [UIColor clearColor];
		newFromLibraryLabel.textColor = [UIColor whiteColor];
		newFromLibraryLabel.textAlignment = UITextAlignmentCenter;
		newFromLibraryLabel.font = [UIFont boldSystemFontOfSize:15];
		newFromLibraryLabel.shadowColor = [UIColor blackColor];
		newFromLibraryLabel.shadowOffset = CGSizeMake(0,1);
		newFromLibraryLabel.numberOfLines = 2;
		[self.view addSubview:newFromLibraryLabel];
		[newFromLibraryLabel release];
		
		UIButton* newFromLibrary = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		newFromLibrary.frame = CGRectMake(30, 165, 120, 113);
		[newFromLibrary setImage:[UIImage imageNamed:@"elearnIcon_existingImage.png"] forState:UIControlStateNormal];
		[newFromLibrary setBackgroundColor:[UIColor clearColor]];
		[newFromLibrary addTarget:self action:@selector(startEditingNewImageFromLibrary) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:newFromLibrary];
		
		UILabel* newFromCameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 285, 120, 30)];
		newFromCameraLabel.text = @"New Image";
		newFromCameraLabel.backgroundColor = [UIColor clearColor];
		newFromCameraLabel.textColor = [UIColor whiteColor];
		newFromCameraLabel.textAlignment = UITextAlignmentCenter;
		newFromCameraLabel.font = [UIFont boldSystemFontOfSize:15];
		newFromCameraLabel.shadowColor = [UIColor blackColor];
		newFromCameraLabel.shadowOffset = CGSizeMake(0,1);
		newFromCameraLabel.numberOfLines = 2;
		[self.view addSubview:newFromCameraLabel];
		[newFromCameraLabel release];
		
		
		UIButton* newFromCamera = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		newFromCamera.frame = CGRectMake(170, 165, 120, 113);
		[newFromCamera setImage:[UIImage imageNamed:@"elearnIcon_newImage.png"] forState:UIControlStateNormal];
		[newFromCamera setBackgroundColor:[UIColor clearColor]];
		[newFromCamera addTarget:self action:@selector(startEditingNewImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:newFromCamera];
		
		
		
		
		
    }
    return self;
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)openExistingImageController {


}

- (void)startEditingNewImageFromCamera {
	
	if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		ImageCreatorImageEditorController *imageCreatorImageEditorController = [[ImageCreatorImageEditorController alloc] initWithNibName:nil bundle:nil];    
		imageCreatorImageEditorController.title = @"Image Creator";
		[[self navigationController] pushViewController:imageCreatorImageEditorController animated:YES];
		[imageCreatorImageEditorController showCameraPicker:YES];
		//[imageCreatorImageEditorController release];

	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:@"Your device does not have a camera, so Educate is not able to capture a new image for the Image Creator.  To use the Image Creator please select an existing image from your photo library." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	
	
}


- (void)startEditingNewImageFromLibrary {
	ImageCreatorImageEditorController *imageCreatorImageEditorController = [[ImageCreatorImageEditorController alloc] initWithNibName:nil bundle:nil];    
	imageCreatorImageEditorController.title = @"Image Creator";
	[[self navigationController] pushViewController:imageCreatorImageEditorController animated:YES];
	[imageCreatorImageEditorController showCameraPicker:NO];
	//[imageCreatorImageEditorController release];
	
	
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
