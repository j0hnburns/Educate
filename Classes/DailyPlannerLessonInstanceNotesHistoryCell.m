//
//  DailyPlannerLessonInstanceNotesHistoryCell.m
//  iSNA
//
//  Created by James Hodge on 27/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DailyPlannerLessonInstanceNotesHistoryCell.h"
#import "EducateAppDelegate.h"


@implementation DailyPlannerLessonInstanceNotesHistoryCell

@synthesize noteContent;
@synthesize noteDate;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		[self setBackgroundColor:[UIColor whiteColor]];
		
		// position the text in the content rect
		noteContent = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 285, 5)];
		noteContent.backgroundColor = [UIColor clearColor];
		noteContent.font = [UIFont systemFontOfSize:14];		
		noteContent.numberOfLines = 0;
		noteContent.lineBreakMode = UILineBreakModeWordWrap;
		[self addSubview:noteContent];
		[noteContent release];
		
		// position the time label at the top of the content rect
		noteDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 240, 15)];
		noteDate.backgroundColor = [UIColor clearColor];
		noteDate.font = [UIFont systemFontOfSize:12];		
		noteDate.numberOfLines = 1;
		[self addSubview:noteDate];
		[noteDate release];
		
		
    }
    return self;
}


- (void)setLeftAlignment {
	noteContent.frame = CGRectMake(20, 18, 285, calcLabelHeight(noteContent.text, [UIFont systemFontOfSize:14], 99, 225));	
	noteContent.textAlignment = UITextAlignmentLeft;
	[noteContent sizeToFit];
	
	noteDate.textAlignment = UITextAlignmentLeft;
	noteDate.frame = CGRectMake(20, 2, 240, 15);
	

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	[noteContent release];
	[noteDate release];
    [super dealloc];
}


@end
