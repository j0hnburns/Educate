//
//  ELearningBrowserMoodleController.m
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ELearningBrowserMoodleController.h"
#import "CustomNavigationHeaderThin.h"
#import "EducateAppDelegate.h"


@implementation ELearningBrowserMoodleController
@synthesize forumWebView;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

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
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Moodle";
	customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:16];
	[self.view addSubview:customNavHeader];
	
	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	forumWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,51,320,320)];
	forumWebView.scalesPageToFit = YES;
	forumWebView.delegate = self;
	[self.view addSubview:forumWebView];
	
	UIButton* browserBackButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserBackButton.frame = CGRectMake(0, 370, 52, 41);
	[browserBackButton setBackgroundColor:[UIColor clearColor]];
	[browserBackButton setImage:[UIImage imageNamed:@"browserNav_back.png"] forState:UIControlStateNormal];
	[browserBackButton addTarget:forumWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserBackButton];
	
	UIButton* browserForwardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserForwardButton.frame = CGRectMake(52, 370,52, 41);
	[browserForwardButton setBackgroundColor:[UIColor clearColor]];
	[browserForwardButton setImage:[UIImage imageNamed:@"browserNav_forward.png"] forState:UIControlStateNormal];
	[browserForwardButton addTarget:forumWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserForwardButton];
	
	UIButton* browserStopButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserStopButton.frame = CGRectMake( 106, 370,55, 41);
	[browserStopButton setBackgroundColor:[UIColor clearColor]];
	[browserStopButton setImage:[UIImage imageNamed:@"browserNav_stop.png"] forState:UIControlStateNormal];
	[browserStopButton addTarget:forumWebView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserStopButton];
	
	UIButton* browserReloadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserReloadButton.frame = CGRectMake( 161,370, 55, 41);
	[browserReloadButton setBackgroundColor:[UIColor clearColor]];
	[browserReloadButton setImage:[UIImage imageNamed:@"browserNav_reload.png"] forState:UIControlStateNormal];
	[browserReloadButton addTarget:forumWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserReloadButton];
	
	UIButton* browserImageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserImageButton.frame = CGRectMake(216, 370, 55, 41);
	[browserImageButton setBackgroundColor:[UIColor clearColor]];
	[browserImageButton setImage:[UIImage imageNamed:@"browserNav_imageBlank.png"] forState:UIControlStateNormal];
	//[browserImageButton addTarget:self action:@selector(browseToImageURL) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserImageButton];
	
	UIButton* browserPostButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserPostButton.frame = CGRectMake(271, 370, 52, 41);
	[browserPostButton setBackgroundColor:[UIColor clearColor]];
	[browserPostButton setImage:[UIImage imageNamed:@"browserNav_postActive.png"] forState:UIControlStateNormal];
	[browserPostButton addTarget:self action:@selector(browseToPostURL) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserPostButton];
	
	
	
	
	
	NSString *usernameString = appDelegate.settings_moodleEmail;
	NSString *passwordString = appDelegate.settings_moodlePassword;
	NSString *cookieString = @"1";
	
	NSString *urlString = [NSString stringWithFormat:@"http://%@/login/index.php",appDelegate.settings_moodleURL];
	//NSString *urlString = @"http://127.0.0.1/formTest.cfm";

	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	request.HTTPShouldHandleCookies = YES;
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] globallyUniqueString]];
	
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",usernameString] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",passwordString] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"testcookies\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",cookieString] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",@"login"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	
	[forumWebView loadRequest:request];
	
	
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
		[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
}

- (void)browseToImageURL {
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
	imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
    // Picker is displayed asynchronously.
    [[self navigationController] presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSLog(@"IMAGE PICKER CODE RUNNING");
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// send image to Moodle form
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[NSThread sleepForTimeInterval:0.5];
	
	NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
	
	NSString *urlString = [NSString stringWithFormat:@"http://%@/mod/forum/post.php?forum=15",appDelegate.settings_moodleURL];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] globallyUniqueString]];
	
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	// moodle required fields
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"MAX_FILE_SIZE\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"2097152"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"subscribe\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"timestart\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"timeend\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"edit\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"reply\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"course\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"5"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"forum\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"15"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"discussion\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"parent\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"6"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"groupid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sesskey\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"gRO8KMa5Aj"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// subject and image fields
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"attachment\"; filename=\"imageFromEducate.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:imageData];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"subject\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Image Post From Educate"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Image Post From Educate"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	
	
	[forumWebView loadRequest:request];
	NSLog(@"Sending Image To Moodle");
	
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[pool release];
	
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    
}



- (void)browseToPostURL {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/mod/forum/post.php?forum=15",appDelegate.settings_moodleURL]]]];
	
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[forumWebView release];
    [super dealloc];
}


@end
