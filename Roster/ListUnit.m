//
//  ListUnit.m
//  Roster
//
//  Created by Mal Curtis on 10/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListUnit.h"
#import "ListModel.h"

@implementation ListUnit

-(void)generateListModels{
    for(NSManagedObject *model in (NSSet*)[(NSManagedObject*)[self valueForKey:@"unit"] valueForKey:@"models"]){
        ListModel *object = (ListModel*)[NSEntityDescription insertNewObjectForEntityForName:@"ListModel" inManagedObjectContext:self.managedObjectContext];
        [object setValue:model forKey:@"model"];
        [object setValue:self forKey:@"listUnit"];
        NSLog(@"Created list model: %@", object);
        [object generateListOptions];
        [object setValue:(NSNumber*)[model valueForKey:@"included"] forKey:@"count"];
    }
}


@end
