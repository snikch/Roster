//
//  ListUnitOptionViewController.h
//  Roster
//
//  Created by Mal Curtis on 11/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListUnitOptionViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObject *listUnit;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
