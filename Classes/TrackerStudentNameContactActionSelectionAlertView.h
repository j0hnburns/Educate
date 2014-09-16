//
//  TrackerStudentNameContactActionSelectionAlertView.h
//  Educate
//
//  Created by James Hodge on 28/11/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackerStudentNameContactActionSelectionAlertView : UIAlertView {

	
	UIButton *valueButtonPhoneStudent;
	UIButton *valueButtonPhoneGuardian;
	UIButton *valueButtonEmailStudent;
	UIButton *valueButtonEmailGuardian;
	
	
}

- (void)returnValuePhoneStudent;
- (void)returnValuePhoneGuardian;
- (void)returnValueEmailStudent;
- (void)returnValueEmailGuardian;
- (void)cancelAndReturn;

@property (nonatomic, retain) UIButton *valueButtonPhoneStudent;
@property (nonatomic, retain) UIButton *valueButtonPhoneGuardian;
@property (nonatomic, retain) UIButton *valueButtonEmailStudent;
@property (nonatomic, retain) UIButton *valueButtonEmailGuardian;


@end
