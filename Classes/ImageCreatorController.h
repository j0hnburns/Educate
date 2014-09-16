//
//  ImageCreatorController.h
//  Educate
//
//  Created by James Hodge on 26/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageCreatorController : UIViewController {

}

- (void)callPopBackToPreviousView;
- (void)openExistingImageController;
- (void)startEditingNewImageFromCamera;
- (void)startEditingNewImageFromLibrary;

@end
