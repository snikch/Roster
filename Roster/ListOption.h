//
//  ListOption.h
//  Roster
//
//  Created by Mal Curtis on 24/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Option.h"

@interface ListOption : NSManagedObject

@property (strong) NSNumber *count;
@property (strong) Option *option;

@end
