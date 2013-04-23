//
//  CharacteristicsView.h
//  Roster
//
//  Created by Mal Curtis on 23/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacteristicsView : UIView

@property (strong, nonatomic) NSArray *characteristics;
@property (strong, nonatomic) NSMutableArray *labels;

+(id)viewWithCharacteristics:(NSArray*)characteristics;

@end
