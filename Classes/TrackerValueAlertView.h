//
//  TrackerValueAlertView.h
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackerValueAlertView : UIAlertView {

	UIButton *valueButtonA;
	UIButton *valueButtonB;
	UIButton *valueButtonC;
	UIButton *valueButtonD;
	UIButton *valueButtonE;
	
}

- (void)returnValueA;
- (void)returnValueAPlus;
- (void)returnValueAMinus;
- (void)returnValueB;
- (void)returnValueBPlus;
- (void)returnValueBMinus;
- (void)returnValueC;
- (void)returnValueCPlus;
- (void)returnValueCMinus;
- (void)returnValueD;
- (void)returnValueDPlus;
- (void)returnValueDMinus;
- (void)returnValueE;
- (void)returnValueEPlus;
- (void)returnValueEMinus;
- (void)cancelAndReturn;
- (void)clearAndReturn;

- (void)popModifiersForA;
- (void)popModifiersForB;
- (void)popModifiersForC;
- (void)popModifiersForD;
- (void)popModifiersForE;

@end
