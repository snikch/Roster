//
//  UnitListViewController.h
//  Roster
//
//  Created by Mal Curtis on 9/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UnitListDelegate <NSObject>

-(void)didSelectUnit:(NSManagedObject*)unit;

@end

@interface UnitListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObject *army;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id <UnitListDelegate> delegate;

@end
