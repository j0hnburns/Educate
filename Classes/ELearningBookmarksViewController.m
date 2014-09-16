//
//  ELearningBookmarksViewController.m
//  Educate
//
//  Created by James Hodge on 29/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "ELearningBookmarksViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"
#import "ELearningBookmarksWebViewController.h"
#import "ELearningBookmarksNewBookmarkViewController.h"

@implementation ELearningBookmarksViewController


@synthesize bookmarksTableView;
@synthesize localBookmarksArray;
@synthesize editButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
   
		hasLoadedFavicons = NO;
		
		//EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		[[self navigationController] setNavigationBarHidden:YES animated:NO];
		
		UIImageView* viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		
		CustomNavigationHeaderThin* customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
		customNavHeader.viewHeader.text = @"Bookmarks";
		customNavHeader.viewHeader.font = [UIFont boldSystemFontOfSize:20];
		[self.view addSubview:customNavHeader];
		
		
		UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		bookmarksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,320,360) style:UITableViewStylePlain];
		bookmarksTableView.delegate = self;
		bookmarksTableView.dataSource = self;
		bookmarksTableView.scrollEnabled = YES;
		bookmarksTableView.rowHeight = 45;
		bookmarksTableView.backgroundColor = [UIColor clearColor];
		bookmarksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:bookmarksTableView];
		
		editButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		editButton.frame = CGRectMake(250, 5, 70, 30);
		[editButton setTitle:@"Edit" forState:UIControlStateNormal];
		[editButton setBackgroundColor:[UIColor clearColor]];
		[editButton setBackgroundImage:[UIImage imageNamed:@"blue_button_sm.png"] forState:UIControlStateNormal];
		[editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		editButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[editButton addTarget:self action:@selector(toggleTableEditingMode) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:editButton];

	}
return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
		
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	[self initialiseLocalBookmarksArray];
	
	[bookmarksTableView reloadData];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	if (appDelegate.internetConnectionStatus == NotReachable) {
		
		// if first offline failure then notify user with alert box
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Unavailable" message:@"Educate requires an internet connection in order to display Bookmarked web pages.  You will not be able to view the web pages until an internet connection becomes available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		
	}
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (localBookmarksArray != nil)
	{
		// local bookmark array exists, so we might be returning from the edit bookmark view
		// for that reason, we should save the localBookmarksArray to the userDefaults

		[[NSUserDefaults standardUserDefaults] setObject:localBookmarksArray forKey:@"savedBookmarksArray"];
		
		[bookmarksTableView reloadData];
		
		localBookmarksArray = [localBookmarksArray mutableCopy];
		int i = 0;
		while ([localBookmarksArray count] > i) {
			[localBookmarksArray replaceObjectAtIndex:i withObject:[[localBookmarksArray objectAtIndex:i] mutableCopy]];
			i +=1;
		}
	}
	
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if (section == 0) {
		return [localBookmarksArray count]; // bookmarks list
	} else {
		return 1; // new bookmark option
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 0) { // bookmarks list
	
		// Set up the cell...
		cell.textLabel.text = [[localBookmarksArray objectAtIndex:indexPath.row] objectAtIndex:0];
	
		UIImageView* cellBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,300,45)];
		cellBackgroundImage.image = [UIImage imageNamed:@"bookmarkBackground.png"];
		
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *cachedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_favicon.ico",[[localBookmarksArray objectAtIndex:indexPath.row] objectAtIndex:0]]];
		cell.imageView.image = [UIImage imageNamed:@"favicon.png"];
		if (![fileManager fileExistsAtPath:cachedImagePath]) {
			// spawn a new thread to cache this favicon
			[NSThread detachNewThreadSelector:@selector(retrieveFaviconInThread:) toTarget:self withObject:[NSNumber numberWithInt:indexPath.row]];
			NSLog(@"Downloading Favicon for %@", cachedImagePath);
		} else {
			// image does exist, so use it instead
			cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:cachedImagePath]];
			NSLog(@"Using Cached Favicon for %@", cachedImagePath);
		}
		
		
		cell.backgroundView = cellBackgroundImage;
		[cellBackgroundImage release];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
	} else { // new bookmark option
		
		cell.textLabel.text = @"New Bookmark";
		
		UIImageView* cellBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,300,45)];
		cellBackgroundImage.image = [UIImage imageNamed:@"bookmarkBackground.png"];
		cell.imageView.image = nil;
		cell.backgroundView = cellBackgroundImage;
		[cellBackgroundImage release];
		
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	if (indexPath.section == 0) {
	
		if (!bookmarksTableView.isEditing) { // we are just viewing the list, so display the bookmark webview controller
			
			ELearningBookmarksWebViewController *eLearningBookmarksWebViewController = [[ELearningBookmarksWebViewController alloc] initWithNibName:nil bundle:nil];    
			eLearningBookmarksWebViewController.titleString = [[localBookmarksArray objectAtIndex:indexPath.row] objectAtIndex:0];
			eLearningBookmarksWebViewController.URLString = [[localBookmarksArray objectAtIndex:indexPath.row] objectAtIndex:1];
			[[self navigationController] pushViewController:eLearningBookmarksWebViewController animated:YES];
			[eLearningBookmarksWebViewController loadURLForString:[[localBookmarksArray objectAtIndex:indexPath.row] objectAtIndex:1]];
			[eLearningBookmarksWebViewController release];
			
		}
		
	
		
	} else {
		// new bookmark option
		
		[localBookmarksArray addObject:[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"New Bookmark"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://"], // 1 full URL
								  nil] retain]];
		// save bookmark array to defaults
		[[NSUserDefaults standardUserDefaults] setObject:localBookmarksArray forKey:@"savedBookmarksArray"];
		[bookmarksTableView reloadData];
		
		ELearningBookmarksNewBookmarkViewController *eLearningBookmarksNewBookmarkViewController = [[ELearningBookmarksNewBookmarkViewController alloc] initWithNibName:nil bundle:nil];    
		eLearningBookmarksNewBookmarkViewController.localBookmarkValueArray = [localBookmarksArray objectAtIndex:[localBookmarksArray count]-1];
		eLearningBookmarksNewBookmarkViewController.parentELearningBookmarksViewController = self;
		[eLearningBookmarksNewBookmarkViewController setBookmarkArrayRowNumber:[localBookmarksArray count]-1];
		[[self navigationController] pushViewController:eLearningBookmarksNewBookmarkViewController animated:YES];
		[eLearningBookmarksNewBookmarkViewController release];
	}
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	
	if (indexPath.section == 0) {
		
		
		ELearningBookmarksNewBookmarkViewController *eLearningBookmarksNewBookmarkViewController = [[ELearningBookmarksNewBookmarkViewController alloc] initWithNibName:nil bundle:nil];    
		eLearningBookmarksNewBookmarkViewController.localBookmarkValueArray = [localBookmarksArray objectAtIndex:indexPath.row];
		eLearningBookmarksNewBookmarkViewController.parentELearningBookmarksViewController = self;
		[eLearningBookmarksNewBookmarkViewController setBookmarkArrayRowNumber:indexPath.row];
		[[self navigationController] pushViewController:eLearningBookmarksNewBookmarkViewController animated:YES];
		[eLearningBookmarksNewBookmarkViewController release];
			
			
	} 	
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (indexPath.section == 0) {
		return YES;
	} else {
		return NO;
	}
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
		
		// Delete the row from the data source
		[localBookmarksArray removeObjectAtIndex:indexPath.row];
		// Now animate the deletion from the tableView
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		// save bookmark array to defaults
		[[NSUserDefaults standardUserDefaults] setObject:localBookmarksArray forKey:@"savedBookmarksArray"];	
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	
	// swap the items in the bookmark array to represent new order
	
	[localBookmarksArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
	// save bookmark array to defaults
	[[NSUserDefaults standardUserDefaults] setObject:localBookmarksArray forKey:@"savedBookmarksArray"];	
	
	
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.section == 0) {
		return YES;
	} else {
		return NO;
	}
}


// Open the database connection and retrieve array contents
- (void)initialiseLocalBookmarksArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	localBookmarksArray = [[NSMutableArray alloc] initWithCapacity:0];
	//NSMutableArray *tempMutableArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBookmarksArray"] mutableCopy];
	localBookmarksArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBookmarksArray"] mutableCopy];
	//localBookmarksArray = tempMutableArray;
	//[tempMutableArray release];
	if (localBookmarksArray == nil)
	{
		// user has not launched this app before so set default cam and populate arrays
		localBookmarksArray = [[NSMutableArray arrayWithObjects:
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"Wikipedia"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://mobile.wikipedia.org"], // 1 full URL
								  nil] retain],
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"YouTube"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://youtube.com"], // 1 full URL
								  nil] retain],
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"Delicious"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://m.delicious.com"], // 1 full URL
								  nil] retain],
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"Twitter"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://twitter.com"], // 1 full URL
								  nil] retain],
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"Educate Video Help"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://www.youtube.com/ikonstrukt"], // 1 full URL
								  nil] retain],
								[[NSMutableArray arrayWithObjects:
								  [NSString stringWithString:@"Educate Community"], // 0 Bookmark Name
								  [NSString stringWithString:@"http://www.facebook.com/EducateApp"], // 1 full URL
								  nil] retain],
						 nil] retain];
		// save bookmark array to defaults
		[[NSUserDefaults standardUserDefaults] setObject:localBookmarksArray forKey:@"savedBookmarksArray"];
		
	} 
	
	// now loop through the array and retrieve the favicons
	/*
	int i = 0;
		
		while ([localBookmarksArray count] > i) {
			
			
			[NSThread detachNewThreadSelector:@selector(retrieveFaviconInThread:) toTarget:self withObject:[NSNumber numberWithInt:i]];
			
			i +=1;
		}
	hasLoadedFavicons = YES;
	*/
	
	[pool release];
}

- (void)toggleTableEditingMode {

	if (bookmarksTableView.isEditing) {
		[bookmarksTableView setEditing:NO animated:YES];
		[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	} else {
		[bookmarksTableView setEditing:YES animated:YES];
		[editButton setTitle:@"Done" forState:UIControlStateNormal];
	}
	
}

- (void)retrieveFaviconInThread:(NSNumber *)forRow {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSLog(@"Retrieving favicon for URL %@", [[localBookmarksArray objectAtIndex:[forRow intValue]] objectAtIndex:1]);
	if (appDelegate.internetConnectionStatus != NotReachable) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		@try {
			
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *cachedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_favicon.ico",[[localBookmarksArray objectAtIndex:[forRow intValue]] objectAtIndex:0]]];
			if (![fileManager fileExistsAtPath:cachedImagePath]) {
				// spawn a new thread to cache this favicon
				NSURL* faviconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/favicon.ico",[[localBookmarksArray objectAtIndex:[forRow intValue]] objectAtIndex:1]]];		
				
				if (faviconURL != nil) {
					
					NSData* tempFaviconData = [NSData dataWithContentsOfURL:faviconURL];
					if (tempFaviconData != nil && [UIImage imageWithData:tempFaviconData] != nil) {
						NSLog(@"RETURNED OK favicon for URL %@", [[localBookmarksArray objectAtIndex:[forRow intValue]] objectAtIndex:1]);
						//  save a copy in the local documents folder
						[fileManager createFileAtPath:cachedImagePath contents:tempFaviconData attributes:nil];
						// display the favicon in the table
						[bookmarksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[forRow intValue] inSection:0]].imageView.image = [UIImage imageWithData:tempFaviconData];
					} 
				} 
			} else {
				// image does exist, so use it instead
				[bookmarksTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[forRow intValue] inSection:0]].imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:cachedImagePath]];
			}
			
			
			
			
		}
		
		@finally {
			
			
		}
		[pool release];
	}
	
	
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)dealloc {
	[localBookmarksArray release];
	[bookmarksTableView release];
	[editButton release];
    [super dealloc];
}


@end

