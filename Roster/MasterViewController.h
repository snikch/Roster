//
//  MasterViewController.h
//  Roster
//
//  Created by Mal Curtis on 28/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ArmyListViewController.h"

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ArmyListViewController *armyListViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(IBAction)didPressAdd:(id)sender;

@end
