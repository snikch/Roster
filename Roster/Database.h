//
//  Database.h
//  Roster
//
//  Created by Mal Curtis on 20/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)reset;

+(Database*)database;
+(NSManagedObjectContext*)context;

@end
