//
//  Model.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Wargear.h"

@interface Model : NSManagedObject

-(NSMutableArray*)wargear;
-(void)addWargear:(Wargear*)wargear;
-(void)addCharacteristics:(NSArray*)characteristics;

@end
