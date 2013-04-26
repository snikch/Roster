//
//  Wargear.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Wargear.h"

@implementation Wargear

@dynamic characteristics;
//-(NSArray*)characteristicsArray{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WargearCharacteristic" inManagedObjectContext:context];
//    [request setEntity:entity];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wargear = %@", self];
//    [request setPredicate:predicate];
//    
//    NSError *error = nil;
//    NSArray *results = [context executeFetchRequest:request error:&error];
//    if (error != nil) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return results;
//}

@end
