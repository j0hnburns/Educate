//
//  ELearningBrowserBlackBoardController.m
//  Educate
//
//  Created by James Hodge on 9/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ELearningBrowserBlackBoardController.h"
#import "CustomNavigationHeaderThin.h"
#import "EducateAppDelegate.h"
#import "base64.h"
#import "MD5.h"



@implementation ELearningBrowserBlackBoardController
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
	customNavHeader.viewHeader.text = @"BlackBoard";
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
	[browserImageButton setImage:[UIImage imageNamed:@"browserNav_imageActive.png"] forState:UIControlStateNormal];
	[browserImageButton addTarget:self action:@selector(browseToImageURL) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserImageButton];
	
	UIButton* browserPostButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	browserPostButton.frame = CGRectMake(271, 370, 52, 41);
	[browserPostButton setBackgroundColor:[UIColor clearColor]];
	[browserPostButton setImage:[UIImage imageNamed:@"browserNav_postActive.png"] forState:UIControlStateNormal];
	[browserPostButton addTarget:self action:@selector(browseToPostURL) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:browserPostButton];
	
	
	
	
	
	NSString *usernameString = appDelegate.settings_googleEmail;
	NSString *passwordString = appDelegate.settings_googlePassword;
	NSString *cookieString = @"1";
	
	// need to URL encode the passwords for Blackboard
	// below is the javascript code from the website that needs to be replicated here
	
	/*
	 function validate_form(form)
	 {
	 form.user_id.value = form.user_id.value.replace(/^\s*|\s*$/g,"");
	 if ( form.user_id.value == "" || form.password.value == "" )
	 {
	 alert( "Enter a username and password." );
	 return false;
	 }
	 //short-cut if challenge/response is disabled.
	 if ( !_useChallenge )
	 {
	 form.encoded_pw.value = base64encode( form.password.value );
	 form.encoded_pw_unicode.value = b64_unicode( form.password.value );
	 form.password.value =  "";
	 return true;
	 }
	 
	 var passwd_enc = hex_md5(form.password.value);
	 var encoded_pw_unicode = calcMD5(form.password.value);
	 var final_to_encode = passwd_enc + form.one_time_token.value;
	 form.encoded_pw.value = hex_md5(final_to_encode);
	 final_to_encode = encoded_pw_unicode + form.one_time_token.value;
	 form.encoded_pw_unicode.value = calcMD5(final_to_encode);
	 form.password.value = "";
	 return true;
	 }
	 
	 </SCRIPT>
	 <FORM ONSUBMIT="return validate_form(this)" METHOD="POST" ACTION="https://coursesites.blackboard.com/webapps/login/" NAME="login" target="_top">
	 <INPUT VALUE="login" NAME="action" TYPE="HIDDEN">
	 <INPUT VALUE="" NAME="remote-user" TYPE="HIDDEN">
	 <INPUT VALUE="" NAME="new_loc" TYPE="HIDDEN">
	 <INPUT VALUE="" NAME="auth_type" TYPE="HIDDEN">
	 <INPUT VALUE="FFA07732018E3B76F25C2D96C6D06051" NAME="one_time_token" TYPE="HIDDEN">
	 <INPUT VALUE="" NAME="encoded_pw" TYPE="HIDDEN">
	 <INPUT VALUE="" NAME="encoded_pw_unicode" TYPE="HIDDEN">
	 <TABLE>
	 
	 */
	
	NSString *urlString = [NSString stringWithFormat:@"https://%@/webapps/login/",appDelegate.settings_blackboardURL];
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
	[body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"login" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"remote-user\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"auth-type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"one_time_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"FFA07732018E3B76F25C2D96C6D06051" dataUsingEncoding:NSUTF8StringEncoding]];
	// replace this with UUID generated by app
	

	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"encoded_pw\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithBase64EncodedString:passwordString]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"encoded_pw_unicode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[[NSData dataWithBase64EncodedString:passwordString] description] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%@",@"login"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:body];
	
	
	[forumWebView loadRequest:request];
	
	/*
	 var passwd_enc = hex_md5(form.password.value);
	 var encoded_pw_unicode = calcMD5(form.password.value);
	 var final_to_encode = passwd_enc + form.one_time_token.value;
	 form.encoded_pw.value = hex_md5(final_to_encode);
	 final_to_encode = encoded_pw_unicode + form.one_time_token.value;
	 form.encoded_pw_unicode.value = calcMD5(final_to_encode);
	 form.password.value = "";
	 return true;
	 */	 
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
}

- (void)browseToImageURL {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
	// test code - we are going to populate the forms in the webview using javascript then post it using javascript
	
	//javascriptReturnString = [forumWebView stringByEvaluatingJavaScriptFromString:@"alert(document.forms['login'].elements['user_id']);"];
	
	//javascriptReturnString = [forumWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.login.password.value=%@;",appDelegate.settings_blackboardPassword]];
	
	NSString* javascriptReturnString = [forumWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"];
	NSLog(javascriptReturnString);
	
	
}

- (void)browseToPostURL {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[forumWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/bin/common/announcement.pl?action=ADD&course_id=_193511_1&render_type=EDITABLE&context=course",appDelegate.settings_blackboardURL]]]];
	
	
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