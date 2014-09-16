//
//  ELearningBrowserBlackBoardController.h
//  Educate
//
//  Created by James Hodge on 9/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ELearningBrowserBlackBoardController : UIViewController <UIWebViewDelegate> {
	
	UIWebView *forumWebView;
	
}

- (void)browseToImageURL;
- (void)browseToPostURL;
- (void)callPopBackToPreviousView;

@property (nonatomic, retain) UIWebView *forumWebView;

@end
