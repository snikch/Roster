//
//  WargearSelectorViewController.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Army.h"
#import "Wargear.h"

@protocol WargearSelectorDelegate <NSObject>

-(void)didSelectWargear:(NSArray *)wargear;

@end


@interface WargearSelectorViewController : UINavigationController

@property (strong, nonatomic) Army *army;
@property (strong, nonatomic) NSMutableArray *selectedWargear;

@property (nonatomic) BOOL multiple;

@property (weak, nonatomic) id <WargearSelectorDelegate> wargearDelegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)didSelectWargear:(NSArray *)wargear;

@end
