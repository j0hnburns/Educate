//
//  DailyPlannerPortraitViewCell.h
//  Educate
//
//  Created by James Hodge on 4/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyPlannerPortraitViewCell : UITableViewCell {
	
	UILabel *startTimeLabel;
	UILabel *periodNameLabel;
	UILabel *lessonNameLabel;
	int periodID;

}

- (void)setPeriodID:(int)newPeriodID;
- (int)getPeriodID;

@property (nonatomic,retain) UILabel *startTimeLabel;
@property (nonatomic,retain) UILabel *lessonNameLabel;
@property (nonatomic,retain) UILabel *periodNameLabel;


@end
