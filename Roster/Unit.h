//
//  Unit.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Army.h"

@interface Unit : NSManagedObject

@property (strong) NSString *name;
@property (strong) NSString *imageUrl;
@property (strong) NSNumber *cost;
@property (strong) NSString *classification;

@property (strong) Army *army;

@end
