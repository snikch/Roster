//
//  List.m
//  Roster
//
//  Created by Mal Curtis on 15/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "List.h"
#import "ListUnit.h"

@implementation List

-(int)cost{
    int runningCost = 0;
    
    for (ListUnit *listUnit in (NSSet*)[self valueForKey:@"listUnits"]) {
        runningCost += [listUnit cost];
    }
    return runningCost;
}

@end
