//
//  ELearningBookmarksWebViewController.h
//  Educate
//
//  Created by James Hodge on 29/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationHeaderThin.h"


@interface ELearningBookmarksWebViewController : UIViewController <UIWebViewDelegate> {
	
	UIWebView *bookmarkWebView;
	NSString *URLString;
	NSURL *bookmarkURL;
	NSString *titleString;
	CustomNavigationHeaderThin *customNavHeader;
}
- (void)callPopBackToPreviousView;
- (void)loadURLForString:(NSString *)withString;

@property (nonatomic, retain) UIWebView *bookmarkWebView;
@property (nonatomic, retain) NSString *URLString;
@property (nonatomic, retain) NSURL *bookmarkURL;
@property (nonatomic, retain) NSString *titleString;


@end
