//
//  ELearningBookmarksViewController.h
//  Educate
//
//  Created by James Hodge on 29/09/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ELearningBookmarksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *bookmarksTableView;
	NSMutableArray *localBookmarksArray;
	UIButton *editButton;
	BOOL hasLoadedFavicons;
}

- (void)initialiseLocalBookmarksArray;
- (void)callPopBackToPreviousView;
- (void)toggleTableEditingMode;
- (void)retrieveFaviconInThread:(NSNumber *)forRow;

@property (nonatomic, retain) UITableView *bookmarksTableView;
@property (nonatomic, retain) NSMutableArray *localBookmarksArray;
@property (nonatomic, retain) UIButton *editButton;


@end
