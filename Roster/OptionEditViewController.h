//
//  OptionEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Option.h"

#import "WargearSelectorViewController.h"
#import "OptionGroupListViewController.h"

@interface OptionEditViewController : UIViewController <WargearSelectorDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, OptionGroupSelectorDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isNewOption;
@property (strong, nonatomic) NSMutableArray *selectedWargear;

@property (strong, nonatomic) Option *option;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *costField;
@property (strong, nonatomic) IBOutlet UISwitch *isUnitSwitch;
@property (strong, nonatomic) IBOutlet UITextView *infoView;

@property (strong, nonatomic) IBOutlet UILabel *wargearLabel;
@property (strong, nonatomic) IBOutlet UILabel *availableLabel;
@property (strong, nonatomic) IBOutlet UILabel *limitLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;

@property (strong, nonatomic) IBOutlet UISlider *availableSlider;
@property (strong, nonatomic) IBOutlet UISlider *limitSlider;

-(IBAction)didPressCancel:(id)sender;
-(IBAction)didPressSave:(id)sender;
-(IBAction)didPressRemoveWargear:(id)sender;
-(IBAction)didPressRemoveGroup:(id)sender;


@end
