//
//  Seeder.m
//  Roster
//
//  Created by Mal Curtis on 1/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Seeder.h"

#import "SpaceMarines.h"

@implementation Seeder

+(void)insertSeedData:(NSManagedObjectContext *)context{
    int count = 0;
    for(NSString *name in @[@"WS", @"BS", @"S", @"T", @"W", @"I", @"A", @"Ld", @"Sv"]){
        count++;
        NSLog(@"Inserting char template named: %@", name);
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Infantry" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    count = 0;
    for(NSString *name in @[@"WS", @"BS", @"S", @"F", @"S", @"R", @"I", @"A"]){
        count++;
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Vehicle (Walker)" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    count = 0;
    for(NSString *name in @[@"BS", @"F", @"S", @"R"]){
        count++;
        NSManagedObject *characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"CharacteristicTemplate" inManagedObjectContext:context];
        [characteristic setValue:name forKey:@"name"];
        [characteristic setValue:@"Vehicle" forKey:@"type"];
        [characteristic setValue:[NSNumber numberWithFloat:count] forKey:@"sortOrder"];
    }
    
    SpaceMarines *sp = [[SpaceMarines alloc] init];
    sp.managedObjectContext = context;
    [sp seed];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}
@end
