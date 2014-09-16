//
//  TrackerCompetencyAlertView.h
//  Educate
//
//  Created by James Hodge on 31/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrackerCompetencyAlertView : UIAlertView {

}

- (void)returnValueCompetent;
- (void)returnValueNotYetCompetent;
- (void)returnValueJ;
- (void)returnValueM;
- (void)cancelAndReturn;
- (void)clearAndReturn;


@end
