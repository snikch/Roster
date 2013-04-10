//
//  ArmyListViewController.h
//  Roster
//
//  Created by Mal Curtis on 7/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListNewViewController.h"
#import "ListEditViewController.h"
#import "Army.h"

@interface ArmyListViewController : UITableViewController <NSFetchedResultsControllerDelegate, ListNewDelegate>

@property (strong, nonatomic) Army *army;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editArmyButton;

@end
