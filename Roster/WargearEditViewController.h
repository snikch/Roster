//
//  WargearEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Wargear.h"
#import "WargearCharacteristicEditViewController.h"

@interface WargearEditViewController : UIViewController <NSFetchedResultsControllerDelegate, WargearCharacteristicDelegate>

@property (nonatomic) BOOL isNew;
@property (nonatomic) BOOL isMultiple;
@property (strong, nonatomic) NSMutableArray *selectedWargear;

@property (strong, nonatomic) Wargear *wargear;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UIButton *hiddenEditPopoverButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (strong, nonatomic) IBOutlet UITextView *infoField;

-(IBAction)didPressCancel:(id)sender;
-(IBAction)didPressSave:(id)sender;

@end
