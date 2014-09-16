//
//  TeachingCollaborativeStrategiesViewController.h
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomNavigationHeaderThin.h"


@interface TeachingCollaborativeStrategiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	
	UITableView *strategiesTableView;
    sqlite3 *educateDatabase;
	NSMutableArray *localStrategiesArray;
	CustomNavigationHeaderThin *customNavHeader;
	UIImageView *viewBackground;
	UIButton *settingsButton;
	
}

- (void)initialiseLocalStrategiesArray;
- (void)callPopBackToPreviousView;


@property (nonatomic, retain) UIScrollView *strategiesTableView;
@property (nonatomic, retain) NSMutableArray *localStrategiesArray;
@property (nonatomic, retain) CustomNavigationHeaderThin *customNavHeader;
@property (nonatomic, retain) UIImageView *viewBackground;
@property (nonatomic, retain) UIButton *settingsButton;

@end
