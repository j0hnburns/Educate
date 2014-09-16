//
//  StudentTrackerInstanceHeaderCell.h
//  Educate
//
//  Created by James Hodge on 18/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h> 
#import "StudentTrackerInstanceRecordViewController.h"


@interface StudentTrackerInstanceHeaderCell : UITableViewCell <UITextViewDelegate> {
	NSMutableArray *localDateRecordArray;
	NSMutableArray *buttonArray;
	NSMutableString *mutableTitleString;
	UITableView *localTrackerTableView;
	StudentTrackerInstanceRecordViewController *localControllerInstance;
	
    sqlite3 *educateDatabase;
	
	int editingColumnNumber;
	int trackerID;
	
	
	BOOL hasShownAddTrackerColumnArchiveMessage;
}

-(void)populateHeaderLabelsFromArray;
- (void)startEditingTrackerLabelValue;

- (void)setTrackerValueForColumnRepresentedBySender:(id)sender;

- (void)updateValueFromTextEditor;
- (void)createNewResultsColumn;

- (void)setTrackerID:(int)withTrackerID;
- (void)setEditingColumnNumber:(int)withColumnNumber;


- (void)saveTrackerTitle:(NSString *)title forTrackerID:(int)localTrackerID;


@property (nonatomic,retain) NSMutableArray *localDateRecordArray;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableString *mutableTitleString;
@property (nonatomic, retain) UITableView *localTrackerTableView;
@property (nonatomic, retain) StudentTrackerInstanceRecordViewController *localControllerInstance;


@end