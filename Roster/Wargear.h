//
//  Wargear.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Wargear : NSManagedObject

@property (strong) NSSet *characteristics;
@property (strong) NSString *name;
@property (strong) NSString *info;
@property (strong) NSString *abbreviation;
@property (strong) NSNumber *footnote;

@end
