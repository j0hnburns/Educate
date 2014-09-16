//
//  TrackerLabelTextViewPopUpEditorView.h
//  GAY
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface TrackerLabelTextViewPopUpEditorView : UIViewController {
	
	UIImageView *backgroundImage;
	UIImageView *textCellBackgroundImage;
	UITextView *textView;
	NSMutableString *textReturnString;
	UIButton *cancelButton;
	UIButton *clearButton;
	UIButton *saveButton;
	UIButton *deleteButton;
	NSString *editingField;
	int localEditingColumn;
	int localTrackerID;
    sqlite3 *educateDatabase;

}

- (void)saveTextAndClose;
- (void)clearTextValue;
- (void)cancelChangesAndClose;
- (void)deleteColumnAndClose;
- (void)setLocalEditingColumn:(int)withInt;
- (void)setLocalTrackerID:(int)withInt;

@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *textCellBackgroundImage;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSMutableString *textReturnString;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *clearButton;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) NSString *editingField;
@end
