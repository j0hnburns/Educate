//
//  TrackerAttendanceAlertView.h
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackerAttendanceAlertView : UIAlertView {

}

- (void)returnValuePresent;
- (void)returnValueAbsent;
- (void)returnValueSick;
- (void)returnValueLeave;
- (void)returnValueM;
- (void)returnValueT;
- (void)cancelAndReturn;
- (void)clearAndReturn;

@end
