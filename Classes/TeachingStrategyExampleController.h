//
//  TeachingStrategyExampleController.h
//  Educate
//
//  Created by James Hodge on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeader.h"


@interface TeachingStrategyExampleController : UIViewController {

	CustomNavigationHeader *customNavHeader;
	UIImageView *exampleImageView;
	UIScrollView *imageScrollFrame;

	
}

- (void)callPopBackToPreviousView;
- (void)addDescriptionImageToScrollView:(NSString *)withImageName;

@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;
@property (nonatomic, retain) UIImageView *exampleImageView;
@property (nonatomic, retain) UIScrollView *imageScrollFrame;

@end
