//
//  Model.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Model.h"

@implementation Model

-(NSMutableArray*)wargear{
    NSMutableArray *wargearArray = [NSMutableArray array];
    for(NSManagedObject *object in [(NSSet*)[self valueForKey:@"modelWargear"] allObjects]){
        NSLog(@"Adding to wargear array: %@", object);
        [wargearArray addObject:(Wargear*)[object valueForKey:@"wargear"]];
    }
    return wargearArray;
}

-(void)addWargear:(Wargear *)wargear{
    NSManagedObject *modelWargear = [NSEntityDescription insertNewObjectForEntityForName:@"ModelWargear" inManagedObjectContext:self.managedObjectContext];
    [modelWargear setValue:wargear forKey:@"wargear"];
    [modelWargear setValue:self forKey:@"model"];
}

-(void)addCharacteristics:(NSArray*)characteristics{
    int count = 0;
    NSManagedObjectContext *context = [self managedObjectContext];
    for( NSArray *details in characteristics){
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"ModelCharacteristic" inManagedObjectContext:context];
        NSLog(@"Setting model char for %@ in %@", characteristics, self);
        [object setValuesForKeysWithDictionary:@{@"name": [details objectAtIndex:0], @"value": (NSString*)[details objectAtIndex:1], @"sortOrder": [NSNumber numberWithInt:count], @"model": self}];
        count++;
    }
    NSError *error;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
@end
