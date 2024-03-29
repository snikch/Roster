//
//  ListUnit.h
//  Roster
//
//  Created by Mal Curtis on 10/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Unit.h"
#import "ListModel.h"

@interface ListUnit : NSManagedObject

@property(strong) Unit *unit;
@property(strong) NSSet *listModels;

-(void)generateListModels;
-(int)cost;

@end
