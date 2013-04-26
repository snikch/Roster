//
//  ListModel.m
//  Roster
//
//  Created by Mal Curtis on 11/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

@dynamic model;
@dynamic count;
@dynamic listOptions;

-(void)generateListOptions{
    for(NSManagedObject *option in (NSSet*)[(NSManagedObject*)[self valueForKey:@"model"] valueForKey:@"options"]){
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"ListOption" inManagedObjectContext:self.managedObjectContext];
        [object setValue:option forKey:@"option"];
        [object setValue:self forKey:@"listModel"];
    }
}

-(int)cost{
    int runningCost = 0;
    int numModels = [(NSNumber*)[self valueForKey:@"count"] integerValue];
    
    NSManagedObject *model = (NSManagedObject*)[self valueForKey:@"model"];
    int numIncludedModels = [(NSNumber*)[model valueForKey:@"included"] integerValue];
    int modelCost = [(NSNumber*)[model valueForKey:@"cost"] integerValue];
    
    if(numModels > numIncludedModels){
        runningCost += (numModels - numIncludedModels) * modelCost;
    }
    
    for (NSManagedObject *listOption in (NSSet*)[self valueForKey:@"listOptions"]) {
        NSManagedObject *option = (NSManagedObject*)[listOption valueForKey:@"option"];
        int optionCost = [(NSNumber*)[option valueForKey:@"cost"] integerValue];
        int optionCount = [(NSNumber*)[listOption valueForKey:@"count"] integerValue];
        if (optionCount > 0){
            runningCost += optionCount * optionCost;
        }
    }
    return runningCost;
}
@end
