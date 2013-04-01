//
//  Model.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Model.h"
#import "Wargear.h"

@implementation Model

-(NSMutableArray*)wargear{
    NSMutableArray *wargearArray = [NSMutableArray array];
    for(NSManagedObject *object in [(NSSet*)[self valueForKey:@"modelWargear"] allObjects]){
        [wargearArray addObject:(Wargear*)[object valueForKey:@"wargear"]];
    }
    return wargearArray;
}
@end
