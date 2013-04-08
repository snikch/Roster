//
//  CharacteristicsSelectorEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 2/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomKeyboard.h"
#import "CharacteristicsSelectorListViewController.h"

@interface CharacteristicsSelectorEditViewController : UITableViewController <NSFetchedResultsControllerDelegate, CustomKeyboardDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id <CharacteristicsSelectorDelegate> delegate;

@property (strong, nonatomic) UIPopoverController *presentingPopoverController;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) CustomKeyboard *customKeyboard;
@property (strong, nonatomic) UITextField *currentTextField;

-(IBAction)didPressSave:(id)sender;

@end
