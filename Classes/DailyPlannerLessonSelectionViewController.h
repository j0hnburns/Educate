//
//  DailyPlannerLessonSelectionViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeaderThin.h"
#import <sqlite3.h>



@interface DailyPlannerLessonSelectionViewController : UIViewController <UIPickerViewDelegate> {
	
	NSNumber *periodID;
	NSNumber *weekday;
	UIPickerView *lessonPicker;
    sqlite3 *educateDatabase;
	NSMutableArray *lessonListArray;
	NSMutableArray *localLessonSetupArray;
	CustomNavigationHeaderThin *customNavHeaderThin;
	
}


- (void)callPopBackToPreviousView;
- (void)saveLessonToDatabase;
- (void)initialiseLessonList;

- (CGRect)pickerFrameWithSize:(CGSize)size;

@property (nonatomic, retain) NSNumber *periodID;
@property (nonatomic, retain) NSNumber *weekday;
@property (nonatomic, retain) UIPickerView *lessonPicker;
@property (nonatomic, retain) NSMutableArray *lessonListArray;
@property (nonatomic, retain) NSMutableArray *localLessonSetupArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeaderThin;

@end
