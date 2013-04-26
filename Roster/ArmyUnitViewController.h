//
//  ArmyEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 29/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ImagePicker.h"

#import "Army.h"

@interface ArmyUnitViewController : UIViewController <UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Army *army;

@property (nonatomic, retain) UIPopoverController *imagePopoverController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addUnitButton;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

-(IBAction)didPressAddImage:(id)sender;

@end
