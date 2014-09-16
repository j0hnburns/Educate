//
//  ForumBrowserViewController.m
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ForumBrowserViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"


@implementation ForumBrowserViewController
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
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
	customNavHeader.viewHeader.text = @"Help Forums";
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
	
	// if Moodle settings are configured then push the view controller otherwise display the alert
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.internetConnectionStatus == NotReachable) {
			
			// if first offline failure then notify user with alert box
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to connect to the support forum.  You will not be able to use the support forum in Educate until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			
	} else {
		// connection exists, load the support URL
		
		[forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/EducateApp"]]];
		
	}
	
	
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
	[browserPostButton setImage:[UIImage imageNamed:@"browserNav_postBlank.png"] forState:UIControlStateNormal];
	//[browserPostButton addTarget:self action:@selector(browseToPostURL) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserPostButton];
	
	
	
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
}


- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}



- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

// check whether the app launch message has been shown previously, if not show the launch message
BOOL hasShownApplication102ForumFirstLaunchMessage = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownApplication102ForumFirstLaunchMessage"];

// show first launch message if not already shown
if (!hasShownApplication102ForumFirstLaunchMessage) {
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Educate Forum Notice" message:@"Educate's ibuilt Facebook support will return shortly.  Please join us at www.facebook.com/EducateApp for discussion and support." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	
	hasShownApplication102ForumFirstLaunchMessage = YES;
	[[NSUserDefaults standardUserDefaults] setBool:hasShownApplication102ForumFirstLaunchMessage forKey:@"hasShownApplication102ForumFirstLaunchMessage"]; 
	 */
}
	
	
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
