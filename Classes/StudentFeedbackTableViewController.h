//
//  StudentFeedbackTableViewController.h
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"
#import "GData.h"
#import "GDataFeedDocList.h"


@interface StudentFeedbackTableViewController :  UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {

	NSMutableArray *studentTrackerArray;
    sqlite3 *educateDatabase;
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	UIButton *settingsButton;
	UIButton *syncButton;
	UIScrollView *trackerScrollView;
	UITableView *trackerTableView;
	
	GDataServiceTicket *mUploadTicket;
	GDataFeedDocList *mDocListFeed;
	GDataServiceGoogleDocs *service;
	
	int pendingUploads;
	BOOL uploadHasStartedAcceptingData;
	BOOL shouldDisplayErrorMessageAndAbort;
	BOOL hasCalledExportASecondTime;
	BOOL hasDisplayedAnErrorMessage;
	BOOL errorWasDueToAuthentication;
}

- (void)showSettingsViewController;
- (void)initialiseStudentTrackerArray;
- (void)saveStudentTrackerArrayToDatabase;
- (void)exportTrackerDatabaseToGoogleDocs;
- (void)exportTrackerDatabaseToGoogleDocsInThread;
- (void)performGoogleUploadOnMainThreadWithUploadArray:(NSArray *)uploadString;
- (void)exportIndividualTrackerToGoogleDocs:(int)forTrackerID withTrackerName:(NSString *)trackerName;
- (void)chooseSyncOption;
- (void)startProgressTimeoutTimer;

- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;


- (void)inputStream:(GDataProgressMonitorInputStream *)stream 
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
   ofTotalByteCount:(unsigned long long)dataLength;

- (void)uploadFileTicket:(GDataServiceTicket *)ticket
	   finishedWithEntry:(GDataEntryDocBase *)entry
                   error:(NSError *)error;
- (GDataFeedDocList *)docListFeed; 
- (void)docListFetchTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedDocList *)feed
                     error:(NSError *)error;
- (void)setDocListFeed:(GDataFeedDocList *)feed ;

@property (nonatomic, retain) NSMutableArray *studentTrackerArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *syncButton;
@property (nonatomic, retain) UIScrollView *trackerScrollView;
@property (nonatomic, retain) UITableView *trackerTableView;


@end
