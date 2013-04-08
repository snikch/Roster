//
//  ModelCharacteristicsViewController.h
//  Roster
//
//  Created by Mal Curtis on 4/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model.h"

@protocol ModelCharacteristicsDelegate <NSObject>

-(void)displayCharacteristics:(NSManagedObject*)modelCharacteristics atRect:(CGRect)rect;

@end

@interface ModelCharacteristicsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Model *model;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) id <ModelCharacteristicsDelegate> delegate;

@end
