//
//  DailyPlannerPortraitViewCell.m
//  Educate
//
//  Created by James Hodge on 4/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "DailyPlannerPortraitViewCell.h"


@implementation DailyPlannerPortraitViewCell

@synthesize startTimeLabel;
@synthesize lessonNameLabel;
@synthesize periodNameLabel;



- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		// position the start time in the cell
		startTimeLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 2, 50, 7)];
		startTimeLabel.backgroundColor = [UIColor whiteColor];
		startTimeLabel.font = [UIFont systemFontOfSize:13];
		startTimeLabel.textColor = [UIColor darkGrayColor];
		[self.contentView addSubview:startTimeLabel];
		[startTimeLabel release];
		
		// position the stop time in the cell
		periodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)];
		periodNameLabel.backgroundColor = [UIColor whiteColor];
		periodNameLabel.font = [UIFont boldSystemFontOfSize:20];
		periodNameLabel.textColor = [UIColor darkGrayColor];		
		[self.contentView addSubview:periodNameLabel];
		[periodNameLabel release];
		
		// position the lesson name in the cell
		lessonNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 210.0, 25)];
		lessonNameLabel.backgroundColor = [UIColor whiteColor];
		lessonNameLabel.font = [UIFont boldSystemFontOfSize:20];
		lessonNameLabel.textColor = [UIColor blackColor];
		[self.contentView addSubview:lessonNameLabel];
		[lessonNameLabel release];
		
		periodID = 0;
		
		
				
		
    }
    return self;
}

- (void)setPeriodID:(int)newPeriodID {
	periodID = newPeriodID;
}

- (int)getPeriodID {
	return periodID;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)dealloc {
	[startTimeLabel release];
	[lessonNameLabel release];
	[periodNameLabel release];

    [super dealloc];
}


@end

