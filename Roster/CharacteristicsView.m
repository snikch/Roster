//
//  CharacteristicsView.m
//  Roster
//
//  Created by Mal Curtis on 23/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "CharacteristicsView.h"

#define MIN_WIDTH 44.0

@implementation CharacteristicsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setCharacteristics:(NSArray *)characteristics{
    _characteristics = characteristics;
    [self redraw];
}

-(void)redraw{
    // Remove all the current subviews
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    _labels = [NSMutableArray array];
    
    int count = 0;
    int runningTotal = 0;
    
    for (NSDictionary *characteristic in _characteristics) {
        int thisWidth = MIN_WIDTH;
        NSString *name = [characteristic valueForKey:@"name"];
        NSString *value = [characteristic valueForKey:@"value"];
        CGRect frame = CGRectMake(runningTotal, 0, thisWidth, 20);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
        UIFont *font = nameLabel.font;
        
        float nameWidth = [name sizeWithFont:font].width + 16;
        float valueWidth = [value sizeWithFont:font].width + 16;
        float maxWidth = nameWidth > valueWidth ? nameWidth : valueWidth;
        
        if(maxWidth > thisWidth){
            thisWidth = maxWidth;
        }
        frame.size.width = thisWidth;
        nameLabel.frame = frame;
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(runningTotal, 20, thisWidth, 20)];
        
        nameLabel.text = name;
        valueLabel.text = value;
        
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [valueLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:nameLabel];
        [self addSubview:valueLabel];
        
        NSArray *labels = @[name, value];
        [_labels addObject:labels];
        count++;
        runningTotal += thisWidth;
    }
    CGRect viewFrame = self.frame;
    viewFrame.size.width = runningTotal;
    self.frame = viewFrame;
    
}

+(id)viewWithCharacteristics:(NSArray*)characteristics{
    int cellWidth = 44;
    CGRect frame = CGRectMake(0, 0, cellWidth*characteristics.count, 40);
    
    id view = [[CharacteristicsView alloc] initWithFrame:frame];
    
    [view setCharacteristics:characteristics];
    
    return view;
}

@end
