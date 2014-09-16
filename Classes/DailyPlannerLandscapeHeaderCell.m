//
//  DailyPlannerLandscapeHeaderCell.m
//  Educate
//
//  Created by James Hodge on 23/02/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DailyPlannerLandscapeHeaderCell.h"
#import "EducateAppDelegate.h"
#import "TrackerLabelTextViewPopUpEditorView.h"

@implementation DailyPlannerLandscapeHeaderCell

@synthesize buttonArray;
@synthesize mutableTitleString;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		editingColumnNumber = -1;
		plannerColumnHeaderArray = [[NSMutableArray alloc] initWithCapacity:0];
		NSMutableArray *tempMutableCopy = [[[NSUserDefaults standardUserDefaults] objectForKey:@"plannerColumnHeaderArray"] mutableCopy];
		[plannerColumnHeaderArray addObjectsFromArray:tempMutableCopy];
		[tempMutableCopy release];
		if (plannerColumnHeaderArray == nil)
		{
			// user has not launched this app before so set default cam and populate arrays
			plannerColumnHeaderArray = [[NSMutableArray alloc] initWithCapacity:0];
			
			int i = 0;
			
			while ([appDelegate.settings_plannerDayCycleLength intValue] > i) {
				
				[plannerColumnHeaderArray addObject:[NSString stringWithFormat:@"Day %i", i+1]];
				
				i +=1;
				
			}
			
		[[NSUserDefaults standardUserDefaults] setObject:plannerColumnHeaderArray forKey:@"plannerColumnHeaderArray"];
		}
		
				
		
			
    }
    return self;
}

- (void)populateCells {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	while ([buttonArray count] > 0) {
		[[buttonArray lastObject] removeFromSuperview];
		[buttonArray removeLastObject];
	}
	
	if ([appDelegate.settings_plannerDayCycleLength intValue] != [plannerColumnHeaderArray count]) {
		plannerColumnHeaderArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		int i = 0;
		
		while ([appDelegate.settings_plannerDayCycleLength intValue] > i) {
			
			[plannerColumnHeaderArray addObject:[NSString stringWithFormat:@"Day %i", i+1]];
			
			i +=1;
			
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:plannerColumnHeaderArray forKey:@"plannerColumnHeaderArray"];
		
		
	}
	
	// run a loop for the number of days in the timetable cycle as per the setting in the appDelegate
	// for each day add a label (button) and a background
	
	int i = 0;
	
	while ([appDelegate.settings_plannerDayCycleLength intValue] > i) {
		
		UIImageView* headerTabBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabTop.png"]];	
		headerTabBackground.frame = CGRectMake(i*85,0,85,40);
		[self.contentView addSubview:headerTabBackground];
		[headerTabBackground release];
		
		UIButton* headerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		headerButton.frame = CGRectMake(85*i, 0, 85, 40);	
		[headerButton setTitle:[plannerColumnHeaderArray objectAtIndex:i] forState:UIControlStateNormal];
		[headerButton setBackgroundColor:[UIColor clearColor]];
		[headerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[headerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		headerButton.tag = i;
		[headerButton addTarget:self action:@selector(setTrackerValueForColumnRepresentedBySender:) forControlEvents:UIControlEventTouchUpInside];
		[buttonArray addObject:headerButton];
		[self.contentView addSubview:headerButton];
		//[headerButton release];
		
		
		[buttonArray addObject:headerButton];
		
		i +=1;
		
	}
	
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateValueFromTextEditor {
	//if view appears and the editingColumnNumber value is configured, set that button value to the return string value
	
	if (editingColumnNumber != -1) {
		[[buttonArray objectAtIndex:editingColumnNumber] setTitle:mutableTitleString forState:UIControlStateNormal];
		
		[plannerColumnHeaderArray replaceObjectAtIndex:editingColumnNumber withObject:[NSString stringWithFormat:@"%@",mutableTitleString]];
		[[NSUserDefaults standardUserDefaults] setObject:plannerColumnHeaderArray forKey:@"plannerColumnHeaderArray"];
		editingColumnNumber = -1;
	}
}

- (void)setTrackerValueForColumnRepresentedBySender:(id)sender {
	
	//int i = 0;
	editingColumnNumber = [sender tag];
	
	/*
	 while ([buttonArray count] > i) {
	 if ([buttonArray objectAtIndex:i] == sender) {
	 editingColumnNumber = i;
	 }
	 i += 1;
	 }
	 */
	if ([plannerColumnHeaderArray count] > editingColumnNumber) {
		[self startEditingTrackerLabelValue]; // tag relates to a 'normal' column header, so display the editing code
	}
}


- (void)startEditingTrackerLabelValue {
	
	EducateAppDelegate *appDelegate = (EducateAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	mutableTitleString = [NSMutableString stringWithCapacity:1];
	[mutableTitleString setString:[plannerColumnHeaderArray objectAtIndex:editingColumnNumber]];
	
	TrackerLabelTextViewPopUpEditorView* textViewPopUpEditorView = [[TrackerLabelTextViewPopUpEditorView alloc] initWithNibName:nil bundle:nil];    
	textViewPopUpEditorView.title = @"Edit Timetable Day Heading";
	textViewPopUpEditorView.textReturnString = mutableTitleString;
	textViewPopUpEditorView.textView.text = [plannerColumnHeaderArray objectAtIndex:editingColumnNumber];
	textViewPopUpEditorView.textView.delegate = self;
	textViewPopUpEditorView.editingField = @"aboutMe";
	[textViewPopUpEditorView.view setAlpha:0.8];
	[[appDelegate tabBarController] presentModalViewController:textViewPopUpEditorView animated:YES];
	
	textViewPopUpEditorView.deleteButton.hidden = YES; 
	[textViewPopUpEditorView release];
	
}


- (void)dealloc {
	[buttonArray release];
	[mutableTitleString release];
    [super dealloc];
}


@end
