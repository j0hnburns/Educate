//
//  StudentTrackerStudentListTableViewController.h
//  Educate
//
//  Created by James Hodge on 18/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeader.h"


@interface StudentTrackerStudentListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {

	NSMutableArray *studentListForTrackerArray;
	NSNumber *trackerID;
    sqlite3 *educateDatabase;
	UITableView *trackerTableView;
	UITableView *trackerTableNameView;
	UIScrollView *trackerScrollView;
	UIImageView *viewBackground;
	UIButton *settingsButton;
	UIButton *deleteButton;
	CustomNavigationHeader *customNavHeader;
	int currentlyEditingRow;
	int contentXOffsetForDeleteResizing;
	
	
	
}
- (void)populateStudentListForTracker:(int)localTrackerID;
- (void)initialiseStudentListArray;
- (void)saveStudentListArrayToDatabase;
- (void)deleteTrackerEntriesForStudent:(int)localStudentNameID;
- (void)callPopBackToPreviousView;
- (void)addStudentToListArray;
- (void)setCurrentlyEditingRowAndScroll:(int)toRow;
- (void)toggleEditingByButton;


@property (nonatomic, retain) NSMutableArray *studentListForTrackerArray;
@property (nonatomic, retain) NSNumber *trackerID;
@property (nonatomic, retain) UITableView *trackerTableView;
@property (nonatomic, retain) UITableView *trackerTableNameView;
@property (nonatomic, retain) UIScrollView *trackerScrollView;
@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIButton *deleteButton;


@end
