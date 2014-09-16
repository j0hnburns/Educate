//
//  StudentTrackerSTudentListNameTitleCell.m
//  Educate
//
//  Created by James Hodge on 26/10/09.
//  Copyright 2009 Furnishing Industry Software House. All rights reserved.
//

#import "StudentTrackerSTudentListNameTitleCell.h"


@implementation StudentTrackerSTudentListNameTitleCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
	studentNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150.0, 50)];
	studentNameTitleLabel.backgroundColor = [UIColor clearColor];
	studentNameTitleLabel.textColor = [UIColor blackColor];
	studentNameTitleLabel.textAlignment = UITextAlignmentLeft;
	studentNameTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentNameTitleLabel.text = @"Surname";
	[self addSubview:studentNameTitleLabel];	
	
	studentFirstNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150.0, 50)];
	studentFirstNameTitleLabel.backgroundColor = [UIColor clearColor];
	studentFirstNameTitleLabel.textColor = [UIColor blackColor];
	studentFirstNameTitleLabel.textAlignment = UITextAlignmentLeft;
	studentFirstNameTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentFirstNameTitleLabel.text = @"First Name";
	[self addSubview:studentFirstNameTitleLabel];	
	
	studentEmailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(310, 5, 250.0, 50)];
	studentEmailTitleLabel.backgroundColor = [UIColor clearColor];
	studentEmailTitleLabel.textColor = [UIColor blackColor];
	studentEmailTitleLabel.textAlignment = UITextAlignmentLeft;
	studentEmailTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentEmailTitleLabel.text = @"Email";
	[self addSubview:studentEmailTitleLabel];	
	
	studentPhone1TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(560, 5, 250.0, 50)];
	studentPhone1TitleLabel.backgroundColor = [UIColor clearColor];
	studentPhone1TitleLabel.textColor = [UIColor blackColor];
	studentPhone1TitleLabel.textAlignment = UITextAlignmentLeft;
	studentPhone1TitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentPhone1TitleLabel.text = @"Phone";
	[self addSubview:studentPhone1TitleLabel];	
	
	
	studentParentNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(810, 5, 250.0, 50)];
	studentParentNameTitleLabel.backgroundColor = [UIColor clearColor];
	studentParentNameTitleLabel.textColor = [UIColor blackColor];
	studentParentNameTitleLabel.textAlignment = UITextAlignmentLeft;
	studentParentNameTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentParentNameTitleLabel.text = @"Guardian Name";
	[self addSubview:studentParentNameTitleLabel];	
	
	guardianEmailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1060, 5, 250.0, 50)];
	guardianEmailTitleLabel.backgroundColor = [UIColor clearColor];
	guardianEmailTitleLabel.textColor = [UIColor blackColor];
	guardianEmailTitleLabel.textAlignment = UITextAlignmentLeft;
	guardianEmailTitleLabel.font = [UIFont boldSystemFontOfSize:20];
	guardianEmailTitleLabel.text = @"Guardian Email";
	[self addSubview:guardianEmailTitleLabel];	
	
	studentPhone2TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1310, 5, 250.0, 50)];
	studentPhone2TitleLabel.backgroundColor = [UIColor clearColor];
	studentPhone2TitleLabel.textColor = [UIColor blackColor];
	studentPhone2TitleLabel.textAlignment = UITextAlignmentLeft;
	studentPhone2TitleLabel.font = [UIFont boldSystemFontOfSize:20];
	studentPhone2TitleLabel.text = @"Guardian Phone";
	[self addSubview:studentPhone2TitleLabel];	
	
	
	
	
	
    return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
