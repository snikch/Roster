//
//  WargearListViewController.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Army.h"

@interface WargearListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Army *army;
@property (nonatomic) BOOL multiple;
@property (strong, nonatomic) NSMutableArray *selectedWargear;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
