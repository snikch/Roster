//
//  CharacteristicsView.m
//  Roster
//
//  Created by Mal Curtis on 23/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "CharacteristicsView.h"

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
    int cellWidth = 44;
    
    for (NSDictionary *characteristic in _characteristics) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(count*cellWidth, 0, cellWidth, 20)];
        UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(count*cellWidth, 20, cellWidth, 20)];
        
        name.text = [characteristic valueForKey:@"name"];
        value.text = [characteristic valueForKey:@"value"];
        
        [name setTextAlignment:NSTextAlignmentCenter];
        [value setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:name];
        [self addSubview:value];
        
        NSArray *labels = @[name, value];
        [_labels addObject:labels];
        count++;
    }
}

+(id)viewWithCharacteristics:(NSArray*)characteristics{
    int cellWidth = 44;
    CGRect frame = CGRectMake(0, 0, cellWidth*characteristics.count, 40);
    
    id view = [[CharacteristicsView alloc] initWithFrame:frame];
    
    [view setCharacteristics:characteristics];
    
    return view;
}

@end
