//
//  DailyPlannerScrollViewController.m
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DailyPlannerScrollViewController.h"
#import "dailyPlannerLandscapeViewCell.h"
#import "DailyPlannerLandscapeHeaderCell.h"
#import "dailyPlannerLandscapeNameViewCell.h"
#import "DailyPlannerLandscapeNameHeaderCell.h"
#import "DailyPlannerSettingsViewController.h"
#import "DailyPlannerLessonInstanceEditorViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"



@implementation DailyPlannerScrollViewController

@synthesize weeklyPlannerScrollView;
@synthesize weeklyPlannerTableView;
@synthesize weeklyPlannerTableNameView;
@synthesize localPlannerStructureArray;
@synthesize customNavHeader;
@synthesize viewBackground;
@synthesize settingsButton;

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
	// setup tableView delegates & settings
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Timetable";
	[self.view addSubview:customNavHeader];
	
	// setup navigation header and settings button
		self.title = @"Timetable";
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(250, 5, 70, 30);
	[settingsButton setTitle:@"Edit" forState:UIControlStateNormal];
	[settingsButton setBackgroundColor:[UIColor clearColor]];
	[settingsButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
	[settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[settingsButton addTarget:self action:@selector(showSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	
	weeklyPlannerTableNameView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,70,370) style:UITableViewStylePlain];
	weeklyPlannerTableNameView.delegate = self;
	weeklyPlannerTableNameView.dataSource = self;	weeklyPlannerTableNameView.scrollEnabled = YES;
	weeklyPlannerTableNameView.rowHeight = 40;
	weeklyPlannerTableNameView.backgroundColor = [UIColor clearColor];
	weeklyPlannerTableNameView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:weeklyPlannerTableNameView];
	
	weeklyPlannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, 44, 250, 370)];
	[weeklyPlannerScrollView setCanCancelContentTouches:NO];
	weeklyPlannerScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	weeklyPlannerScrollView.scrollEnabled = YES;
	weeklyPlannerScrollView.directionalLockEnabled = YES;
	weeklyPlannerScrollView.alwaysBounceVertical = NO;
	weeklyPlannerScrollView.pagingEnabled = NO;
	weeklyPlannerScrollView.delegate = self;
	weeklyPlannerScrollView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:weeklyPlannerScrollView];
	//[labelPeriodType release];
	
	
	weeklyPlannerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,(85*[appDelegate.settings_plannerDayCycleLength intValue]),(40*([localPlannerStructureArray count]+2))) style:UITableViewStylePlain];
	weeklyPlannerTableView.delegate = self;
	weeklyPlannerTableView.dataSource = self;
	weeklyPlannerTableView.scrollEnabled = YES;
	weeklyPlannerTableView.rowHeight = 40;
	weeklyPlannerTableView.backgroundColor = [UIColor clearColor];
	weeklyPlannerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[weeklyPlannerScrollView addSubview:weeklyPlannerTableView];
	
	weeklyPlannerTableView.frame = CGRectMake(0,0,(85*[appDelegate.settings_plannerDayCycleLength intValue]),370);
	weeklyPlannerTableNameView.frame = CGRectMake(0,44,70,(40*([localPlannerStructureArray count]+2)));
	[weeklyPlannerScrollView setContentSize:CGSizeMake(85*[appDelegate.settings_plannerDayCycleLength intValue], (40*([localPlannerStructureArray count]+2)))];
	
    [super viewDidLoad];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (scrollView == weeklyPlannerTableView) {
		
		[weeklyPlannerTableView setContentOffset:CGPointMake(0,[weeklyPlannerTableNameView contentOffset].y)];
		[weeklyPlannerScrollView setContentOffset:CGPointMake([weeklyPlannerScrollView contentOffset].x,0)];		
	} else if (scrollView == weeklyPlannerTableNameView) {
		
		[weeklyPlannerTableView setContentOffset:CGPointMake(0,[scrollView contentOffset].y)];
		[weeklyPlannerScrollView setContentOffset:CGPointMake([weeklyPlannerScrollView contentOffset].x,0)];		
	} else if (scrollView == weeklyPlannerScrollView) {
		
		[weeklyPlannerScrollView setContentOffset:CGPointMake([scrollView contentOffset].x,0)];	} 	
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		return [localPlannerStructureArray count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (tableView == weeklyPlannerTableNameView) {
		
		// code for name column
	
	if (indexPath.section == 0) {
		
		// header row
		
		static NSString *CellIdentifier = @"dailyPlannerLandscapeNameHeaderCell";
		
		DailyPlannerLandscapeNameHeaderCell *cell = (DailyPlannerLandscapeNameHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[DailyPlannerLandscapeNameHeaderCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.backgroundColor = [UIColor clearColor];
		return cell;
		
		
	} else {
	
  		
		static NSString *CellIdentifier = @"dailyPlannerLandscapeNameViewCell";
		
		dailyPlannerLandscapeNameViewCell *cell = (dailyPlannerLandscapeNameViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[dailyPlannerLandscapeNameViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
			
		[cell setDefaultButtonTitleColours];
		
		cell.labelBackground.image = [UIImage imageNamed:@"blank.png"];

		cell.periodNameLabel.text = [[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:1];
		[cell setPeriodID:[[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:3] intValue]];
		[cell populateCellNames];
		
		// check if row odd or even and colour accordingly
		if (indexPath.row & 1) {
			// row is odd, colour cream with white period name
			[cell setButtonAppearanceForOddRow];
		} else {
			
			// row is even, colour grey gradient with blue period name
			[cell setButtonAppearanceForEvenRow];
		}
		
		if ([[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Break"]) {
			[cell setButtonAppearanceForBreakRow];						
		}
		
		
		cell.backgroundColor = [UIColor clearColor];
		return cell;
	}
		
	} else { // code for values columns
		
		if (indexPath.section == 0) {
			
			// header row
			
			static NSString *CellIdentifier = @"dailyPlannerLandscapeHeaderCell";
			
			DailyPlannerLandscapeHeaderCell *cell = (DailyPlannerLandscapeHeaderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[DailyPlannerLandscapeHeaderCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			
			cell.backgroundColor = [UIColor clearColor];
			[cell updateValueFromTextEditor];
			[cell populateCells];
			return cell;
			
			
		} else {
			
			
			static NSString *CellIdentifier = @"dailyPlannerLandscapeViewCell";
			
			dailyPlannerLandscapeViewCell *cell = (dailyPlannerLandscapeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[dailyPlannerLandscapeViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			}
			
			[cell setDefaultButtonTitleColours];
			
			cell.labelBackground.image = [UIImage imageNamed:@"blank.png"];
			
			cell.periodNameLabel.text = [[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:1];
			[cell setPeriodID:[[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:3] intValue]];
			[cell populateCellNames];
			
			// check if row odd or even and colour accordingly
			if (indexPath.row & 1) {
				// row is odd, colour cream with white period name
				[cell setButtonAppearanceForOddRow];
			} else {
				
				// row is even, colour grey gradient with blue period name
				[cell setButtonAppearanceForEvenRow];
			}
			
			if ([[[localPlannerStructureArray objectAtIndex:indexPath.row] objectAtIndex:2] isEqualToString:@"Break"]) {
				[cell setButtonAppearanceForBreakRow];						
			}
			
			
			
			cell.backgroundColor = [UIColor clearColor];
			return cell;
		}
		
	}
		
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void) didRotate:(NSNotification *)notification {
	
	if ([self.tabBarController selectedIndex] == 0) {
		// only rotate if the planner is the current controller - if not, handle rotation when we switch to this controller
	
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
	
	
}



- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"dailyPlanner ViewWillAppear");
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate setCurrentViewControllerRotationStatus:YES];
	
	[self initialiseLocalPlannerArray];
	[weeklyPlannerTableView reloadData];
	[weeklyPlannerTableNameView reloadData];
	weeklyPlannerTableView.frame = CGRectMake(0,0,(85*[appDelegate.settings_plannerDayCycleLength intValue]),(40*([localPlannerStructureArray count]+2)));
	weeklyPlannerTableNameView.frame = CGRectMake(0,44,70,370);
	[weeklyPlannerScrollView setContentSize:CGSizeMake(weeklyPlannerTableView.frame.size.width, (40*([localPlannerStructureArray count]+2)))];
	// code to fix the 10 pixel offset issue upon launch
	// run only once
	if (!hasInitialised) {
		[appDelegate enterLandscapeMode:YES];
		[appDelegate exitLandscapeMode];
		hasInitialised = YES;
	}
	
	
	// switch full screen orientation if required
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
		[self enterLandscapeMode:YES];
	}
	else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
		[self enterLandscapeMode:NO];
	} else {
		[self exitLandscapeMode];
	}
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"dailyPlanner ViewDidAppear");
	[super viewDidAppear:animated];
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];

	[appDelegate forceOrientationRefresh];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
		
}

- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"Daily Planner Scroll View Will Disappear");
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate setCurrentViewControllerRotationStatus:NO];
	[self exitLandscapeMode];
	[appDelegate exitLandscapeMode];
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate exitLandscapeMode];
}
	
- (void) enterLandscapeMode:(BOOL)left {
	// setup the application to display landscape objects in appropriate format
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"dailyPlannerScrollViewController enterLandscapeMode");
	
	// hide the tabBarController
	//CGRect tempRect = self.tabBarController.view.frame;
	//self.tabBarController.view.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y, tempRect.size.width, tempRect.size.height+49);
	
	if (left) { // device is rotated to the left
		//[self.tabBarController.view setTransform:CGAffineTransformMakeRotation(DegreesToRadians(90))];
		//[self.tabBarController.view setTransform:CGAffineTransformMakeTranslation(20, 0)];
						
		//[[self tabBarController] setTabBarHidden:YES animated:YES];
		weeklyPlannerScrollView.frame = CGRectMake(70,44,410,229);
		//[weeklyPlannerScrollView setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(90 * M_PI / 180),CGAffineTransformMakeTranslation(-80, 80))];
		
		customNavHeader.frame = CGRectMake(0,0,480,44);
		viewBackground.frame = CGRectMake(0,44,480,229);
		settingsButton.frame = CGRectMake(410, 5, 70, 30);
		[customNavHeader setLandscapeOrientation];
		
		
		
	} else { // device is rotated to the right
		//[[self navigationController] setNavigationBarHidden:YES animated:YES];
		weeklyPlannerScrollView.frame = CGRectMake(70,44,410,229);
		//[weeklyPlannerScrollView setTransform:CGAffineTransformConcat(CGAffineTransformMakeRotation(-90 * M_PI / 180),CGAffineTransformMakeTranslation(-80, 80))];
		
		
		customNavHeader.frame = CGRectMake(0,0,480,44);
		viewBackground.frame = CGRectMake(0,44,480,229);
		settingsButton.frame = CGRectMake(410, 5, 70, 30);
		[customNavHeader setLandscapeOrientation];
	}
	//[weeklyPlannerTableView reloadData];
	weeklyPlannerTableView.frame = CGRectMake(0,0,(85*[appDelegate.settings_plannerDayCycleLength intValue]),(40*([localPlannerStructureArray count]+2)));
	weeklyPlannerTableNameView.frame = CGRectMake(0,44,70,229);
	[weeklyPlannerScrollView setContentSize:CGSizeMake(85*[appDelegate.settings_plannerDayCycleLength intValue], (40*([localPlannerStructureArray count]+2)))];
	
	
	
}


- (void) exitLandscapeMode {
	
	//[[self navigationController] setNavigationBarHidden:NO animated:YES];
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
		
	weeklyPlannerScrollView.frame = CGRectMake(70,44,250,370);
	customNavHeader.frame = CGRectMake(0,0,320,44);
	viewBackground.frame = CGRectMake(0,0,320,480);
	settingsButton.frame = CGRectMake(250, 5, 70, 30);
	[customNavHeader setPortraitOrientation];
	//[weeklyPlannerTableView reloadData];
	weeklyPlannerTableView.frame = CGRectMake(0,0,(85*[appDelegate.settings_plannerDayCycleLength intValue]),(40*([localPlannerStructureArray count]+2)));
	weeklyPlannerTableNameView.frame = CGRectMake(0,44,70,370);
	[weeklyPlannerScrollView setContentSize:CGSizeMake(85*[appDelegate.settings_plannerDayCycleLength intValue], (40*([localPlannerStructureArray count]+2)))];
	

}



- (void)showSettingsViewController {
	// load new navigation controller and put settings view into the controller, then pop as modal controller
	DailyPlannerSettingsViewController *dailyPlannerSettingsViewController = [[DailyPlannerSettingsViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:dailyPlannerSettingsViewController];
    
	// present navigation controller as modal controller
	[self.navigationController
	 presentModalViewController:settingsNavigationController animated:YES];
	// now release controller objects
	[settingsNavigationController release];
    [dailyPlannerSettingsViewController release];
	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Open the database connection and retrieve array contents
- (void)initialiseLocalPlannerArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (localPlannerStructureArray == nil) {
		localPlannerStructureArray = [[NSMutableArray alloc] init];
	} else {
		while ([localPlannerStructureArray count] > 0) {
			[localPlannerStructureArray removeLastObject];
		}
	}
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT periodOrder, periodName, periodType, periodID FROM weeklyPlannerStructure ORDER BY periodOrder";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			//int success =sqlite3_step(statement);
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int rowPeriodOrder = sqlite3_column_int(statement, 0);
				char *rowPeriodName = (char *)sqlite3_column_text(statement, 1);
				char *rowPeriodType = (char *)sqlite3_column_text(statement, 2);
				int rowPeriodID	= sqlite3_column_int(statement, 3);
				[localPlannerStructureArray addObject:[[NSMutableArray arrayWithObjects:
														[NSNumber numberWithInt:rowPeriodOrder],
														(rowPeriodName) ? [NSString stringWithUTF8String:rowPeriodName] : @"",
														(rowPeriodType) ? [NSString stringWithUTF8String:rowPeriodType] : @"",
														[NSNumber numberWithInt:rowPeriodID],
														nil] retain]];
				
				NSLog(@"Structure Row: %i, %@, %@, %i", rowPeriodOrder, [NSString stringWithUTF8String:rowPeriodName], [NSString stringWithUTF8String:rowPeriodType], rowPeriodID);
				
				rowNumber +=1;
			}
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Database Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[pool release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[weeklyPlannerScrollView release];
	[weeklyPlannerTableView release];
	[weeklyPlannerTableNameView release];
	[localPlannerStructureArray release];
	[customNavHeader release];
	[viewBackground release];
	[settingsButton release];
    [super dealloc];
}


@end
