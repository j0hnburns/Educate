//
//  DailyPlannerTableViewController.m
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerTableViewController.h"
#import "DailyPlannerPortraitViewCell.h"
#import "dailyPlannerLandscapeViewCell.h"
#import "DailyPlannerSettingsViewController.h"
#import "DailyPlannerLessonInstanceEditorViewController.h"
#import "EducateAppDelegate.h"

@implementation DailyPlannerTableViewController



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
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	//self.view.autoresizesSubviews = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.scrollEnabled = YES;
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.rowHeight = 48;
	
	
	self.title = @"Timetable";	

	UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsViewController)];
	[self.navigationItem setRightBarButtonItem:settingsButton animated:YES];
	[settingsButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
		

    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [[appDelegate structureArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString* weekdayName = [dateFormatter stringFromDate:now];
	//[dateFormatter release];
	//[now release];
	
	// check orientation of iPhone, display appropriate cell
	
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
		
		
		static NSString *CellIdentifier = @"dailyPlannerLandscapeViewCell";
		
		dailyPlannerLandscapeViewCell *cell = (dailyPlannerLandscapeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[dailyPlannerLandscapeViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}

			
		[cell setPeriodID:indexPath.row];
		[cell populateCellNames];
		
		return cell;
		
	} else {
		static NSString *CellIdentifier = @"dailyPlannerPortraitViewCell";
		
		DailyPlannerPortraitViewCell *cell = (DailyPlannerPortraitViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[DailyPlannerPortraitViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Set up the cell to describe each period
		
		cell.periodNameLabel.text = [[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:2];
		
		int i = 0;
		while ([[appDelegate weeklyPlannerArray] count] > i) {
				
			NSLog(@"Comparing %@ and %@, %@ and %@",[[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:0],[[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:2],[[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:1],weekdayName);
			
						if ([[[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:0] isEqualToString:[[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:2]] && [[[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:1] isEqualToString:weekdayName]) {
				cell.lessonNameLabel.text = [[[appDelegate weeklyPlannerArray] objectAtIndex:i] objectAtIndex:2];
							[cell setPeriodID:i];
				break;
				
			}
			i +=1;
		}
		
		
		/*
		if ([[[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Lesson"]) {
			cell.periodNameLabel.backgroundColor = [UIColor greenColor];
		} else if ([[[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Break"]) {
			cell.periodNameLabel.backgroundColor = [UIColor blueColor];
		}
		*/
		return cell;
		
		
		
	}
	
        
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// if selected cell in the lesson list, create and push the lesson editor controller

	if (!([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)) {

		
		DailyPlannerLessonInstanceEditorViewController *dailyPlannerLessonInstanceEditorViewController = [DailyPlannerLessonInstanceEditorViewController alloc];    
		dailyPlannerLessonInstanceEditorViewController.title = [NSString stringWithFormat:@"%@ %@",[[[appDelegate structureArray] objectAtIndex:indexPath.row] objectAtIndex:2],[[[appDelegate weeklyPlannerArray] objectAtIndex:[[tableView cellForRowAtIndexPath:indexPath] getPeriodID]] objectAtIndex:1]];
	
	
	
	dailyPlannerLessonInstanceEditorViewController.periodID = [NSNumber numberWithInt:[[tableView cellForRowAtIndexPath:indexPath] getPeriodID]];
	

		
		[[self navigationController] pushViewController:dailyPlannerLessonInstanceEditorViewController animated:YES];
		[dailyPlannerLessonInstanceEditorViewController release];
	}
		
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

- (void) enterLandscapeMode:(BOOL)left {
	// setup the application to display landscape objects in appropriate format
	
	
	if (left) { // device is rotated to the left
		
		self.view.frame = CGRectMake(0,0,480,320);		
		self.tableView.frame = self.view.frame;
		
		[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
		
		
	} else { // device is rotated to the right
		self.view.frame = CGRectMake(0,0,480,320);
		
		[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft];
	}
	
	self.title = @"Timetable";
	[self.tableView reloadData];
	
	
}


- (void) exitLandscapeMode {
	
			
	self.view.frame = CGRectMake(0,0,320,480);		
	self.tableView.frame = self.view.frame;
	[self.tableView reloadData];
	
	
}



- (void)showSettingsViewController {
	// load new navigation controller and put settings view into the controller, then pop as modal controller
	DailyPlannerSettingsViewController *dailyPlannerSettingsViewController = [DailyPlannerSettingsViewController alloc];
	UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:dailyPlannerSettingsViewController];
    
	// present navigation controller as modal controller
	[self.navigationController
	 presentModalViewController:settingsNavigationController animated:YES];
	// now release controller objects
	[settingsNavigationController release];
    [dailyPlannerSettingsViewController release];
		
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
