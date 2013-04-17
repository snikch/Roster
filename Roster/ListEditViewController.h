//
//  ListEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 9/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UnitListViewController.h"

@interface ListEditViewController : UIViewController <UnitListDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *infoField;

@property (strong, nonatomic) NSManagedObject *list;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
