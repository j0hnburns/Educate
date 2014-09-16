//
//  GoogleDocsListViewController.m
//  Educate
//
//  Created by James Hodge on 10/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "GoogleDocsListViewController.h"
#import "GDataDocs.h"
#import "GDataFeedDocList.h"
#import "GDataServiceGoogleDocs.h"
#import "GDataQueryDocs.h"
#import "GDataEntryDocBase.h"
#import "GDataEntrySpreadsheetDoc.h"
#import "GDataEntryPresentationDoc.h"
#import "GDataEntryStandardDoc.h"
#import "GDataServiceGoogleSpreadsheet.h"

#import "EducateAppDelegate.h"
#import "ELearningBookmarksWebViewController.h"

@implementation GoogleDocsListViewController

@synthesize newTrackerName;
@synthesize newTrackerType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
   if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	   hasRetrievedListOfTrackers = NO;
		
		viewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];	
		viewBackground.frame = CGRectMake(0,0,320,480);
		[self.view addSubview:viewBackground];
		[viewBackground release];
		
		
		customNavHeader = [[CustomNavigationHeaderThin alloc] initWithFrame:CGRectMake(0,0,320,44)];
		customNavHeader.viewHeader.text = @"Select Tracker";
		[self.view addSubview:customNavHeader];
		
		backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		backButton.frame = CGRectMake(0, 0, 53, 43);
		[backButton setTitle:@"" forState:UIControlStateNormal];
		[backButton setBackgroundColor:[UIColor clearColor]];
		[backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(callPopBackToPreviousView) forControlEvents:UIControlEventTouchUpInside];
		[customNavHeader addSubview:backButton];
		
		importTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,53,320,380) style:UITableViewStylePlain];
		importTableView.delegate = self;
		importTableView.dataSource = self;
		importTableView.scrollEnabled = YES;
		importTableView.rowHeight = 40;
		importTableView.backgroundColor = [UIColor clearColor];
		importTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;		
		[self.view addSubview:importTableView];
		
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Tracker Import";
	newTrackerName = @"New Tracker"; 
	newTrackerType = @"Custom"; 
	newTrackerID = 0;
	dataArray = [[NSMutableArray alloc] init];
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!hasRetrievedListOfTrackers) {
	
		while ([dataArray count] > 0) {
			[dataArray removeLastObject];
		}
	
		[self loadTableDataFromGoogle];
	}
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
- (void)callPopBackToPreviousView {
	[[self navigationController] popViewControllerAnimated:YES];
}

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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
	NSLog(@"returning %i rows for the table", [dataArray count]);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
	cell.textLabel.textColor = [UIColor whiteColor];
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Starting Import Process");
	
	// delete all rows from the array except the one we are importing
	// this animation is for the user to identify that something is happening with that row
	importWasSuccessful = YES;
	NSMutableArray* rowDeletionArray = [NSMutableArray arrayWithCapacity:0];
	
	int i =0;
	
	while ([dataArray count] > i) {
		
		if (i != indexPath.row) {
			[rowDeletionArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}
		
		i +=1;
	}
	
	NSMutableArray* tempDataArray = [NSMutableArray arrayWithCapacity:0];
	[tempDataArray addObject:[dataArray objectAtIndex:indexPath.row]];
	[dataArray setArray:tempDataArray];
	
	[tableView deleteRowsAtIndexPaths:rowDeletionArray withRowAnimation:YES];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"downloadedFile.csv"];
	
	//newTrackerName = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectAtIndex:0]];
	newTrackerName = [[dataArray objectAtIndex:0] objectAtIndex:0];
	
	[self saveSpreadsheet:[[dataArray objectAtIndex:0] objectAtIndex:1] toPath:path];
	
	
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
		
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


- (void) loadTableDataFromGoogle {
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
	NSLog(@"loadTableDataFromGoogle start");
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	service = [[GDataServiceGoogleDocs alloc] init];
	[service setUserAgent:@"iKonstrukt-Educate-20"];
	[service setUserCredentialsWithUsername:appDelegate.settings_googleEmail
								   password:appDelegate.settings_googlePassword];
	NSURL *feedURL = [NSURL URLWithString:kGDataGoogleDocsDefaultPrivateFullFeed];
	
	GDataServiceTicket *ticket;
	GDataQueryDocs *query = [GDataQueryDocs documentQueryWithFeedURL:feedURL];
	[query setMaxResults:1000];
	[query setShouldShowFolders:YES];
    
	ticket = [service fetchFeedWithQuery:query
								delegate:self
					   didFinishSelector:@selector(docListFetchTicket:finishedWithFeed:error:)];

	

}

- (void)docListFetchTicket:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedDocList *)feed
		 error:(NSError *)error {
	NSLog(@"loadTableDataFromGoogle finish feed");
	if (error == nil) {  
		if ([[feed entries] count] > 0) {
			
			int i = 0;
			
			while ([[feed entries] count] > i) {
			
				GDataEntryDocBase *firstDoc = [[feed entries] objectAtIndex:i];
				GDataTextConstruct *titleTextConstruct = [firstDoc title];
				NSString *title = [titleTextConstruct stringValue];
			
				
				if ([firstDoc isKindOfClass:[GDataEntrySpreadsheetDoc class]]) {
					// this document entry is for a spreadsheet
					//
					// to save a spreadsheet, we need to acquire a spreadsheet service
					// auth token by fetching a spreadsheet feed or entry, and then download
					// the spreadsheet file
					
				
					if ([[titleTextConstruct stringValue] rangeOfString:@"ET_"].location != NSNotFound) {
				
						[dataArray addObject:[[NSMutableArray arrayWithObjects:
									  [titleTextConstruct stringValue],
									  firstDoc,
									   //[[firstDoc content] sourceURI],
									  nil] retain]];
						NSLog(@"doc title: %@", title);
						[importTableView reloadData];
					}
					
				 }
				
				
				 
				//[firstDoc release];
				//[titleTextConstruct release];
				
				i+=1;
			}
			
		} else {
			NSLog(@"the user has no docs");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Trackers Found" message:@"Please ensure that your Google Docs spreadsheet has the 'ET_' prefix (e.g. 'ET_Roll') and the following column headings: Surname, First Name, Email, Phone, Guardian Name, Guardian Email, Guardian Phone." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			
		}
		
		if ([dataArray count] == 0) {
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Trackers Found" message:@"Please ensure that your Google Docs spreadsheet has the 'ET_' prefix (e.g. 'ET_Roll') and the following column headings: Surname, First Name, Email, Phone, Guardian Name, Guardian Email, Guardian Phone." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			
		} else {
			hasRetrievedListOfTrackers = YES;
		}
		
		
	} else {
		NSLog(@"fetch error: %@", error);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Failed" message:@"Your Google Docs account could not be accessed.  Please check your details are correctly entered in ‘Settings’ and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
		
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
	[importTableView reloadData];
}

- (void)saveSelectedDocument:(GDataEntryDocBase *)docEntry toPath:(NSString *)savePath {
	
	// downloading docs, per
	// http://code.google.com/apis/documents/docs/2.0/developers_guide_protocol.html#DownloadingDocs
	
	
	NSString *docID = [docEntry resourceID];
	if ([docID length] > 0) {
		
		// make the download URL for this document, exporting it as plain text
		NSString *encodedDocID = [GDataUtilities stringByURLEncodingForURI:docID];
		
		NSString *template = @"http://docs.google.com/feeds/download/documents/Export?docID=%@&exportFormat=txt";
		
		NSString *urlStr = [NSString stringWithFormat:template, encodedDocID];
		NSURL *downloadURL = [NSURL URLWithString:urlStr];
		NSLog(@"Downloading from: %@", urlStr);
		
		// read the document's contents asynchronously from the network
		//
		// since the user has already signed in, the service object
		// has the proper authentication token.  We'll use the service object
		// to generate an NSURLRequest with the auth token in the header, and
		// then fetch that asynchronously.
		//
		NSURLRequest *request = [service requestForURL:downloadURL
												  ETag:nil
											httpMethod:nil];
		
		GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
		[fetcher setUserData:savePath];
		[fetcher beginFetchWithDelegate:self
					  didFinishSelector:@selector(fetcher:finishedWithData:)
						didFailSelector:@selector(fetcher:failedWithError:)];
	}
}


- (void)saveSpreadsheet:(GDataEntrySpreadsheetDoc *)docEntry
                 toPath:(NSString *)savePath {
	// to download a spreadsheet document, we need a spreadsheet service object,
	// and we first need to fetch a feed or entry with the service object so that
	// it has a valid auth token
	GDataServiceGoogleSpreadsheet *spreadsheetService;
	spreadsheetService = [[[GDataServiceGoogleSpreadsheet alloc] init] autorelease];
	
	[spreadsheetService setUserAgent:[service userAgent]];
	[spreadsheetService setUserCredentialsWithUsername:[service username]
											  password:[service password]];
	
	// we don't really care about retrieving the worksheets feed, but it's
	// a convenient URL to fetch to force the spreadsheet service object
	// to acquire an auth token
	NSURL *worksheetsURL = [[docEntry worksheetsLink] URL];
	
	GDataServiceTicket *ticket;
	
	ticket = [spreadsheetService fetchFeedWithURL:worksheetsURL
										 delegate:self
								didFinishSelector:@selector(spreadsheetTicket:finishedWithFeed:error:)];
	// we'll hang on to the spreadsheet service object with a ticket property
	// since we need it to create an authorized NSURLRequest
	[ticket setProperty:spreadsheetService forKey:@"service"];
	[ticket setProperty:savePath forKey:@"savePath"];
	[ticket setProperty:[docEntry resourceID] forKey:@"docID"];
	
	
}

- (void)spreadsheetTicket:(GDataServiceTicket *)ticket
         finishedWithFeed:(GDataFeedWorksheet *)feed
                    error:(NSError *)error {
	// we don't care if we fetched a worksheets feed, just that we have
	// an auth token in the service object
	
	GDataServiceGoogleSpreadsheet *localService = [ticket propertyForKey:@"service"];
	if ([[localService authToken] length] == 0) {
		// failed to authenticate; give up
		NSLog(@"Spreadsheet authentication error: %@", error);
		return;
	}
	
	NSString *docID = [ticket propertyForKey:@"docID"];
	NSString *savePath = [ticket propertyForKey:@"savePath"];
	
	NSString *encodedDocID = [GDataUtilities stringByURLEncodingForURI:docID];
	
	// temporary...
	// change "document:abcdef" into "abcdef"
	// this is due to a server bug and should not be necessary
	NSScanner *scanner = [NSScanner scannerWithString:docID];
	NSString *trimmedDocID = docID;
	if ([scanner scanUpToString:@":" intoString:nil]
		&& [scanner scanString:@":" intoString:nil]
		&& [scanner scanUpToString:@"\n" intoString:&trimmedDocID]) {
		encodedDocID =  [GDataUtilities stringByURLEncodingForURI:trimmedDocID];
	}
	
	// we'll use the export format for comma-separate values, csv
	//
	// add a gid parameter to specify a worksheet number
	NSString *template = @"http://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=%@&exportFormat=csv";
	NSString *urlStr = [NSString stringWithFormat:template, encodedDocID];
	
	NSURL *downloadURL = [NSURL URLWithString:urlStr];
	
	// with the spreadsheet service, we can now make an authenticated request
	NSURLRequest *request = [localService requestForURL:downloadURL
											  ETag:nil
										httpMethod:nil];
	
	// we'll reuse the document download fetcher's callbacks
	GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	[fetcher setUserData:savePath];
	[fetcher beginFetchWithDelegate:self
				  didFinishSelector:@selector(fetcher:finishedWithData:)
					didFailSelector:@selector(fetcher:failedWithError:)];
}

- (void)fetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	// save the file to the local path specified by the user
	NSString *savePath = [fetcher userData];
	NSError *error = nil;
	BOOL didWrite = [data writeToFile:savePath
							  options:NSAtomicWrite
								error:&error];
	if (!didWrite) {
		NSLog(@"Error saving file: %@", error);
	} else {
		// successfully saved the document
		NSLog(@"Saved the .csv export!!!");
		
		[self importIntoDatabaseFromString:[NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:NULL]];
		
		
		
		
	}
}

- (void)importIntoDatabaseFromString:(NSString *)dataString {
	
	NSLog(@"Import String: %@",dataString);
	
	// Create Arrays for the import
	
	csvImportArray = [NSMutableArray arrayWithCapacity:0];
	importStudentTrackerStudentListArray = [NSMutableArray arrayWithCapacity:0];
	importStudentTrackerDateRecordArray = [NSMutableArray arrayWithCapacity:0];
	importStudentTrackerInstanceRecordArray = [NSMutableArray arrayWithCapacity:0];
	
	
	
	// add rows into array for each line of CSV file
	
	
	if ([dataString length] > 0) {
		
		@try {
			
				
				// first we parse the csv file and move each line into an array string object
			
				while([dataString length] > 0) {
					//while([dataString rangeOfString:@"\n"].location != NSNotFound) {
					
					//validCameraString = [validCameraString substringFromIndex:[validCameraString rangeOfString:@"value="].location+7];
					//[newServerCameraIDs insertObject:[validCameraString substringToIndex:[validCameraString rangeOfString:@">"].location-1] atIndex:0];
					//validCameraString = [validCameraString substringFromIndex:[validCameraString rangeOfString:@">"].location+1];
					//[newServerCameraNames insertObject:[validCameraString substringToIndex:[validCameraString rangeOfString:@"</option"].location] atIndex:0];
					if ([dataString rangeOfString:@"\n"].location != NSNotFound) {
						
						
						[csvImportArray addObject:[dataString substringToIndex:[dataString rangeOfString:@"\n"].location]];
						NSLog(@"Added Object To Array at position %i: %@", [csvImportArray count], [dataString substringToIndex:[dataString rangeOfString:@"\n"].location]);
					
						dataString = [dataString substringFromIndex:[dataString rangeOfString:@"\n"].location+1];
					}
					else {
							
						[csvImportArray addObject:dataString];
						
						NSLog(@"Added Object To Array at position %i: %@", [csvImportArray count], dataString);
						dataString = @"";
						
					}
					
					
				}
				
			
				// now we have an array with one row for each student plus a header row
				// we need to parse this array to extract the three tables needed to import the tracker into the database
			
				// first we build the student list table by extracting the first 7 columns from the table
				// (surname, firstname, email, phone, guardian name, guardian email, guardian phone)
				// we ignore the first row as this is the header row which we use for the dateRecord table later
			
			int i = 1;
			int j = 0;
			
			while ([csvImportArray count] > i) {
				
				// add a new row into the studentList array for the student we are about to copy across
				// create the first column of the array as the studentNameID = row number = i
				[importStudentTrackerStudentListArray addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:i]]];
				j = 0;
				// now use a while loop to loop through the 7 values we are extracting and add each as a string into the studentlist array
			
				while (j < 7) {
				
				
					if ([[csvImportArray objectAtIndex:i] rangeOfString:@","].location != NSNotFound) { // if a row does not contain all the fields skip the import
						[[importStudentTrackerStudentListArray objectAtIndex:i-1] addObject:[[csvImportArray objectAtIndex:i] substringToIndex:[[csvImportArray objectAtIndex:i] rangeOfString:@","].location]];
						[csvImportArray replaceObjectAtIndex:i withObject:[[csvImportArray objectAtIndex:i] substringFromIndex:[[csvImportArray objectAtIndex:i] rangeOfString:@","].location+1]];
					} else if ([[csvImportArray objectAtIndex:i] length] != 0) { // if this is the last field with a value, import it then clear the field
						[[importStudentTrackerStudentListArray objectAtIndex:i-1] addObject:[csvImportArray objectAtIndex:i]];
						[csvImportArray replaceObjectAtIndex:i withObject:@""];
					} else {
						[[importStudentTrackerStudentListArray objectAtIndex:i-1] addObject:@""]; // add an empty string where we have skipped fields
						
					}
					
					
					 j += 1;
					
				 }
					
				
				 i +=1;
				
			}
		
			// test code - loop through the student list array and output each row to confirm import
			NSLog(@"imported %i rows into the student list array:", [importStudentTrackerStudentListArray count]);
		
			int k = 0;
			
			while ([importStudentTrackerStudentListArray count] > k) {
				
				NSLog(@"ID %i, Surname: %@, Firstname %@, Email %@, Phone %@, Guardian %@, Email %@, Phone %@",[[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:0] intValue],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:1],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:2],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:3],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:4],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:5],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:6],[[importStudentTrackerStudentListArray objectAtIndex:k] objectAtIndex:7]);
				k +=1;
			}
			// end test code

			// now we need to build the dateRecord array to see how many values to import
			
			// first we need to remove the first 7 values from the first (header) row in the import array
			j = 0;

			while (j < 7) {
				
				if ([[csvImportArray objectAtIndex:0] rangeOfString:@","].location != NSNotFound) {
				
					[csvImportArray replaceObjectAtIndex:0 withObject:[[csvImportArray objectAtIndex:0] substringFromIndex:[[csvImportArray objectAtIndex:0] rangeOfString:@","].location+1]];
				} else {
					[csvImportArray replaceObjectAtIndex:0 withObject:@""];
				}
				
				j += 1;
				
			}
			// now the first row in the array only contains the headers for the tracker values
			// we loop through this string until there are no more commas, each time importing the value into the dateRecord array
			
			while ([[csvImportArray objectAtIndex:0] length] != 0) {
			
				if ([[csvImportArray objectAtIndex:0] rangeOfString:@","].location != NSNotFound) {
				
					[importStudentTrackerDateRecordArray addObject:[[csvImportArray objectAtIndex:0] substringToIndex:[[csvImportArray objectAtIndex:0] rangeOfString:@","].location]];
					[csvImportArray replaceObjectAtIndex:0 withObject:[[csvImportArray objectAtIndex:0] substringFromIndex:[[csvImportArray objectAtIndex:0] rangeOfString:@","].location+1]];
				} else {
				
					[importStudentTrackerDateRecordArray addObject:[csvImportArray objectAtIndex:0]];
					[csvImportArray replaceObjectAtIndex:0 withObject:@""];
				
				}
			
			}
			
			// test code - loop through the dateRecord array and output each row to confirm import
			NSLog(@"imported %i rows into the date record array:", [importStudentTrackerDateRecordArray count]);
			
			k = 0;
			
			while ([importStudentTrackerDateRecordArray count] > k) {
				
				NSLog(@"Row Title: %@",[importStudentTrackerDateRecordArray objectAtIndex:k]);
				k +=1;
			}
			// end test code
			
			
			// now we know how many values there are in the dateRecord array, we need to build the instanceValue array
			// each line in the array is a combination of studentID, dateRecord ID (both the array row +1), and the value
			
			i = 1;
			j = 0;
			
			while ([csvImportArray count] > i) {
				
	
				j = 0;
				// now use a while loop to loop through the values we are extracting and add each as a new array of values into the dateRecord array
				
				while ([importStudentTrackerDateRecordArray count] > j) {

					
					if ([[csvImportArray objectAtIndex:i] rangeOfString:@","].location != NSNotFound) {
					
						[importStudentTrackerInstanceRecordArray addObject:[NSMutableArray arrayWithObjects:
																		[NSNumber numberWithInt:i], // studentID
																		[NSNumber numberWithInt:j+1], // studentTrackerDateID
																		[[csvImportArray objectAtIndex:i] substringToIndex:[[csvImportArray objectAtIndex:i] rangeOfString:@","].location], 
																		nil]];
					
						[csvImportArray replaceObjectAtIndex:i withObject:[[csvImportArray objectAtIndex:i] substringFromIndex:[[csvImportArray objectAtIndex:i] rangeOfString:@","].location+1]];
					} else {
						
						[importStudentTrackerInstanceRecordArray addObject:[NSMutableArray arrayWithObjects:
																			[NSNumber numberWithInt:i], // studentID
																			[NSNumber numberWithInt:j+1], // studentTrackerDateID
																			[csvImportArray objectAtIndex:i], 
																			nil]];
						[csvImportArray replaceObjectAtIndex:i withObject:@""];
						
					}
					j += 1;
					
				}
				
				
				i +=1;
				
			}
			
			NSLog(@"imported %i rows into the student list array:", [importStudentTrackerInstanceRecordArray count]);
			
			
			// loop through the instanceRecord array and evaluate the value field to determine which tracker type is being imported
			k = 0;
			
			while ([importStudentTrackerInstanceRecordArray count] > k) {
				
				if (![[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@""]) {
					
					if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"C"]) {
						
						newTrackerType = @"C/NYC";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"NYC"]) {
						
						newTrackerType = @"C/NYC";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"P"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"S"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"L"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"Present"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"Absent"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"Leave"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"Sick"]) {
						
						newTrackerType = @"Attendance";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"A+"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"A-"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"B+"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"B"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"B-"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"C+"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"C-"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"D+"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"D"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"D-"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"E+"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"E"]) {
						
						newTrackerType = @"A+";
					} else if ([[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2] isEqualToString:@"E-"]) {
						
						newTrackerType = @"A+";
					}
					
				}
				
				NSLog(@"studentID %i, studentTrackerDateID %i, Value: %@",[[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:0] intValue],[[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:1] intValue],[[importStudentTrackerInstanceRecordArray objectAtIndex:k] objectAtIndex:2]);
				k +=1;
			}
			
			NSLog(@"Parsed New Tracker Type: %@", newTrackerType);
			
			// end test code
			
			// now we have our arrays populated correctly, we need to perform the database inserts
			// only do these inserts if we have rows in the studentName array (as an empty tracker will export to Google but the subsequent import will not return any studentNames
			//if ([importStudentTrackerStudentListArray count] > 0) {
			
			// replacement code - we now run the import regardless of the number of student names to allow a template to be imported
			if (TRUE) {
			
				// retrieve list of trackers to determine next tracker ID to use

				NSLog(@"Opening Database");
				// The database is stored in the application bundle. 
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
				
				// Now open a connection and do an insert into the database for each row in the array
				// Open the database. The database was prepared outside the application.
				if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
					// Get the primary key for all books.
					const char *sql = "SELECT max(trackerID) as trackerMaxID FROM studentTracker";
					sqlite3_stmt *statement;
					// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
					// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
					if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
						
						
						int success = 0;
						
						
						// Execute the query.
						success =sqlite3_step(statement);
						
						int rowTrackerID = sqlite3_column_int(statement, 0);
						
						newTrackerID = rowTrackerID + 1;
						
						// Reset the query for the next use.
						sqlite3_reset(statement);
						
						
					}
					// "Finalize" the statement - releases the resources associated with the statement.
					sqlite3_finalize(statement);
					sqlite3_close(educateDatabase);
				} else {
					// Even though the open failed, call close to properly clean up resources.
					sqlite3_close(educateDatabase);
					NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
					// Additional error handling, as appropriate...
				}
				
				NSLog(@"Got New Tracker ID %i", newTrackerID);
				
				// now insert the tracker details into the tracker database
				// we aren't actually exporting the tracker type to Google Docs
				// for the moment just import as C/NYC
				// we might parse the tracker name in Google to determine the correct format
		

				if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
					// Get the primary key for all books.
					const char *sql = "INSERT INTO studentTracker (trackerID, trackerName, trackerScale) VALUES (?, ?, ?)";
					sqlite3_stmt *statement;
					// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
					// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
					if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
						
						
						int success = 0;
						
						NSMutableString* trimmedNewTrackerName = [NSMutableString stringWithString:[newTrackerName substringFromIndex:3]];
						if ([trimmedNewTrackerName rangeOfString:@".csv"].location != NSNotFound) {
							[trimmedNewTrackerName replaceOccurrencesOfString:@".csv" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[trimmedNewTrackerName length])];
						}
						
						
						// Bind the trackerID variable.
						sqlite3_bind_int(statement, 1, newTrackerID);
						sqlite3_bind_text(statement, 2, [trimmedNewTrackerName UTF8String], -1, SQLITE_TRANSIENT);
						sqlite3_bind_text(statement, 3, [newTrackerType UTF8String], -1, SQLITE_TRANSIENT);
						
						// Execute the query.
						success =sqlite3_step(statement);
						
						// Reset the query for the next use.
						sqlite3_reset(statement);
						
						
					}
					// "Finalize" the statement - releases the resources associated with the statement.
					sqlite3_finalize(statement);
					sqlite3_close(educateDatabase);
				} else {
					// Even though the open failed, call close to properly clean up resources.
					sqlite3_close(educateDatabase);
					NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
					// Additional error handling, as appropriate...
				}
				
				NSLog(@"Added Tracker To Database");
				
				// now insert the rows for the student name

				if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
					// Get the primary key for all books.
					const char *sql = "INSERT INTO studentTrackerStudentList (studentTrackerID, studentNameID, studentName, studentFirstName, studentEmail, phone1, parentName, guardianEmail, phone2) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
					sqlite3_stmt *statement;
					// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
					// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
					if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
						
						
						int success = 0;
						int i = 0;
						
						while ([importStudentTrackerStudentListArray count] > i) {
						
							// Bind the trackerID variable.
							sqlite3_bind_int(statement, 1, newTrackerID);
							sqlite3_bind_int(statement, 2, i+1);
							sqlite3_bind_text(statement, 3, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:1] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 4, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 5, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:3] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 6, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:4] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 7, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:5] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 8, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:6] UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 9, [[[importStudentTrackerStudentListArray objectAtIndex:i] objectAtIndex:7] UTF8String], -1, SQLITE_TRANSIENT);
						
							// Execute the query.
							success =sqlite3_step(statement);
						
							 // Reset the query for the next use.
							sqlite3_reset(statement);
														 
							NSLog(@"Added Student ID %i", i);					 
							i +=1;
							
							}
						
						
					}
					// "Finalize" the statement - releases the resources associated with the statement.
					sqlite3_finalize(statement);
					sqlite3_close(educateDatabase);
				} else {
					// Even though the open failed, call close to properly clean up resources.
					sqlite3_close(educateDatabase);
					NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
					// Additional error handling, as appropriate...
				}
				
				
				
				// now insert the rows for the dateRecords
				

				if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
					// Get the primary key for all books.
					const char *sql = "INSERT INTO studentTrackerDateRecord (studentTrackerID, studentTrackerDateID, creationDate, dateLabel) VALUES (?, ?, ?, ?)";
					sqlite3_stmt *statement;
					// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
					// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
					if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
						
						
						int success = 0;
						int i = 0;
						
						while ([importStudentTrackerDateRecordArray count] > i) {
							
							// Bind the trackerID variable.
							sqlite3_bind_int(statement, 1, newTrackerID);
							sqlite3_bind_int(statement, 2, i+1);
							sqlite3_bind_text(statement, 3, [@"" UTF8String], -1, SQLITE_TRANSIENT);
							sqlite3_bind_text(statement, 4, [[importStudentTrackerDateRecordArray objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);							
							// Execute the query.
							success =sqlite3_step(statement);
							
							// Reset the query for the next use.
							sqlite3_reset(statement);
								NSLog(@"Added Date ID %i", i);
							
							i +=1;
							
						}
						
						
					}
					// "Finalize" the statement - releases the resources associated with the statement.
					sqlite3_finalize(statement);
					sqlite3_close(educateDatabase);
				} else {
					// Even though the open failed, call close to properly clean up resources.
					sqlite3_close(educateDatabase);
					NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
					// Additional error handling, as appropriate...
				}				
				
				// finally insert the rows for the instanceValues
		
				
				if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
					// Get the primary key for all books.
					const char *sql = "INSERT INTO studentTrackerInstanceRecord (studentTrackerID, studentID, studentTrackerDateID, recordValue) VALUES (?, ?, ?, ?)";
					sqlite3_stmt *statement;
					// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
					// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
					if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
						
						
						int success = 0;
						int i = 0;
						
						while ([importStudentTrackerInstanceRecordArray count] > i) {
							
							// Bind the trackerID variable.
							sqlite3_bind_int(statement, 1, newTrackerID);
							sqlite3_bind_int(statement, 2, [[[importStudentTrackerInstanceRecordArray objectAtIndex:i] objectAtIndex:0] intValue]);
							sqlite3_bind_int(statement, 3, [[[importStudentTrackerInstanceRecordArray objectAtIndex:i] objectAtIndex:1] intValue]);
							sqlite3_bind_text(statement, 4, [[[importStudentTrackerInstanceRecordArray objectAtIndex:i] objectAtIndex:2] UTF8String], -1, SQLITE_TRANSIENT);							
							// Execute the query.
							success =sqlite3_step(statement);
							
							// Reset the query for the next use.
							sqlite3_reset(statement);
								NSLog(@"Added Record ID %i", i);
							
							i +=1;
							
						}
						
						
					}
					// "Finalize" the statement - releases the resources associated with the statement.
					sqlite3_finalize(statement);
					sqlite3_close(educateDatabase);
				} else {
					// Even though the open failed, call close to properly clean up resources.
					sqlite3_close(educateDatabase);
					NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
					// Additional error handling, as appropriate...
				}
				
				
				
				// finish import
				
				
				
				
				
			}
			
		}
		
		@catch(NSException *e) {
			NSLog([NSString stringWithFormat:@"importIntoDatabaseFromString Exception Occurred - %@",e]);
			importWasSuccessful = NO;
		}
	
	} else {
		
		NSLog(@"Data Import String Zero Length!!");
	}
	
	
	// test code - output the array contents:
	
	int i = 0;
	
	while ([csvImportArray count] > i) {
	
		//NSString 
		NSLog(@"newDataArray item at row %i: %@", i, [csvImportArray objectAtIndex:i]);
		i +=1;
		
	}
	if (importWasSuccessful) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Successful" message:@"Educate has successfully imported the selected Tracker from Google Docs." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Import Failed" message:@"Your Google Docs account could not be accessed.  Please check your details are correctly entered in ‘Settings’ and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];

	}
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
	[self callPopBackToPreviousView];	
}

- (void)fetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"Fetcher error: %@", error);
}


- (void)dealloc {
    [super dealloc];
}


@end

