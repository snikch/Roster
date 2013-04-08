//
//  UnitEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 29/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Unit.h"

@interface UnitEditViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *modelsResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Unit *unit;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *costField;
@property (strong, nonatomic) IBOutlet UITextField *classificationField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (strong, nonatomic) IBOutlet UITextView *infoField;

-(void)setUnit:(Unit *)unit;

-(IBAction)didPressAddModel:(id)sender;
-(IBAction)didPressAddOption:(id)sender;

@end
