//
//  CustomNavigationHeader.h
//  Educate
//
//  Created by James Hodge on 2/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomNavigationHeader : UIView {
	
	UIImageView *viewBackground;
	UIButton *backButton;
	UILabel *viewHeader;
	UIButton *rightSettingsButton;
	UILabel *upperSubHeading;
	UILabel *lowerSubHeading;

}

- (void)popBackToPreviousView;
- (void)callPopBackToPreviousView;

@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UILabel *viewHeader;
@property (nonatomic, retain) UIButton *rightSettingsButton;

@property (nonatomic, retain) UILabel *upperSubHeading;
@property (nonatomic, retain) UILabel *lowerSubHeading;

@end
