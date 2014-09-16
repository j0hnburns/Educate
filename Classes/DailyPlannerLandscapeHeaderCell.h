//
//  DailyPlannerLandscapeHeaderCell.h
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DailyPlannerLandscapeHeaderCell : UITableViewCell <UITextViewDelegate> {

	NSMutableArray *buttonArray;
	NSMutableArray *plannerColumnHeaderArray;
	
	NSMutableString *mutableTitleString;
	int editingColumnNumber;
}

- (void)populateCells;
- (void)setTrackerValueForColumnRepresentedBySender:(id)sender;
- (void)updateValueFromTextEditor;
- (void)startEditingTrackerLabelValue;

@property (nonatomic,retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableString *mutableTitleString;

@end
