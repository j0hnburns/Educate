//
//  DailyPlannerLessonInstanceNotesHistoryCell.h
//  iSNA
//
//  Created by James Hodge on 27/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyPlannerLessonInstanceNotesHistoryCell : UITableViewCell {
	
	UILabel *noteContent;
	UILabel *noteDate;

}

- (void)setLeftAlignment;

@property (nonatomic, retain) UILabel *noteContent;
@property (nonatomic, retain) UILabel *noteDate;

@end
