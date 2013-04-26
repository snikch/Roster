//
//  ListUnitSummaryViewController.h
//  Roster
//
//  Created by Mal Curtis on 22/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CloseButton.h"
#import "ListUnit.h"

@interface ListUnitSummaryViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ListUnit *listUnit;

@property (strong, nonatomic) NSArray *listModels;

@property (strong, nonatomic) NSMutableDictionary *cellHeights;
@property (strong, nonatomic) NSMutableDictionary *extras;

@end
