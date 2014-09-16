//
//  EducateAppDelegate.m
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright F-I-S-H iPhone Development 2009. All rights reserved.
//

#import "EducateAppDelegate.h"
#import "ELearningViewController.h"
#import "DailyPlannerScrollViewController.h"
#import "StudentFeedbackTableViewController.h"
#import "SettingsViewController.h"
#import "ForumBrowserViewController.h"
#import "TeachingStrategiesViewController.h"
#import "CustomNavigationHeaderThin.h"
#import "GoogleDocsListViewController.h"
#import "DFVideoOut.h"


@implementation EducateAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize eLearningViewController;
@synthesize studentFeedbackTableViewController;
@synthesize studentFeedbackNavigationController;
@synthesize dailyPlannerNavigationController;
@synthesize dailyPlannerScrollViewController;
@synthesize eLearningNavigationController;
@synthesize settingsViewController;
@synthesize settingsNavigationController;
@synthesize teachingStrategiesViewController;
@synthesize teachingStrategiesNavigationController;
@synthesize forumBrowserViewController;
@synthesize forumBrowserNavigationController;
@synthesize googleDocsListViewController;
@synthesize googleDocsNavigationController;
// data storage for the app
@synthesize weeklyPlannerArray;
@synthesize structureArray;
@synthesize weeklyPlannerNotesArray;
@synthesize studentTrackerArray;
@synthesize studentTrackerStudentListArray;
@synthesize internetConnectionStatus;
@synthesize settings_personalFullName;
@synthesize settings_personalEmail;
@synthesize settings_moodleEmail;
@synthesize settings_moodlePassword;
@synthesize settings_googleEmail;
@synthesize settings_googlePassword;
@synthesize settings_blackboardURL;
@synthesize settings_moodleURL;
@synthesize settings_plannerDayCycleLength;

CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180; };
CGFloat RadiansToDegrees(CGFloat radians) { return radians * 180/M_PI; };

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
	
	window.backgroundColor = [UIColor blackColor];
	
	
    // Add the tab bar controller's current view as a subview of the window
	tabBarController.delegate = self;
    [window addSubview:tabBarController.view];
	
	
	NSLog(@"Startup - Defaults");
	// load settings values from default store, or create new empty values if none exist
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	settings_personalFullName = @"";
	settings_personalEmail = @"";
	settings_moodleEmail = @"";
	settings_moodlePassword = @"";
	settings_googleEmail = @"";
	settings_googlePassword = @"";
	settings_moodleURL = @"";
	settings_blackboardURL = @"";
	settings_plannerDayCycleLength = [NSNumber numberWithInt:5];
	
	settings_personalFullName = [userDefaults objectForKey:@"settings_personalFullName"];
	settings_personalEmail = [userDefaults objectForKey:@"settings_personalEmail"];
	settings_moodleEmail = [userDefaults objectForKey:@"settings_moodleEmail"];
	settings_moodlePassword = [userDefaults objectForKey:@"settings_moodlePassword"];
	settings_googleEmail = [userDefaults objectForKey:@"settings_blackboardEmail"];
	settings_googlePassword = [userDefaults objectForKey:@"settings_blackboardPassword"];
	settings_moodleURL = [userDefaults objectForKey:@"settings_moodleURL"];
	settings_blackboardURL = [userDefaults objectForKey:@"settings_blackboardURL"];
	settings_plannerDayCycleLength = [userDefaults objectForKey:@"settings_plannerDayCycleLength"];
	
	if ([settings_personalFullName isEqualToString:@""]) {
		settings_personalFullName = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_personalFullName forKey:@"settings_personalFullName"];
	}
	if ([settings_personalEmail isEqualToString:@""]) {
		settings_personalEmail = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_personalEmail forKey:@"settings_personalEmail"];
	}
	if ([settings_moodleEmail isEqualToString:@""]) {
		settings_moodleEmail = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_moodleEmail forKey:@"settings_moodleEmail"];
	}
	if ([settings_moodlePassword isEqualToString:@""]) {
		settings_moodlePassword = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_moodlePassword forKey:@"settings_moodlePassword"];
	}
	if ([settings_googleEmail isEqualToString:@""]) {
		settings_googleEmail = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_googleEmail forKey:@"settings_blackboardEmail"];
	}
	if ([settings_googlePassword isEqualToString:@""]) {
		settings_googlePassword = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_googlePassword forKey:@"settings_blackboardPassword"];
	}
	if ([settings_blackboardURL isEqualToString:@""]) {
		settings_blackboardURL = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_blackboardURL forKey:@"settings_blackboardURL"];
	}
	if ([settings_moodleURL isEqualToString:@""]) {
		settings_moodleURL = @"";
		[[NSUserDefaults standardUserDefaults] setObject:settings_moodleURL forKey:@"settings_moodleURL"];
	}
	if (settings_plannerDayCycleLength == nil) {
		settings_plannerDayCycleLength = [NSNumber numberWithInt:4];
		[[NSUserDefaults standardUserDefaults] setObject:settings_plannerDayCycleLength forKey:@"settings_plannerDayCycleLength"];
	}
	
	
	
	
	NSLog(@"Startup - Reachability");
	/*
     You can use the Reachability class to check the reachability of a remote host
     by specifying either the host's DNS name (www.apple.com) or by IP address.
     */
	
	// The Reachability class is capable of notifying your application when the network
	// status changes. By default, those notifications are not enabled.
	// Uncomment the following line to enable them:
	[[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
    
	// Query the SystemConfiguration framework for the state of the device's network connections.
	self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
	
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:@"kNetworkReachabilityChangedNotification" object:nil];
	
	
	// check whether the app launch message has been shown previously, if not show the launch message
	hasShownApplication21FirstLaunchMessage = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownApplication21FirstLaunchMessage"];
	
    // show first launch message if not already shown
	if (!hasShownApplication21FirstLaunchMessage) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Educate 2.1!" message:@"A full overview of changes can be found on our Facebook group at www.facebook.com/educateapp" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		
		hasShownApplication21FirstLaunchMessage = YES;
		[[NSUserDefaults standardUserDefaults] setBool:hasShownApplication21FirstLaunchMessage forKey:@"hasShownApplication21FirstLaunchMessage"];
	}
	
	// setup UI style for 'More' controller
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	/*
	[tabBarController.moreNavigationController setNavigationBarHidden:YES animated:NO];
	
	
	UIImageView* moreViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	moreViewBackground.frame = CGRectMake(0,0,320,480);
	[tabBarController.moreNavigationController.view addSubview:moreViewBackground];
	[moreViewBackground release];
	
	
	CustomNavigationHeaderThin* moreCustomNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,51)];
	moreCustomNavHeader.viewHeader.text = @"More...";
	tabBarController.moreNavigationController.tableView.tableHeaderView = moreCustomNavHeader;
	*/
	
	
	
	

	// load navigation controller for daily planner and intialise
	dailyPlannerScrollViewController = [[DailyPlannerScrollViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:dailyPlannerScrollViewController];
    self.dailyPlannerNavigationController = aNavigationController;
    [aNavigationController release];
    [dailyPlannerScrollViewController release];
	
	
	// load navigation controller for student feedback and initialise
	studentFeedbackTableViewController = [[StudentFeedbackTableViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *bNavigationController = [[UINavigationController alloc] initWithRootViewController:studentFeedbackTableViewController];
    self.studentFeedbackNavigationController = bNavigationController;
    [bNavigationController release];
    [studentFeedbackTableViewController release];
	
	// load navigation controller for elearning module and initialise
	eLearningViewController = [ELearningViewController alloc];
	UINavigationController *mNavigationController = [[UINavigationController alloc] initWithRootViewController:eLearningViewController];
    self.eLearningNavigationController = mNavigationController;
    [mNavigationController release];
    [eLearningViewController release];
	
	// load navigation controller for teaching strategies module and initialise
	teachingStrategiesViewController = [TeachingStrategiesViewController alloc];
	UINavigationController *tNavigationController = [[UINavigationController alloc] initWithRootViewController:teachingStrategiesViewController];
    self.teachingStrategiesNavigationController = tNavigationController;
    [tNavigationController release];
    [teachingStrategiesViewController release];
	
	// load navigation controller for help forum module and initialise
	forumBrowserViewController = [ForumBrowserViewController alloc];
	UINavigationController *fNavigationController = [[UINavigationController alloc] initWithRootViewController:forumBrowserViewController];
    self.forumBrowserNavigationController = fNavigationController;
    [fNavigationController release];
    [forumBrowserViewController release];
	
	// load navigation controller for application settings module and initialise
	settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *asNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    self.settingsNavigationController = asNavigationController;
    [asNavigationController release];
    [settingsViewController release];
	
	/*
	// load navigation controller for google docs module and initialise
	googleDocsListViewController = [[GoogleDocsListViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *gdNavigationController = [[UINavigationController alloc] initWithRootViewController:googleDocsListViewController];
    self.googleDocsNavigationController = gdNavigationController;
    [gdNavigationController release];
    [googleDocsListViewController release];
	 */
	// set up app delegate to receive rotation notifications
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	// load cached structureArray array or create a new one if not in user defaults
	// this is the array that holds the daily planner structure
	NSMutableArray *tempMutableStructureArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"structureArray"] mutableCopy];
	if (tempMutableStructureArray == nil)
	{
		// user has not launched this app before so set default arrays
		// array format: itemID, type, name, startTime, endTime
		
		// currently populated with dummy data for test purposes - remove and replace with blank array for final
		
		
		tempMutableStructureArray = [[NSMutableArray arrayWithObjects:
									  [[NSMutableArray arrayWithObjects:
										@"1",
										@"Lesson",
										@"Period 1",
										nil] retain],
									  nil] retain];
		
		
	}
	structureArray = tempMutableStructureArray;

	
	// load cached dailyPlannerArray array or create a new one if not in user defaults
	// this is the array that holds the daily planner structure
	NSMutableArray *tempMutableDailyPlannerArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPlannerArray"] mutableCopy];
	if (tempMutableDailyPlannerArray == nil)
	{
		// user has not launched this app before so set default arrays
		// array format: period name, weekday name, subject, classroom
		
		// currently populated with dummy data for test purposes - remove and replace with blank array for final
		
		
		tempMutableDailyPlannerArray = [[NSMutableArray arrayWithObjects:
										 [[NSMutableArray arrayWithObjects:
										   @"Period 1",
										   @"Monday",
										   @"German",
										   @"Classroom A",
										   nil] retain],
										 [[NSMutableArray arrayWithObjects:
										   @"Period 1",
										   @"Tuesday",
										   @"Drama",
										   @"Classroom A",
										   nil] retain],
										 
										 [[NSMutableArray arrayWithObjects:
										   @"Period 1",
										   @"Wednesday",
										   @"English",
										   @"Classroom A",
										   nil] retain],
										 
										 [[NSMutableArray arrayWithObjects:
										   @"Period 1",
										   @"Thursday",
										   @"Geography",
										   @"Classroom A",
										   nil] retain],
										 
										 [[NSMutableArray arrayWithObjects:
										   @"Period 1",
										   @"Friday",
										   @"Science",
										   @"Classroom A",
										   nil] retain],
										 
										 nil] retain];
		
		
	}
	weeklyPlannerArray = tempMutableDailyPlannerArray;
	
	// load cached weeklyPlannerNotesArray array or create a new one if not in user defaults
	// this is the array that holds the notes for each subject in the weekly planner
	NSMutableArray *tempMutableNotesArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"weeklyPlannerNotesArray"] mutableCopy];
	if (tempMutableNotesArray == nil)
	{
		
	
	// user has not launched this app before so set default arrays
	// array format: weeklyPlannerRowID, period name, weekday name, note date, note
	
	// currently populated with dummy data for test purposes - remove and replace with blank array for final
	
	
	tempMutableNotesArray = [[NSMutableArray arrayWithObjects:
								  [[NSMutableArray arrayWithObjects:
									@"0",
									@"Period 1",
									@"Monday",
									@"01 Jan 2009",
									@"Notes",
									nil] retain],
								  nil] retain];
	
	
	}
	weeklyPlannerNotesArray = tempMutableNotesArray;
	
	
	/* ****Code Replaced With SQL Call****
	// load cached studentTrackerArray or create a new one if not in user defaults
	// this is the array that holds the student tracker structure
	NSMutableArray *tempStudentTrackerArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"studentTrackerArray"] mutableCopy];
	if (tempStudentTrackerArray == nil)
	{
		// user has not launched this app before so set default array
		// array format: trackerID, trackerName, scale, customScalePoints
		
		// currently populated with dummy data for test purposes - remove and replace with blank array for final
		
		
		tempStudentTrackerArray = [[NSMutableArray arrayWithObjects:
									  [[NSMutableArray arrayWithObjects:
										@"1",
										@"Sample Tracker",
										@"PassFail",
										@"",
										nil] retain],
									  nil] retain];
		
		
	}
	studentTrackerArray = tempStudentTrackerArray;
	
	
	// load cached studentTrackerStudentListArray or create a new one if not in user defaults
	// this is the array that holds the list of students for each student tracker
	NSMutableArray *tempStudentTrackerStudentListArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"studentTrackerStudentListArray"] mutableCopy];
	if (tempStudentTrackerStudentListArray == nil)
	{
		// user has not launched this app before so set default array
		// array format: trackerID, studentName
		
		// currently populated with dummy data for test purposes - remove and replace with blank array for final
		
		
		tempStudentTrackerStudentListArray = [[NSMutableArray arrayWithObjects:
									[[NSMutableArray arrayWithObjects:
									  @"0",
									  @"John Smith",
									  nil] retain],
									nil] retain];
		
		
	}
	studentTrackerStudentListArray = tempStudentTrackerStudentListArray;
	 */
	
	// Initialise Database
	
	[self createEditableCopyOfDatabaseIfNeeded];
	
	
		
	// setup boolean flag for pages that support rotation
	currentViewControllerIsRotatable = NO;
	
	//start video out
	// THIS CODE IS FOR TESTING ONLY
	// TO BE COMMENTED OUT BEFORE SUBMISSION - APP WILL BE REJECTED WITH THIS CODE AS PRIVATE APIS ARE USED
	/*
	DFVideoOut *videoOutTestObject = [[DFVideoOut alloc] init];
	[videoOutTestObject startVideoOut];
	//rotate Interface Orientation (Optional will start in portrait)
	//[videoOutTestObject changeOrientation:interfaceOrientation];
	[videoOutTestObject release];
	*/
	
}


float calcLabelHeight(NSString *string, UIFont *font, int lines, float lineWidth) {
    [ string retain ];
    [ font retain ];
   	
	CGFloat		result = 70.0f;
	
	if (string)
	{
		// The notes can be of any height
		// This needs to work for both portrait and landscape orientations.
		// Calls to the table view to get the current cell and the rect for the 
		// current row are recursive and call back this method.
		CGSize		textSize = { lineWidth, 20000.0f };		// width and height of text area
		CGSize		size = [string sizeWithFont:font constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
		
		size.height += 70.0f;			// top and bottom margin
		result = MAX(size.height, 70.0f);	// at least one row
	}
	
	return result;
	
	
}


// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	// when tabs are changed, check to see if we are on the Daily Planner tab
	// if not, force the switch back to portrait mode as no other tab supports landscape mode
	NSLog(@"tabBarController didSelectViewController delegate executed");
	if ([self.tabBarController selectedIndex] != 0) {
		[self exitLandscapeMode];
		currentViewControllerIsRotatable = NO;
	} else {
		currentViewControllerIsRotatable = YES;
	}
	
	
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
 */

- (BOOL)isCurrentViewControllerRotatable {
	return currentViewControllerIsRotatable;
}

- (void)setCurrentViewControllerRotationStatus:(BOOL)canBeRotated {
	currentViewControllerIsRotatable = canBeRotated;
}


- (void) enterLandscapeMode:(BOOL)left {
	// setup the application to display landscape objects in appropriate format
	
	
	if (currentViewControllerIsRotatable) {
	
	if (left) { // device is rotated to the left
		NSLog(@"appDelegate enterLandscapeModeLeft");
		//[self.tabBarController.view setTransform:CGAffineTransformMakeRotation(DegreesToRadians(90))];
		//[self.tabBarController.view setTransform:CGAffineTransformMakeTranslation(20, 0)];
		
		self.tabBarController.view.frame = CGRectMake(0,0,480,320);
		[self.tabBarController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(DegreesToRadians(90)),CGAffineTransformMakeTranslation(-80, 80))];
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		
		
	} else { // device is rotated to the right
		NSLog(@"appDelegate enterLandscapeModeRight");
		self.tabBarController.view.frame = CGRectMake(0,0,480,320);
		[self.tabBarController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(DegreesToRadians(-90)),CGAffineTransformMakeTranslation(-80, 80))];
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		
	}
		
		
	
	}
		
}


- (void) exitLandscapeMode {
	
	if (self.tabBarController.view.frame.origin.y != 20) {
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
	[self.tabBarController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(DegreesToRadians(0)),CGAffineTransformMakeTranslation(0, 0))];
	//self.tabBarController.view.frame = CGRectMake(0,0,320,480);
	self.tabBarController.view.frame = CGRectMake(0,20,320,460);
	}

}


- (void)forceOrientationRefresh {
	
	// switch full screen orientation if required
	
	
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
		
		[self enterLandscapeMode:YES];
		
	}
	else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
		
		[self enterLandscapeMode:NO];
		
		
	}
	else {
		
		[self exitLandscapeMode];
	}
	
}
	
	
	

- (void) didRotate:(NSNotification *)notification {
	
	// switch full screen orientation if required
	if ([self.tabBarController selectedIndex] == 0) {
		// only execute code if on planner tab, as other tabs don't support rotation
		NSLog(@"appDelegate didRotate");
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
		
		[self enterLandscapeMode:YES];
		
	}
	else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
		
		[self enterLandscapeMode:NO];
		
		
	}
	else {
		
		[self exitLandscapeMode];
	}
		
	}
	 
	

}

// Camera Database Functions

// Copies the database from the resources bundle onto the iPhone

- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	NSLog(writableDBPath);
    success = [fileManager fileExistsAtPath:writableDBPath];
	NSLog(@"Does Database Exist?");
    if (success) {
		NSLog(@"Database Exists!");
		// comment out the return command to force database update
		return;
	}
	NSLog(@"Database Doesn't Exist - Copying!");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"educate2.sql"];
	success = [fileManager removeItemAtPath:writableDBPath error:&error];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// reachability functions

- (void)reachabilityChanged:(NSNotification *)note
{
    self.internetConnectionStatus	= [[Reachability sharedReachability] internetConnectionStatus];
}





- (void)dealloc {
	// save daily planner array
	
	[[NSUserDefaults standardUserDefaults] setObject:weeklyPlannerArray forKey:@"dailyPlannerArray"];
	[[NSUserDefaults standardUserDefaults] setObject:structureArray forKey:@"structureArray"];
	[[NSUserDefaults standardUserDefaults] setObject:weeklyPlannerNotesArray forKey:@"weeklyPlannerNotesArray"];
	[[NSUserDefaults standardUserDefaults] setObject:studentTrackerArray forKey:@"studentTrackerArray"];
	[[NSUserDefaults standardUserDefaults] setObject:studentTrackerStudentListArray forKey:@"studentTrackerStudentListArray"];
	
    [tabBarController release];
    [window release];
	[eLearningViewController release];
	[studentFeedbackTableViewController release];
	[dailyPlannerScrollViewController release];
	[dailyPlannerNavigationController release];
	[studentFeedbackNavigationController release];
	[eLearningNavigationController release];
	[weeklyPlannerArray release];
	[structureArray release];
	[weeklyPlannerNotesArray release];
	[studentTrackerArray release];
	[studentTrackerStudentListArray release];
	[settingsViewController release];
	[settingsNavigationController release];
	[teachingStrategiesViewController release];
	[teachingStrategiesNavigationController release];
	[forumBrowserViewController release];
	[forumBrowserNavigationController release];
	[settings_personalFullName release];
	[settings_personalEmail release];
	[settings_moodleEmail release];
	[settings_moodlePassword release];
	[settings_googleEmail release];
	[settings_googlePassword release];
	[settings_blackboardURL release];
	[settings_moodleURL release];
	[settings_plannerDayCycleLength release];
    [super dealloc];
}

@end

