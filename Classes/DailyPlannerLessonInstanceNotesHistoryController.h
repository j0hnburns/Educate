//
//  DailyPlannerLessonInstanceNotesHistoryController.h
//  Educate
//
//  Created by James Hodge on 10/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeaderThin.h"
#import <sqlite3.h>



@interface DailyPlannerLessonInstanceNotesHistoryController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	NSNumber *localWeeklyPlannerArrayRow;
	UITableView *weeklyPlannerTableView;
	NSMutableArray *notesHistoryArray;	
	CustomNavigationHeaderThin *customNavHeader;
    sqlite3 *educateDatabase;
	UIImageView *viewBackground;
	int periodID;
	int weekday;

}


- (void)configureHistoryArray:(NSNumber *)withWeeklyPlannerRow;
- (void)callPopBackToPreviousView;
- (void)setLocalValues:(int)withPeriodID andWeekday:(int)withWeekday;


@property (nonatomic, retain) NSNumber *localWeeklyPlannerArrayRow;
@property (nonatomic, retain) UIScrollView *weeklyPlannerTableView;
@property (nonatomic, retain) NSMutableArray *notesHistoryArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;



@end
