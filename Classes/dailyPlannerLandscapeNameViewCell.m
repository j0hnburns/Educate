//
//  dailyPlannerLandscapeNameViewCell.m
//  Educate
//
//  Created by James Hodge on 4/02/09.
//  Copyright 2009 F-I-S-H iPhone Development. All rights reserved.
//

#import "dailyPlannerLandscapeNameViewCell.h"
#import "EducateAppDelegate.h"
#import "DailyPlannerLessonInstanceEditorViewController.h"


@implementation dailyPlannerLandscapeNameViewCell


@synthesize periodNameLabel;
@synthesize labelBackground;
@synthesize localPlannerRowArray;
 
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
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

		
    }
    return self;
}



- (void)setPeriodID:(int)newPeriodID {
	periodID = newPeriodID;
}

- (int)getPeriodID {
	return periodID;
}


- (void)populateCellNames {
	
	
	[self clearCellNames];
	[self initialiseLocalPlannerArray];
	
			
	
	
}

- (void)clearCellNames {
	
	
}

- (void)setDefaultButtonTitleColours {
	
}

- (void)setButtonAppearanceForOddRow {
	
	// row is odd, colour cream with white period name
	
	self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	periodNameLabel.textColor = [UIColor blackColor];
	
	}

- (void)setButtonAppearanceForEvenRow {
	
	// row is even, colour grey gradient with blue period name
	self.contentView.backgroundColor = [UIColor colorWithRed:0.0039 green:0.3203 blue:0.7815 alpha:1];
	periodNameLabel.textColor = [UIColor whiteColor];
	
}

- (void)setButtonAppearanceForBreakRow {
	
	self.contentView.backgroundColor = [UIColor lightGrayColor];
	labelBackground.image = [UIImage imageNamed:@"weeklyPlannerCellBreak.png"];
	periodNameLabel.textColor = [UIColor whiteColor];
	
	
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


// Open the database connection and retrieve minimal information for all objects.
- (void)initialiseLocalPlannerArray {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	localPlannerRowArray = [[NSMutableArray alloc] init];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"educate2.sql"];
	
	// Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &educateDatabase) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT periodID, weekday, subjectName, classroom FROM weeklyPlannerValues WHERE periodID = ? ORDER BY weekday";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(educateDatabase, sql, -1, &statement, NULL) == SQLITE_OK) {
			
			sqlite3_bind_int(statement, 1, periodID);
			// Execute the query.
			//int success =sqlite3_step(statement);
			NSLog(@"SELECT periodID, weekday, subjectName, classroom FROM weeklyPlannerValues WHERE periodID = %i", periodID);
			
			int rowNumber = 0;
			while (sqlite3_step(statement) == SQLITE_ROW) {
				char *rowPeriodID = (char *)sqlite3_column_text(statement, 0);
				char *rowWeekday = (char *)sqlite3_column_text(statement, 1);
				char *rowSubjectName = (char *)sqlite3_column_text(statement, 2);
				char *rowClassroom = (char *)sqlite3_column_text(statement, 3);
				[localPlannerRowArray addObject:[[NSMutableArray arrayWithObjects:
														(rowPeriodID) ? [NSString stringWithUTF8String:rowPeriodID] : @"",
														(rowWeekday) ? [NSString stringWithUTF8String:rowWeekday] : @"",
												  (rowSubjectName) ? [NSString stringWithUTF8String:rowSubjectName] : @"",
												  (rowClassroom) ? [NSString stringWithUTF8String:rowClassroom] : @"",
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
	[periodNameLabel release];
	[labelBackground release];
	[localPlannerRowArray release];
    [super dealloc];
}


@end

