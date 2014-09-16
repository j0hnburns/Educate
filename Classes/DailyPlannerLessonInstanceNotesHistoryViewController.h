//
//  DailyPlannerLessonInstanceNotesHistoryViewController.h
//  iSNA
//
//  Created by James Hodge on 26/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DailyPlannerLessonInstanceNotesHistoryCell;

@interface DailyPlannerLessonInstanceNotesHistoryViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>  {
	
	
	NSNumber *localWeeklyPlannerArrayRow;
	NSMutableArray *notesHistoryArray;	
	UITableView *notesTableView;
}


- (void)configureHistoryArray;


@property (nonatomic, retain) NSNumber *localWeeklyPlannerArrayRow;
@property (nonatomic, retain) NSMutableArray *notesHistoryArray;
@property (nonatomic, retain) UITableView *notesTableView;


@end
