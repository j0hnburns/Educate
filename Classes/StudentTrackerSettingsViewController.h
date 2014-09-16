//
//  StudentTrackerSettingsViewController.h
//  Educate
//
//  Created by James Hodge on 16/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeader.h"


@interface StudentTrackerSettingsViewController :  UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *studentTrackerArray;
    sqlite3 *educateDatabase;
	UIButton *settingsButton;
	UITableView *trackerTableView;
	UIImageView *viewBackground;
	CustomNavigationHeader *customNavHeader;

}

- (void)closeSettingsViewController;
- (void)initialiseStudentTrackerArray;
- (void)saveStudentTrackerArrayToDatabase;
- (void)toggleEditing;
- (void)addNewTracker;
- (void)deleteTracker:(int)trackerID;
- (void)createNewResultsColumn;

@property (nonatomic, retain) NSMutableArray *studentTrackerArray;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UITableView *trackerTableView;
@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;

@end
