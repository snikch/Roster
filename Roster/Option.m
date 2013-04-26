//
//  Option.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Option.h"

@implementation Option

@dynamic wargear;
@dynamic name;
@dynamic cost;

-(NSMutableArray*)replacesWargear{
    NSMutableArray *wargearArray = [NSMutableArray array];
    for(NSManagedObject *object in [(NSSet*)[self valueForKey:@"replacements"] allObjects]){
        NSLog(@"Adding to object %@ modelWargear: %@", object, [object valueForKey:@"modelWargear"]);
        [wargearArray addObject:(NSManagedObject*)[object valueForKey:@"modelWargear"]];
    }
    return wargearArray;
}

-(void)replacesWargear:(NSManagedObject*)wargear{
    NSManagedObjectContext *context = [wargear managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ModelWargear" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model = %@ AND wargear = %@", [self valueForKey:@"model"], wargear];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if(results.count == 0){ return; }
    
    NSManagedObject *modelWargear = (NSManagedObject*)[results objectAtIndex:0];
    NSManagedObject *replacement = [NSEntityDescription insertNewObjectForEntityForName:@"OptionReplacement" inManagedObjectContext:context];
    [replacement setValuesForKeysWithDictionary:@{@"modelWargear": modelWargear, @"option": self}];
    
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)addToGroup:(NSManagedObject *)group{
    [self setValue:group forKey:@"group"];
}

@end
