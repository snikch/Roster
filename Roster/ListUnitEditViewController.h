//
//  ListUnitEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 9/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListUnitOptionViewController.h"

@interface ListUnitEditViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObject *listUnit;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) ListUnitOptionViewController *optionsController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;

@end
