//
//  DailyPlannerLessonSetupInstanceViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeaderThin.h"
#import <sqlite3.h>



@interface DailyPlannerLessonSetupInstanceViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate> {
	
	
	UITextField *periodNameField;
	UITextField *classroomField;
	UIPickerView *colourPicker;
    sqlite3 *educateDatabase;
	NSMutableArray *localLessonSetupArray;
	NSMutableArray *pickerColourOptionArray;
	CustomNavigationHeaderThin *customNavHeaderThin;
	
}
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)slideViewUpForKeyboard;
- (void)changeLessonColour;
- (void)callPopBackToPreviousView;
- (void)saveLessonToDatabase;

- (CGRect)pickerFrameWithSize:(CGSize)size;

@property (nonatomic, retain) UITextField *periodNameField;
@property (nonatomic, retain) UITextField *classroomField;
@property (nonatomic, retain) UIPickerView *colourPicker;
@property (nonatomic, retain) NSMutableArray *localLessonSetupArray;
@property (nonatomic, retain) NSMutableArray *pickerColourOptionArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeaderThin;

@end
