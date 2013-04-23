//
//  ListSummaryViewController.h
//  Roster
//
//  Created by Mal Curtis on 20/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

#import "UIViewController+CloseButton.h"

@interface ListSummaryViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) List *list;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
