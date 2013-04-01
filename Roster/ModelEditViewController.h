//
//  ModelEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model.h"
#import "WargearSelectorViewController.h"

@interface ModelEditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, WargearSelectorDelegate>

@property (nonatomic) BOOL isNewModel;

@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *optionsResultsController;

@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) IBOutlet UITableView *characteristicsTableView;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *costField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;

@property (strong, nonatomic) IBOutlet UILabel *availableLabel;
@property (strong, nonatomic) IBOutlet UILabel *includedLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxLabel;

@property (strong, nonatomic) IBOutlet UISlider *availableSlider;
@property (strong, nonatomic) IBOutlet UISlider *includedSlider;
@property (strong, nonatomic) IBOutlet UISlider *maxSlider;

-(IBAction)didPressCancel:(id)sender;
-(IBAction)didPressSave:(id)sender;

@end
