//
//  ListUnit.h
//  Roster
//
//  Created by Mal Curtis on 10/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ListUnit : NSManagedObject

-(void)generateListModels;
-(int)cost;

@end
