//
//  List.h
//  Roster
//
//  Created by Mal Curtis on 15/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Army.h"

@interface List : NSManagedObject

@property (strong) NSString *name;
@property (strong) Army *army;

-(int)cost;

@end
