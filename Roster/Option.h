//
//  Option.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Wargear.h"

@interface Option : NSManagedObject

@property (strong) Wargear *wargear;

-(NSMutableArray*)replacesWargear;
-(void)replacesWargear:(NSManagedObject*)wargear;
-(void)addToGroup:(NSManagedObject*)group;

@end
