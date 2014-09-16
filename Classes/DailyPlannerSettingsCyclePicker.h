//
//  DailyPlannerSettingsCyclePicker.h
//  Educate
//
//  Created by James Hodge on 21/10/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"


@interface DailyPlannerSettingsCyclePicker : UIViewController  <UIPickerViewDelegate>  {
	
	UIPickerView *dayCycleLengthPicker;
	NSMutableArray *dayCycleLengthValueOptionArray;
	NSNumber *dayCycleLengthValue;
	CustomNavigationHeaderThin *customNavHeader;
	BOOL hasChangedCycleLengthValue;
	 sqlite3 *educateDatabase;
	int dayCycleLengthValueInt;
	
}

- (CGRect)pickerFrameWithSize:(CGSize)size;
- (void)saveChangesToProfile:(int)withNewNumberOfDays;
- (void)callPopBackToPreviousView;

@property (nonatomic, retain) UIPickerView *dayCycleLengthPicker;
@property (nonatomic, retain) NSMutableArray *dayCycleLengthValueOptionArray;
@property (nonatomic, retain) NSNumber *dayCycleLengthValue;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;


@end
