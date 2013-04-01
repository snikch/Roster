//
//  Seeder.m
//  Roster
//
//  Created by Mal Curtis on 1/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Seeder.h"

#import "Army.h"
#import "Unit.h"
#import "Model.h"
#import "Wargear.h"

@implementation Seeder

+(void)insertSeedData:(NSManagedObjectContext *)context{
    Army *army = [NSEntityDescription insertNewObjectForEntityForName:@"Army" inManagedObjectContext:context];
    [army setValue:@"Space Marines" forKey:@"name"];
    
    Unit *unit = [NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:context];
    [unit setValue:army forKey:@"army"];
    [unit setValue:@"Terminator Squad" forKey:@"name"];
    
    Model *captain = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
    [captain setValue:unit forKey:@"unit"];
    [captain setValue:@"Terminator Captain" forKey:@"name"];
    [captain setValue:[NSNumber numberWithInt:25] forKey:@"cost"];
    
    
    Model *terminator  = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
    [terminator setValue:unit forKey:@"unit"];
    [terminator setValue:@"Terminator" forKey:@"name"];
    [terminator setValue:[NSNumber numberWithInt:20] forKey:@"cost"];
    
    Wargear *flamer = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:context];
    [flamer setValue:army forKey:@"army"];
    [flamer setValue:@"flamer" forKey:@"name"];
    
    Wargear *bolter = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:context];
    [bolter setValue:army forKey:@"army"];
    [bolter setValue:@"bolter" forKey:@"name"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}
@end
