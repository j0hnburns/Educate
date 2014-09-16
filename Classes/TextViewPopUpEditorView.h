//
//  TextViewPopUpEditorView.h
//  GAY
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextViewPopUpEditorView : UIViewController {
	
	UIImageView *backgroundImage;
	UIImageView *textCellBackgroundImage;
	UITextView *textView;
	UIButton *cancelButton;
	UIButton *clearButton;
	UIButton *deleteColumnButton;
	UIButton *saveButton;
	NSString *editingField;

}

- (void)saveTextAndClose;
- (void)clearTextValue;
- (void)cancelChangesAndClose;
- (void)deleteColumnFromTracker;

@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *textCellBackgroundImage;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *clearButton;
@property (nonatomic, retain) UIButton *deleteColumnButton;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) NSString *editingField;
@end
