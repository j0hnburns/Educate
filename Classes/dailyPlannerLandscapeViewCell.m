//
//  dailyPlannerLandscapeViewCell.m
//  Educate
//
//  Created by James Hodge on 4/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "dailyPlannerLandscapeViewCell.h"
#import "EducateAppDelegate.h"
#import "DailyPlannerLessonInstanceEditorViewController.h"


@implementation dailyPlannerLandscapeViewCell

@synthesize startTimeLabel;
@synthesize periodNameLabel;
@synthesize stopTimeLabel;
@synthesize labelBackground;
@synthesize localPlannerRowArray;
@synthesize buttonArray;
@synthesize backgroundArray;
 

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		
		localPlannerRowArray = [[NSMutableArray alloc] init];
		buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
		backgroundArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		/*
		labelBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank.png"]];	
		labelBackground.frame = CGRectMake(0, 0, 70, 40);
		[self.contentView addSubview:labelBackground];
		[labelBackground release];
		
		// position the lesson name in the cell
		periodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
		periodNameLabel.backgroundColor = [UIColor clearColor];
		periodNameLabel.font = [UIFont boldSystemFontOfSize:14];
		periodNameLabel.textColor = [UIColor blackColor];
		periodNameLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:periodNameLabel];
		[periodNameLabel release];
		 */
		
    }
    return self;
}

- (void)showPeriodDetail:(id)sender {
	[self pushPeriodDetailViewController:([sender tag])];
}


- (void)setPeriodID:(int)newPeriodID {
	periodID = newPeriodID;
}

- (int)getPeriodID {
	return periodID;
}


- (void)populateCellNames {
	
	 NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self clearCellNames];
	[self initialiseLocalPlannerArray];
	
	// run a loop for the number of days in the timetable cycle as per the setting in the appDelegate
	// for each day add a label (button) and a background
	
	int i = 0;
	
	while ([appDelegate.settings_plannerDayCycleLength intValue] > i) {
		
		UIImageView* cellBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weeklyPlannerCellCream.png"]];	
		cellBackground.frame = CGRectMake(85*i,0,85, 40);
		[self.contentView addSubview:cellBackground];
		[backgroundArray addObject:cellBackground];
		[cellBackground release];
		
		
		
		CGRect frame = CGRectMake(85*i, 0,85, 40);
		UIButton* periodButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		periodButton.frame = frame;
		[periodButton setTitle:[[localPlannerRowArray objectAtIndex:i] objectAtIndex:2] forState:UIControlStateNormal];
		[periodButton setBackgroundColor:[UIColor clearColor]];
		[periodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[periodButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
		periodButton.tag = i;
		[periodButton addTarget:self action:@selector(showPeriodDetail:) forControlEvents:UIControlEventTouchUpInside];
		
		// set colours for the subject
		if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Yellow"]) {
			[periodButton setBackgroundColor:[UIColor yellowColor]];
			[periodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Blue"]) {
			[periodButton setBackgroundColor:[UIColor blueColor]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Grey"]) {
			[periodButton setBackgroundColor:[UIColor grayColor]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Green"]) {
			[periodButton setBackgroundColor:[UIColor colorWithRed:0.25 green:0.5 blue:0.054 alpha:1]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Red"]) {
			[periodButton setBackgroundColor:[UIColor redColor]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Orange"]) {
			[periodButton setBackgroundColor:[UIColor orangeColor]];
			[periodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Purple"]) {
			[periodButton setBackgroundColor:[UIColor purpleColor]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"White"]) {
			[periodButton setBackgroundColor:[UIColor whiteColor]];
			[periodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		} else if ([[[localPlannerRowArray objectAtIndex:i] objectAtIndex:4] isEqualToString:@"Black"]) {
			[periodButton setBackgroundColor:[UIColor blackColor]];
			[periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		} else {
			[periodButton setBackgroundColor:[UIColor clearColor]];
			[periodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		}
		
		
		[self.contentView addSubview:periodButton];
		[buttonArray addObject:periodButton];
		[periodButton release];
		
		i +=1;
		
	}
		
	
	[pool release];
}

- (void)clearCellNames {
	
	while ([buttonArray count] > 0) {
	
		[[buttonArray lastObject] removeFromSuperview];
		[buttonArray removeLastObject];
		
	}
	while ([backgroundArray count] > 0) {
		
		[[backgroundArray lastObject] removeFromSuperview];
		[backgroundArray removeLastObject];
		
	}
}

- (void)setDefaultButtonTitleColours {
	
	int i = 0;
	
	while ([buttonArray count] > i) {
		
		[[buttonArray objectAtIndex:i] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		i +=1;
		
	}
}

- (void)setButtonAppearanceForOddRow {
	
	// row is odd, colour cream with white period name
	
	self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	periodNameLabel.textColor = [UIColor blackColor];
	
	int i = 0;
	
	while ([backgroundArray count] > i) {
		
		
		[[backgroundArray objectAtIndex:i] setImage:[UIImage imageNamed:@"weeklyPlannerCellCream.png"]];
		i +=1;
		
	}
}

- (void)setButtonAppearanceForEvenRow {
	
	// row is even, colour grey gradient with blue period name
	self.contentView.backgroundColor = [UIColor colorWithRed:0.0039 green:0.3203 blue:0.7815 alpha:1];
	periodNameLabel.textColor = [UIColor whiteColor];
	
	int i = 0;
	
	while ([backgroundArray count] > i) {
			
		[[backgroundArray objectAtIndex:i] setImage:[UIImage imageNamed:@"weeklyPlannerCellGradient.png"]];	
		i +=1;
		
	}
}

- (void)setButtonAppearanceForBreakRow {
	
	self.contentView.backgroundColor = [UIColor lightGrayColor];
	labelBackground.image = [UIImage imageNamed:@"weeklyPlannerCellBreak.png"];
	periodNameLabel.textColor = [UIColor whiteColor];
	
	int i = 0;
	
	while ([buttonArray count] > i) {
		
		[[buttonArray objectAtIndex:i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		i +=1;
		
	}	
	
	i = 0;
	
	while ([buttonArray count] > i) {
		
		[[backgroundArray objectAtIndex:i] setImage:[UIImage imageNamed:@"weeklyPlannerCellBreak.png"]];		
		i +=1;
		
	}
}




- (void)pushPeriodDetailViewController:(int)withRowNumber {
	// push the period detail editor with the row number specified
	[UIApplication sharedApplication].networkActivityIndicatorVisible =YES;
   EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	DailyPlannerLessonInstanceEditorViewController *dailyPlannerLessonInstanceEditorViewController = [[DailyPlannerLessonInstanceEditorViewController alloc] initWithNibName:nil bundle:nil];    
	dailyPlannerLessonInstanceEditorViewController.title = [NSString stringWithFormat:@"%@",[[localPlannerRowArray objectAtIndex:withRowNumber] objectAtIndex:2]];
	dailyPlannerLessonInstanceEditorViewController.customNavHeader.lowerSubHeading.text = [NSString stringWithFormat:@"%@",periodNameLabel.text];
	
	
	
	
	dailyPlannerLessonInstanceEditorViewController.periodID = [NSNumber numberWithInt:periodID];
	dailyPlannerLessonInstanceEditorViewController.weekday = [NSNumber numberWithInt:withRowNumber];
	[dailyPlannerLessonInstanceEditorViewController initialiseLocalPlannerArray];
	
	[[[appDelegate tabBarController] selectedViewController] pushViewController:dailyPlannerLessonInstanceEditorViewController animated:YES];
	[dailyPlannerLessonInstanceEditorViewController release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
	
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseLocalPlannerArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	while ([localPlannerRowArray count] > 0) {
		[localPlannerRowArray removeLastObject];
	}
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT v.periodID, v.weekday, v.subjectName, v.classroom, (SELECT l.colour FROM weeklyPlannerLessonSetup l WHERE l.lessonName = v.subjectName) as colour FROM weeklyPlannerValues v WHERE v.periodID = ? ORDER BY weekday";
		
		
		
		
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, periodID);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT v.periodID, v.weekday, v.subjectName, v.classroom, (SELECT l.colour FROM weeklyPlannerLessonSetup l WHERE l.lessonName = v.subjectName) as colour FROM weeklyPlannerValues v WHERE v.periodID = %i ORDER BY weekday", periodID);
			
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *rowPeriodID = (char *)sqlite3_column_text(statement, 0);
				char *rowWeekday = (char *)sqlite3_column_text(statement, 1);
				char *rowSubjectName = (char *)sqlite3_column_text(statement, 2);
				char *rowClassroom = (char *)sqlite3_column_text(statement, 3);
				char *rowColour = (char *)sqlite3_column_text(statement, 4);
				[localPlannerRowArray addObject:[[NSMutableArray arrayWithObjects:
														(rowPeriodID) ? [NSString stringWithUTF8String:rowPeriodID] : @"",
														(rowWeekday) ? [NSString stringWithUTF8String:rowWeekday] : @"",
												  (rowSubjectName) ? [NSString stringWithUTF8String:rowSubjectName] : @"",
												  (rowClassroom) ? [NSString stringWithUTF8String:rowClassroom] : @"",
												  (rowColour) ? [NSString stringWithUTF8String:rowColour] : @"",
														nil] retain]];
				//NSLog(@"Query Returned Row %i", rowNumber);
				
				rowNumber +=1;
			}
			// Reset the query for the next use.
			sqlite3_reset(statement);
			
			
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
        sqlite3_close(educateDatabase);
		NSLog(@"Landscape View Returned Message '%s'.", sqlite3_errmsg(educateDatabase));
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(educateDatabase);
       // NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(educateDatabase));
		NSLog(@"Landscape View Error Message '%s'.", sqlite3_errmsg(educateDatabase));
        // Additional error handling, as appropriate...
    }
	[pool release];
}


- (void)dealloc {
	[self clearCellNames];
	[startTimeLabel release];
	[periodNameLabel release];
	[stopTimeLabel release];
	[labelBackground release];
	[localPlannerRowArray release];
	[buttonArray release];
	[backgroundArray release];
    [super dealloc];
}


@end

