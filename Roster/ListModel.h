//
//  ListModel.h
//  Roster
//
//  Created by Mal Curtis on 11/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Model.h"

@interface ListModel : NSManagedObject

@property(strong) Model *model;

-(void)generateListOptions;
-(int)cost;

@end
