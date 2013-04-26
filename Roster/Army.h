//
//  Army.h
//  Roster
//
//  Created by Mal Curtis on 29/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Army : NSManagedObject

@property (strong) NSString *name;
@property (strong) NSString *imageUrl;

@end
