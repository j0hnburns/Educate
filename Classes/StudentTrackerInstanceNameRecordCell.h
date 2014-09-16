//
//  StudentTrackerInstanceNameRecordCell.h
//  Educate
//
//  Created by James Hodge on 19/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sqlite3.h>


@interface StudentTrackerInstanceNameRecordCell : UITableViewCell <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	

	UIButton *studentNameButton;
	UILabel *studentNameLabel;
	NSMutableArray *localInstanceRecordArray;
	NSMutableArray *localDateRecordArray;
	NSMutableArray *contactOptionsArray;	

	
	UIView *studentNameBackground;
	
	int editingButton;
	int trackerID;
    sqlite3 *educateDatabase;

}


- (void)showStudentContactActionSelectorAlert;
- (void)initialiseContactOptionsArray;
- (void)setTrackerID:(int)withID;


@property (nonatomic, retain) UILabel *studentNameLabel;
@property (nonatomic, retain) NSMutableArray *localInstanceRecordArray;
@property (nonatomic, retain) NSMutableArray *localDateRecordArray;
@property (nonatomic, retain) NSMutableArray *contactOptionsArray;


@property (nonatomic,retain) UIButton *studentNameButton;


@property (nonatomic, retain) UIView *studentNameBackground;


@end
