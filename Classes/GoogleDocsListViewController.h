//
//  GoogleDocsListViewController.h
//  Educate
//
//  Created by James Hodge on 10/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "GDataDocs.h"
#import "GDataFeedDocList.h"
#import "GDataServiceGoogleDocs.h"
#import "GDataQueryDocs.h"
#import "GDataEntryDocBase.h"
#import "GDataEntrySpreadsheetDoc.h"
#import "GDataEntryPresentationDoc.h"
#import "GDataEntryStandardDoc.h"
#import "GDataFeedWorksheet.h"
#import "CustomNavigationHeaderThin.h"

@interface GoogleDocsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *dataArray;
	GDataServiceGoogleDocs *service;
	NSMutableArray *csvImportArray;	
	NSMutableArray *importStudentTrackerStudentListArray;
	NSMutableArray *importStudentTrackerDateRecordArray;
	NSMutableArray *importStudentTrackerInstanceRecordArray;
    sqlite3 *educateDatabase;
	NSString *newTrackerName;
	NSString *newTrackerType;
	int newTrackerID;
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	UIButton *backButton;
	UITableView *importTableView;
	BOOL importWasSuccessful;
	BOOL hasRetrievedListOfTrackers;

}

- (void)callPopBackToPreviousView;
- (void) loadTableDataFromGoogle;
- (void)docListFetchTicket:(GDataServiceTicket *)ticket
finishedWithFeed:(GDataFeedDocList *)feed
		 error:(NSError *)error;

- (void)saveSpreadsheet:(GDataEntrySpreadsheetDoc *)docEntry toPath:(NSString *)savePath;
- (void)saveSelectedDocument:(GDataEntryDocBase *)docEntry toPath:(NSString *)savePath;

- (void)spreadsheetTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedWorksheet *)feed error:(NSError *)error;
- (void)fetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data;
- (void)fetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error;
- (void)importIntoDatabaseFromString:(NSString *)dataString;

@property (nonatomic, retain) NSString *newTrackerName;
@property (nonatomic, retain) NSString *newTrackerType;

@end
