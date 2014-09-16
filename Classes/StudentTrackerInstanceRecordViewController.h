//
//  StudentTrackerInstanceRecordViewController.h
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"


@interface StudentTrackerInstanceRecordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {

	
	NSMutableArray *localStudentNameArray;
	NSMutableArray *localDateRecordArray;
	NSNumber *trackerID;
	int trackerIDint;
    sqlite3 *educateDatabase;
	NSString *scaleType;
	int latestDateRecordID;
	CustomNavigationHeaderThin *customNavHeader;
	UIScrollView *trackerScrollView;
	UITableView *trackerTableView;
	UITableView *trackerNameTableView;
	BOOL hasPushedStudentListEditor;
	BOOL popControllerAfterDismissingAlert;
	UIButton *emailToStudentsButton;
	UIButton *emailTrackerButton;
	
}
- (void)populateStudentListForTracker:(int)localTrackerID withScaleType:(NSString *)localScaleType;
- (void)initialiseStudentListArray;
- (void)saveStudentListArrayToDatabase;
- (void)createNewRecordDateForTrackerAndReloadArray;
- (void)callPopBackToPreviousView;
- (void)backupDatabaseToEmail;
- (void)composeEmailToStudentsInTracker;
- (void)shrinkTableViewsForKeyboardAndScrollToRow:(int)rowNumber;
- (void)expandTableViewsForKeyboard;

-(void)sendEmailMessage:(NSData *)withAttachedData;
-(void)launchMailAppOnDevice;

//- (void)startEditingTrackerLabelValue;

@property (nonatomic, retain) NSMutableArray *localStudentNameArray;
@property (nonatomic, retain) NSMutableArray *localDateRecordArray;
@property (nonatomic, retain) NSNumber *trackerID;
@property (nonatomic, retain) NSString *scaleType;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIScrollView *trackerScrollView;
@property (nonatomic, retain) UITableView *trackerTableView;
@property (nonatomic, retain) UITableView *trackerNameTableView;
@property (nonatomic, retain) UIButton *emailToStudentsButton;
@property (nonatomic, retain) UIButton *emailTrackerButton;

@end
