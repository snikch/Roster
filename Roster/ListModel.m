//
//  ListModel.m
//  Roster
//
//  Created by Mal Curtis on 11/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

-(void)generateListOptions{
    for(NSManagedObject *option in (NSSet*)[(NSManagedObject*)[self valueForKey:@"model"] valueForKey:@"options"]){
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"ListOption" inManagedObjectContext:self.managedObjectContext];
        [object setValue:option forKey:@"option"];
        [object setValue:self forKey:@"listModel"];
    }
}

@end
