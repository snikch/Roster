//
//  Model.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "Model.h"

@implementation Model

@dynamic name;

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
-(void)addMultipleWargear:(NSArray*)wargears{
    for (Wargear *wargear in wargears) {
        [self addWargear:wargear];
    }
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

-(NSArray*)characteristicsWithOption:(Option*)option{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ModelCharacteristic" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model = %@", self];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
    [request setSortDescriptors:@[sort]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSMutableArray *characteristics = [NSMutableArray array];
    for (NSManagedObject *characteristic in results) {
        [characteristics addObject:[characteristic dictionaryWithValuesForKeys:@[@"name", @"value"]]];
    }
    
    if(option != nil && option.wargear != nil){
        for (NSManagedObject *wargearCharacteristic in option.wargear.characteristics) {
            // Loop through characteristics and apply differences
            BOOL replaced = false;
            NSString *name;
            NSString *wargearName;
            for (NSManagedObject *characteristic in characteristics) {
                name = (NSString*)[characteristic valueForKey:@"name"];
                wargearName = (NSString*)[wargearCharacteristic valueForKey:@"name"];
                if( [wargearName isEqualToString:name]){
                    replaced = true;
                    if([(NSNumber*)[wargearCharacteristic valueForKey:@"modify"] boolValue]){
                        [characteristic setValue:[wargearCharacteristic valueForKey:@"value"] forKey:@"value"];
                    }else{
                        [characteristic setValue:[wargearCharacteristic valueForKey:@"value"] forKey:@"value"];
                    }
                    
                }
            }
        }
    }
    return characteristics;
}
@end
