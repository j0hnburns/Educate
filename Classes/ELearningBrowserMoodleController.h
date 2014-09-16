//
//  ELearningBrowserMoodleController.h
//  Educate
//
//  Created by James Hodge on 12/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ELearningBrowserMoodleController : UIViewController <UIWebViewDelegate, UIImagePickerControllerDelegate> {

	UIWebView *forumWebView;
	UIImagePickerController *imagePicker;
	
}

- (void)browseToImageURL;
- (void)browseToPostURL;
- (void)callPopBackToPreviousView;

@property (nonatomic, retain) UIWebView *forumWebView;
@property (nonatomic, retain) UIImagePickerController *imagePicker;

@end
