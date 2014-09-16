//
//  DailyPlannerScrollViewController.h
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"


@interface DailyPlannerScrollViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UIScrollView *weeklyPlannerScrollView;
	UITableView *weeklyPlannerTableView;
	UITableView *weeklyPlannerTableNameView;
    sqlite3 *educateDatabase;
	NSMutableArray *localPlannerStructureArray;
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	UIButton *settingsButton;
	BOOL hasInitialised;
	
}
- (void) enterLandscapeMode:(BOOL)left;
- (void) exitLandscapeMode;
- (void) showSettingsViewController;
- (void) initialiseLocalPlannerArray;

@property (nonatomic, retain) UIScrollView *weeklyPlannerScrollView;
@property (nonatomic, retain) UIScrollView *weeklyPlannerTableView;
@property (nonatomic, retain) UITableView *weeklyPlannerTableNameView;
@property (nonatomic, retain) NSMutableArray *localPlannerStructureArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *settingsButton;

@end
