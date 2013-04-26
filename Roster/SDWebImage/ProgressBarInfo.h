//
//  ProgressBarInfo.h
//  SDWebImage
//
//  Created by Konstantinos Vaggelakos on 8/23/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressBarInfo : NSObject
{
    
}

@property (nonatomic, retain) UIColor *innerColor, *outerColor;
@property (assign) CGRect frame;
@property (readwrite) float innerspacing;
@property (readwrite) bool hidden;


@end
