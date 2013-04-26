//
//  DDProgressView.h
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DDProgressView : UIView
{
@private
	float progress ;
	UIColor *innerColor ;
	UIColor *outerColor ;
    UIColor *emptyColor ;
    float innerSpacing;
}

@property (nonatomic,retain) UIColor *innerColor ;
@property (nonatomic,retain) UIColor *outerColor ;
@property (nonatomic,retain) UIColor *emptyColor ;
@property (nonatomic,assign) float progress ;
@property (nonatomic,assign) float innerSpacing ;


- (id)initWithFrame:(CGRect)frame innerSpacing:(float)space;

@end
