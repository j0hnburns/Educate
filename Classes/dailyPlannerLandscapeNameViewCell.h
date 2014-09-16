//
//  dailyPlannerLandscapeNameViewCell.h
//  Educate
//
//  Created by James Hodge on 4/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>



@interface dailyPlannerLandscapeNameViewCell : UITableViewCell {
	
	UILabel *periodNameLabel;
	UIImageView *labelBackground;
	int periodID;
    sqlite3 *educateDatabase;
	NSMutableArray *localPlannerRowArray;
	
}

- (void)setPeriodID:(int)newPeriodID;
- (int)getPeriodID;

- (void)populateCellNames;
- (void)clearCellNames;
- (void)initialiseLocalPlannerArray;

- (void)setDefaultButtonTitleColours;
- (void)setButtonAppearanceForOddRow;
- (void)setButtonAppearanceForEvenRow;
- (void)setButtonAppearanceForBreakRow;


@property (nonatomic,retain) UILabel *periodNameLabel;
@property (nonatomic,retain) UIImageView *labelBackground;
@property (nonatomic, retain) NSMutableArray *localPlannerRowArray;


@end
