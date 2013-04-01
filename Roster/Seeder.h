//
//  Seeder.h
//  Roster
//
//  Created by Mal Curtis on 1/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seeder : NSObject

+(void)insertSeedData:(NSManagedObjectContext *)context;

@end
