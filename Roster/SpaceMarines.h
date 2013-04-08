//
//  SpaceMarines.h
//  Roster
//
//  Created by Mal Curtis on 6/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Army.h"

@interface SpaceMarines : NSObject

@property (strong, nonatomic) Army *army;
@property (strong, nonatomic) NSMutableDictionary *wargear;
@property (strong, nonatomic) NSMutableDictionary *elites;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)seed;

@end
