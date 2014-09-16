//
//  TeachingStrategyDescriptionController.h
//  Educate
//
//  Created by James Hodge on 16/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeader.h"


@interface TeachingStrategyDescriptionController : UIViewController {
	
	CustomNavigationHeader *customNavHeader;
	UIImageView *descriptionImageView;
	UIScrollView *imageScrollFrame;
	NSString *exampleImageName;
	UIButton *exampleButton;
}

- (void)callPopBackToPreviousView;
- (void)showExample;
- (void)addDescriptionImageToScrollView;

@property (nonatomic, retain) CustomNavigationHeader *customNavHeader;
@property (nonatomic, retain) UIImageView *descriptionImageView;
@property (nonatomic, retain) NSString *exampleImageName;
@property (nonatomic, retain) UIScrollView *imageScrollFrame;
@property (nonatomic, retain) UIButton *exampleButton;

@end
