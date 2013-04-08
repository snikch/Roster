//
//  OptionGroupListViewController.h
//  Roster
//
//  Created by Mal Curtis on 6/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@protocol OptionGroupSelectorDelegate <NSObject>

-(void)didSelectOptionGroup:(NSManagedObject *)group;

@end

@interface OptionGroupListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSManagedObject *group;

@property (weak, nonatomic) id <OptionGroupSelectorDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end
