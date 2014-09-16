//
//  DailyPlannerLessonInstanceEditorViewController.h
//  Educate
//
//  Created by James Hodge on 5/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeader.h"
#import <sqlite3.h>



@interface DailyPlannerLessonInstanceEditorViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	
	NSNumber *periodID;
	NSNumber *weekday;
	UITextField *periodNameField;
	UITextField *classroomField;
	UITextView *notesView;
	UIImageView *notesViewBackground;
	UISegmentedControl *periodTypeSelector;
	UIButton *showNotesHistoryButton;
	UIButton *saveEditButton;
	UIButton *selectClassButton;
    sqlite3 *educateDatabase;
	NSMutableArray *localPlannerSubjectArray;
	CustomNavigationHeader *customNavHeader;
	BOOL currentlyEditing;
	
}
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)slideViewUpForKeyboard;
- (void)showNotesHistory;
- (void)changePeriodType;
- (void)callPopBackToPreviousView;
- (void)saveNotes;
- (void)newNote;
- (void)initialiseLocalPlannerArray;
- (void)saveLocalPlannerArrayToDatabase;
- (void)saveLocalPlannerNotesToDatabase;
- (void)createNewNoteForPeriod;
- (void)selectLessonNameFromDatabase;
- (void)togglePageEditing;

@property (nonatomic, retain) NSNumber *periodID;
@property (nonatomic, retain) NSNumber *weekday;
@property (nonatomic, retain) UITextField *periodNameField;
@property (nonatomic, retain) UITextField *classroomField;
@property (nonatomic, retain) UITextView *notesView;
@property (nonatomic, retain) UIImageView *notesViewBackground;
@property (nonatomic, retain) UISegmentedControl *periodTypeSelector;
@property (nonatomic, retain) UIButton *showNotesHistoryButton;
@property (nonatomic, retain) UIButton *saveEditButton;
@property (nonatomic, retain) UIButton *selectClassButton;
@property (nonatomic, retain) NSMutableArray *localPlannerSubjectArray;
@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;

@end
