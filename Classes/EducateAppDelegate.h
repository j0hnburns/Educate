//
//  EducateAppDelegate.h
//  Educate
//
//  Created by James Hodge on 3/02/09.
//  Copyright F-I-S-H iPhone Development 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@class ELearningViewController;
@class DailyPlannerTableViewController;
@class DailyPlannerScrollViewController;
@class StudentFeedbackTableViewController;
@class TeachingStrategiesViewController;
@class SettingsViewController;
@class ForumBrowserViewController;
@class GoogleDocsListViewController;

@interface EducateAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	
	NetworkStatus internetConnectionStatus;
	
    UIWindow *window;
    UITabBarController *tabBarController;
	
	IBOutlet UINavigationController *studentFeedbackNavigationController;
	IBOutlet UINavigationController *dailyPlannerNavigationController;
	IBOutlet UINavigationController *eLearningNavigationController;
	IBOutlet UINavigationController *teachingStrategiesNavigationController;
	IBOutlet UINavigationController *settingsNavigationController;
	IBOutlet UINavigationController *forumBrowserNavigationController;
	IBOutlet UINavigationController *googleDocsNavigationController;
	
	IBOutlet StudentFeedbackTableViewController *studentFeedbackTableViewController;
	IBOutlet DailyPlannerScrollViewController *dailyPlannerScrollViewController;
	IBOutlet ELearningViewController *eLearningViewController;
	IBOutlet TeachingStrategiesViewController *teachingStrategiesViewController;
	IBOutlet SettingsViewController *settingsViewController;
	IBOutlet ForumBrowserViewController *forumBrowserViewController;
	IBOutlet GoogleDocsListViewController *googleDocsListViewController;
	
	// data storage for the app
	NSMutableArray *weeklyPlannerArray;
	NSMutableArray *structureArray;
	NSMutableArray *weeklyPlannerNotesArray;
	NSMutableArray *studentTrackerArray;
	NSMutableArray *studentTrackerStudentListArray;
	
	BOOL hasShownApplication21FirstLaunchMessage;
	BOOL currentViewControllerIsRotatable;
	
	// variables for the settings stored in NSUserDefaults store
	NSString *settings_personalFullName;
	NSString *settings_personalEmail;
	NSString *settings_moodleEmail;
	NSString *settings_moodlePassword;
	NSString *settings_googleEmail;
	NSString *settings_googlePassword;
	NSString *settings_moodleURL;
	NSString *settings_blackboardURL;
	NSNumber *settings_plannerDayCycleLength;

	
}

- (void) enterLandscapeMode:(BOOL)left;
- (void) exitLandscapeMode;
- (void)forceOrientationRefresh;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (BOOL)isCurrentViewControllerRotatable;
- (void)setCurrentViewControllerRotationStatus:(BOOL)canBeRotated;

float calcLabelHeight(NSString *string, UIFont *font, int lines, float lineWidth);

@property NetworkStatus internetConnectionStatus;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UINavigationController *studentFeedbackNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *dailyPlannerNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *eLearningNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *teachingStrategiesNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *settingsNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *forumBrowserNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *googleDocsNavigationController;

@property (nonatomic, retain) IBOutlet StudentFeedbackTableViewController *studentFeedbackTableViewController;
@property (nonatomic, retain) IBOutlet DailyPlannerScrollViewController *dailyPlannerScrollViewController;
@property (nonatomic, retain) IBOutlet ELearningViewController *eLearningViewController;
@property (nonatomic, retain) IBOutlet TeachingStrategiesViewController *teachingStrategiesViewController;
@property (nonatomic, retain) IBOutlet SettingsViewController *settingsViewController;
@property (nonatomic, retain) IBOutlet ForumBrowserViewController *forumBrowserViewController;
@property (nonatomic, retain) IBOutlet GoogleDocsListViewController *googleDocsListViewController;

// data storage for the app
@property (nonatomic, retain) NSMutableArray *weeklyPlannerArray;
@property (nonatomic, retain) NSMutableArray *structureArray;
@property (nonatomic, retain) NSMutableArray *weeklyPlannerNotesArray;
@property (nonatomic, retain) NSMutableArray *studentTrackerArray;
@property (nonatomic, retain) NSMutableArray *studentTrackerStudentListArray;

// variables for the settings stored in NSUserDefaults store
@property (nonatomic, retain) NSString *settings_personalFullName;
@property (nonatomic, retain) NSString *settings_personalEmail;
@property (nonatomic, retain) NSString *settings_moodleEmail;
@property (nonatomic, retain) NSString *settings_moodlePassword;
@property (nonatomic, retain) NSString *settings_googleEmail;
@property (nonatomic, retain) NSString *settings_googlePassword;
@property (nonatomic, retain) NSString *settings_moodleURL;
@property (nonatomic, retain) NSString *settings_blackboardURL;
@property (nonatomic, retain) NSNumber *settings_plannerDayCycleLength;

@end
