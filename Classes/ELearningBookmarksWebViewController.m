//
//  ELearningBookmarksWebViewController.m
//  Educate
//
//  Created by James Hodge on 29/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "ELearningBookmarksWebViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "EducateAppDelegate.h"

@implementation ELearningBookmarksWebViewController

@synthesize bookmarkWebView;
@synthesize	bookmarkURL;
@synthesize	URLString;
@synthesize titleString;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
 
 [[self navigationController] setNavigationBarHidden:YES animated:NO];
 
	URLString =	@"";
	bookmarkURL = [NSURL URLWithString:URLString];
	titleString =	@"Bookmark Web Viewer";
		
 UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
 viewBackground.frame = CGRectMake(0,0,320,480);
 [self.view addSubview:viewBackground];
 [viewBackground release];
 
 
 customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
 customNavHeader.viewHeader.text = titleString;
 customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:16];
 [self.view addSubview:customNavHeader];
 
 UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
 backButton.frame = CGRectMake(0, 0, 53, 43);
 [backButton setTitle:@"" forState:UIControlStateNormal];
 [backButton setBackgroundColor:[UIColor clearColor]];
 [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
 [backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
 [customNavHeader addSubview:backButton];
 
 
 bookmarkWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,44,320,330)];
 bookmarkWebView.scalesPageToFit = YES;
 bookmarkWebView.delegate = self;
 [self.view addSubview:bookmarkWebView];
 
		
		UIButton* browserBackButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		browserBackButton.frame = CGRectMake(0, 370, 52, 41);
		[browserBackButton setBackgroundColor:[UIColor clearColor]];
		[browserBackButton setImage:[UIImage imageNamed:@"browserNav_back.png"] forState:UIControlStateNormal];
		[browserBackButton addTarget:bookmarkWebView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:browserBackButton];
		
		UIButton* browserForwardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		browserForwardButton.frame = CGRectMake(52, 370,52, 41);
		[browserForwardButton setBackgroundColor:[UIColor clearColor]];
		[browserForwardButton setImage:[UIImage imageNamed:@"browserNav_forward.png"] forState:UIControlStateNormal];
		[browserForwardButton addTarget:bookmarkWebView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:browserForwardButton];
		
		UIButton* browserStopButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		browserStopButton.frame = CGRectMake( 106, 370,55, 41);
		[browserStopButton setBackgroundColor:[UIColor clearColor]];
		[browserStopButton setImage:[UIImage imageNamed:@"browserNav_stop.png"] forState:UIControlStateNormal];
		[browserStopButton addTarget:bookmarkWebView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:browserStopButton];
		
		UIButton* browserReloadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		browserReloadButton.frame = CGRectMake( 161,370, 55, 41);
		[browserReloadButton setBackgroundColor:[UIColor clearColor]];
		[browserReloadButton setImage:[UIImage imageNamed:@"browserNav_reload.png"] forState:UIControlStateNormal];
		[browserReloadButton addTarget:bookmarkWebView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
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
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
		
		
	
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
	
	
	customNavHeader.viewHeader.text = titleString;
	
	
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
	[bookmarkWebView stopLoading];
	
}

- (void)loadURLForString:(NSString *)withString {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (appDelegate.internetConnectionStatus == NotReachable) {
		
		// if first offline failure then notify user with alert box
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to connect to this bookmark.  You will not be able to access this bookmark in Educate until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	} else {
		// connection exists, load the support URL
		
		[bookmarkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:withString]]];
		
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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[bookmarkWebView release];
	//[bookmarkURL release];
	[URLString release];
    [super dealloc];
}


@end
