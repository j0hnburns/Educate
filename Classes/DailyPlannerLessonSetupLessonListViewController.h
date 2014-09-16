//
//  DailyPlannerLessonSetupLessonListViewController.h
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"

@interface DailyPlannerLessonSetupLessonListViewController :  UIViewController <UITableViewDelegate, UITableViewDataSource> {

	NSMutableArray *lessonSetupArray;
    sqlite3 *educateDatabase;
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	UIButton *settingsButton;
	UITableView *trackerTableView;
	
	
	int pendingUploads;
	BOOL uploadHasStartedAcceptingData;
	BOOL shouldDisplayErrorMessageAndAbort;
	BOOL hasCalledExportASecondTime;
	BOOL hasDisplayedAnErrorMessage;
}

- (void)showSettingsViewController;
- (void)initialiseStudentTrackerArray;
- (void)saveStudentTrackerArrayToDatabase;
- (void)callPopBackToPreviousView;
- (void)addNewLessonToDatabase;
- (void)deleteLesson:(int)deletedLessonID;

@property (nonatomic, retain) NSMutableArray *lessonSetupArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UITableView *trackerTableView;


@end
