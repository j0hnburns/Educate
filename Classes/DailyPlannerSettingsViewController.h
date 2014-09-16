//
//  DailyPlannerSettingsViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeader.h"



@interface DailyPlannerSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
    sqlite3 *educateDatabase;
	NSMutableArray *localPlannerStructureArray;
	UIButton *settingsButton;
	UITableView *weeklyPlannerTableView;
	CustomNavigationHeader *customNavHeader;
}

- (void)closeSettingsViewController;
- (void)initialiseLocalPlannerArray;
- (void)toggleEditing;
- (void)createNewPeriod;
- (void)changePlannerDayCycleLength;
- (void)showLessonConfigurationViewController;

@property (nonatomic, retain) NSMutableArray *localPlannerStructureArray;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIScrollView *weeklyPlannerTableView;

@end
