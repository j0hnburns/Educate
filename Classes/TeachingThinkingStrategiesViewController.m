//
//  TeachingThinkingStrategiesViewController.m
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TeachingThinkingStrategiesViewController.h"
#import "EducateAppDelegate.h"
#import "CustomNavigationHeaderThin.h"
#import "TeachingStrategyDescriptionController.h"



@implementation TeachingThinkingStrategiesViewController

@synthesize strategiesTableView;
@synthesize localStrategiesArray;
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
	
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	
	viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scrollBackground.png"]];	
	viewBackground.frame = CGRectMake(0,0,320,480);
	[self.view addSubview:viewBackground];
	[viewBackground release];
	
	
	customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
	customNavHeader.viewHeader.text = @"Thinking Strategies";
	[self.view addSubview:customNavHeader];
	
	
	strategiesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,495,360) style:UITableViewStylePlain];
	strategiesTableView.delegate = self;
	strategiesTableView.dataSource = self;
	strategiesTableView.scrollEnabled = YES;
	strategiesTableView.rowHeight = 40;
	strategiesTableView.backgroundColor = [UIColor clearColor];
	strategiesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[self.view addSubview:strategiesTableView];

	UIButton* backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	backButton.frame = CGRectMake(0, 0, 53, 43);
	[backButton setTitle:@"" forState:UIControlStateNormal];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
	[customNavHeader addSubview:backButton];
	
	
	
    [super viewDidLoad];
	
	[self initialiseLocalStrategiesArray];
	
	[strategiesTableView reloadData];
	
}


- (void)viewWillAppear:(BOOL)animated {
	[self initialiseLocalStrategiesArray];
	[strategiesTableView reloadData];
    [super viewWillAppear:animated];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		return [localStrategiesArray count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[localStrategiesArray objectAtIndex:indexPath.row] objectAtIndex:2];
	
    return cell;
		
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	TeachingStrategyDescriptionController *teachingStrategyDescriptionController = [[TeachingStrategyDescriptionController alloc] initWithNibName: nil bundle:nil];
	//teachingStrategyDescriptionController.descriptionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"desc_%@",[[localStrategiesArray objectAtIndex:indexPath.row] objectAtIndex:4]]];
	teachingStrategyDescriptionController.customNavHeader.upperSubHeading.text = [[localStrategiesArray objectAtIndex:indexPath.row] objectAtIndex:2];
	teachingStrategyDescriptionController.customNavHeader.lowerSubHeading.text = [[localStrategiesArray objectAtIndex:indexPath.row] objectAtIndex:3];
	teachingStrategyDescriptionController.customNavHeader.lowerSubHeading.hidden = YES;
	teachingStrategyDescriptionController.exampleImageName = [[localStrategiesArray objectAtIndex:indexPath.row] objectAtIndex:4];
	[teachingStrategyDescriptionController addDescriptionImageToScrollView];
	[[self navigationController] pushViewController:teachingStrategyDescriptionController animated:YES];
	//[teachingStrategyDescriptionController release];
	
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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Open the database connection and retrieve array contents
- (void)initialiseLocalStrategiesArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (localStrategiesArray == nil) {
		localStrategiesArray = [[NSMutableArray alloc] init];
	} else {
		while ([localStrategiesArray count] > 0) {
			[localStrategiesArray removeLastObject];
		}
	}
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT strategyID, strategyType, strategyName, exampleText, imageName, description FROM teachingStrategies WHERE strategyType = 1 ORDER BY strategyName";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			// Execute the query.
			//int success =sqlite3_step(statement);
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				int strategyID = sqlite3_column_int(statement, 0);
				int strategyType = sqlite3_column_int(statement, 1);
				char *strategyName = (char *)sqlite3_column_text(statement, 2);
				char *exampleText = (char *)sqlite3_column_text(statement, 3);
				char *imageName = (char *)sqlite3_column_text(statement, 4);
				char *description = (char *)sqlite3_column_text(statement, 5);
				[localStrategiesArray addObject:[[NSMutableArray arrayWithObjects:
												  [NSNumber numberWithInt:strategyID],
												  [NSNumber numberWithInt:strategyType],
												  (strategyName) ? [NSString stringWithUTF8String:strategyName] : @"",
												  (exampleText) ? [NSString stringWithUTF8String:exampleText] : @"",
												  (imageName) ? [NSString stringWithUTF8String:imageName] : @"",
												  (description) ? [NSString stringWithUTF8String:description] : @"",
														nil] retain]];
				
				
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
	
	
	// check to see whether the collaborative strategy list is up to date
	// if not, add the additional strategies into the database
	// current version 1.0.1 - new strategies Jigsaw and Fishbowl
	
	if ([localStrategiesArray count] == 8) {
		
		
		// Open the database. The database was prepared outside the application.
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "insert into teachingStrategies (strategyID, strategyType, strategyName, imageName) values (23, 1, 'Directed Reading', 'ts_directedReading.png')";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// Execute the query.
				int success =sqlite3_step(statement);
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
		
		// Open the database. The database was prepared outside the application.
		if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
			// Get the primary key for all books.
			const char *sql = "insert into teachingStrategies (strategyID, strategyType, strategyName, imageName, exampleText) values (24, 1, 'Y-Chart', 'ts_ychart.png', 'Example (Pollution)')";
			sqlite3_stmt *statement;
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
			if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
				
				// Execute the query.
				int success =sqlite3_step(statement);
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
		
		// now refresh the database by re-calling the init function
		
		[self initialiseLocalStrategiesArray];
		
	}
	
	
	[pool release];
}

- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[strategiesTableView release];
	[localStrategiesArray release];
	[customNavHeader release];
	[viewBackground release];
	[settingsButton release];
    [super dealloc];
}


@end
