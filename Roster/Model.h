//
//  Model.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Wargear.h"
#import "Unit.h"
#import "Option.h"

@interface Model : NSManagedObject

@property (strong) NSString *name;
@property (strong) NSNumber *cost;
@property (strong) NSNumber *included;
@property (strong) NSNumber *max;
@property (strong) NSNumber *available;
@property (strong) Unit *unit;

-(NSMutableArray*)wargear;
-(void)addWargear:(Wargear*)wargear;
-(void)addMultipleWargear:(NSArray*)wargears;
-(void)addCharacteristics:(NSArray*)characteristics;
-(NSArray*)characteristicsWithOption:(Option*)option;

@end
