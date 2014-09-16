//
//  SettingsViewController.h
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeader.h"


@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
	CustomNavigationHeader *customNavHeader;
	UIImageView *viewBackground;
	UIButton *emailRollButton;
	UIButton *moodleButton;
	UIButton *googleButton;
	
	UIButton *backupDatabaseButton;
	UILabel *googleDocsHintLabel;
	
	UILabel *sectionHeaderLabel;
	UILabel *firstFieldLabel;
	UILabel *secondFieldLabel;
	UILabel *thirdFieldLabel;
	
	UITextField *personalFullNameField;
	UITextField *personalEmailField;
	UITextField *moodleEmailField;
	UITextField *moodlePasswordField;
	UITextField *moodleURLField;
	UITextField *googleEmailField;
	UITextField *googlePasswordField;
	UITextField *blackboardURLField;
    sqlite3 *educateDatabase;
	
}

- (void)callPopBackToPreviousView;
- (void)showPersonalSettings;
- (void)showMoodleSettings;
- (void)showGoogleSettings;
- (void)setViewMovedUp:(BOOL)movedUp;
- (void)slideViewUpForKeyboard;
- (void)backupDatabaseToEmail;

@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *emailRollButton;
@property (nonatomic, retain) UIButton *moodleButton;
@property (nonatomic, retain) UIButton *googleButton;

@property (nonatomic, retain) UIButton *backupDatabaseButton;
@property (nonatomic, retain) UILabel *googleDocsHintLabel;

@property (nonatomic, retain) UILabel *sectionHeaderLabel;
@property (nonatomic, retain) UILabel *firstFieldLabel;
@property (nonatomic, retain) UILabel *secondFieldLabel;
@property (nonatomic, retain) UILabel *thirdFieldLabel;

@property (nonatomic, retain) UITextField *personalFullNameField;
@property (nonatomic, retain) UITextField *personalEmailField;
@property (nonatomic, retain) UITextField *moodleEmailField;
@property (nonatomic, retain) UITextField *moodlePasswordField;
@property (nonatomic, retain) UITextField *moodleURLField;
@property (nonatomic, retain) UITextField *googleEmailField;
@property (nonatomic, retain) UITextField *googlePasswordField;
@property (nonatomic, retain) UITextField *blackboardURLField;


@end
