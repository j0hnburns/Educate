//
//  DailyPlannerLessonInstanceNotesHistoryViewController.m
//  iSNA
//
//  Created by James Hodge on 26/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DailyPlannerLessonInstanceNotesHistoryViewController.h"
#import "EducateAppDelegate.h"
#import "DailyPlannerLessonInstanceNotesHistoryCell.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					165.0

@implementation DailyPlannerLessonInstanceNotesHistoryViewController


@synthesize localWeeklyPlannerArrayRow;
@synthesize notesHistoryArray;
@synthesize notesTableView;


/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {

	self.title = @"Notes History";
	
	localWeeklyPlannerArrayRow = [NSNumber numberWithInt:0];
	[self tableView].delegate = self;
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setBackgroundColor:[UIColor blackColor]];
    self.view = view;
    [view release];
	
		 
	// Table View for Message History
	notesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
	[notesTableView setBackgroundColor:[UIColor whiteColor]];
	notesTableView.delegate = self;
	notesTableView.dataSource = self;
	notesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	notesTableView.rowHeight = 66;
	[self.view addSubview:notesTableView];
	[notesTableView release];
	
	
	// load temporary notesHistoryArray which will be edited when the view controller is configured with the period & weekday
		// array format: ID, period, weekdayName, date, note
		
		self.notesHistoryArray = [[NSMutableArray arrayWithObjects:
						  [[NSMutableArray arrayWithObjects:
							@"",
							@"",
							@"",
							@"9 Feb 08",
							@"Some Notes",
							nil] retain],
						  nil] retain];
	
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notesHistoryArray count];
}



 // will need to implement this when we have variable height table cells (ie expanding message bubbles)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 CGFloat		result = 70;
 NSString*	text = nil;
 CGFloat		width = 225;
 text = [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:4];
 
 if (text)
 {
 // The notes can be of any height
 // This needs to work for both portrait and landscape orientations.
 // Calls to the table view to get the current cell and the rect for the 
 // current row are recursive and call back this method.
 CGSize		textSize = { width, 20000.0f };		// width and height of text area
 CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
 
 size.height += 27.0f;			// top and bottom margin
	
 result = MAX(size.height, 70);	// at least one row
 }
 
 return result;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    	
	DailyPlannerLessonInstanceNotesHistoryCell *cell = (DailyPlannerLessonInstanceNotesHistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"DailyPlannerLessonInstanceNotesHistoryCell"];
		if (cell == nil) {
			cell = [[[DailyPlannerLessonInstanceNotesHistoryCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DailyPlannerLessonInstanceNotesHistoryCell"] autorelease];
		}
		// Configure the cell
		
		cell.noteContent.text = [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:4];	
	cell.noteDate.text =  [[notesHistoryArray objectAtIndex:indexPath.row] objectAtIndex:3];
	
	
	[cell setLeftAlignment];
	
		return cell;
	
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
}
*/

/*
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 }
 if (editingStyle == UITableViewCellEditingStyleInsert) {
 }
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 }
 */
/*
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 }
 */

- (void)viewDidAppear {
	
}

- (void)configureHistoryArray {	
	// setup the history array
	// first clear out the dummy data placed in the init function
	// then build the array using the appDelegate weeklyPlannerNotesArray
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	while ([notesHistoryArray count] > 0) {
		[notesHistoryArray removeLastObject];
	}
	
	int i = 0;
	
	while ([[appDelegate weeklyPlannerNotesArray] count] > i) {
		
		if ([[[[appDelegate weeklyPlannerArray] objectAtIndex:[localWeeklyPlannerArrayRow integerValue]] objectAtIndex:1] isEqualToString:[[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:2]] &&
			[[[[appDelegate weeklyPlannerArray] objectAtIndex:[localWeeklyPlannerArrayRow integerValue]] objectAtIndex:0] isEqualToString:[[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:1]]) {
			
			[notesHistoryArray addObject:[[NSMutableArray arrayWithObjects:
										   [[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:0],
										   [[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:1],
										   [[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:2],
										   [[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:3],
										   [[[appDelegate weeklyPlannerNotesArray] objectAtIndex:i] objectAtIndex:4],
										   nil] retain]];
		}
		
		i +=1;
	}
	
			[notesTableView reloadData];
	[pool release];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[localWeeklyPlannerArrayRow release];
	[notesHistoryArray release];
	[notesTableView release];
    [super dealloc];
}


@end
