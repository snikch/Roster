//
//  ArmyEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 29/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Army.h"

@interface ArmyEditViewController : UITableViewController <UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Army *army;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addUnitButton;


@end
