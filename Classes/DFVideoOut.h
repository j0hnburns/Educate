//
//  DFVideoOut.h
//  DFVideoOut
//
//  Created by Kyle Richter on 11/14/09.
//  Copyright 2009 Dragon Forged Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DFVideoOut : NSObject 
{
	NSNumber *framesPerSecond;
	NSNumber *scaleBy;
}

@property (nonatomic, retain) NSNumber *framesPerSecond;
@property (nonatomic, retain) NSNumber *scaleBy;


-(void)startVideoOut;
-(void)stopVideoOut;
-(void)freezeFrame;
-(void)resumeFrame;
-(void)changeOrientation: (UIInterfaceOrientation )orientation;

@end

