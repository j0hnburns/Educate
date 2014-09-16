//
//  ImageCreatorImageEditorController.h
//  Educate
//
//  Created by James Hodge on 26/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageCreatorImageEditorController : UIViewController <UIImagePickerControllerDelegate, UIAlertViewDelegate> {
	
	UIImagePickerController *imagePicker;
	UIImage *currentEditingImage;
	UIImageView *currentEditingImageView;
	NSMutableArray *addedObjectsArray;
	UIButton *undoButton;
	UIButton *textButton;
	UIButton *arrowButton;
	UIView *imageEditingLayoutView;
	
}

- (void)callPopBackToPreviousView;
- (void)showCameraPicker:(BOOL)useCamera;
- (void)createNewArrowObject;
- (void)createNewTextObject;
- (void)removeObjectsFromViewInReverseOrder;
- (void)saveImageToPhotoRoll;
- (void)chooseBackButtonAction;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *currentEditingImage;
@property (nonatomic, retain) UIImageView *currentEditingImageView;
@property (nonatomic, retain) NSMutableArray *addedObjectsArray;
@property (nonatomic, retain) UIButton *undoButton;
@property (nonatomic, retain) UIButton *textButton;
@property (nonatomic, retain) UIButton *arrowButton;
@property (nonatomic, retain) UIView *imageEditingLayoutView;

@end
