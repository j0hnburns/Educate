//
//  ForumBrowserViewController.h
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForumBrowserViewController : UIViewController <UIWebViewDelegate> {

	UIWebView *forumWebView;
	
}
- (void)callPopBackToPreviousView;

@property (nonatomic, retain) UIWebView *forumWebView;

@end
