//
//  ListPointsSummaryViewController.h
//  Roster
//
//  Created by Mal Curtis on 22/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CloseButton.h"
#import "List.h"

@interface ListPointsSummaryViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) List *list;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSMutableDictionary *cellHeights;
@property (strong, nonatomic) NSMutableDictionary *extras;
@end
