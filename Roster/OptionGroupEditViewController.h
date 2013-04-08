//
//  OptionGroupEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 6/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "OptionGroupListViewController.h"

@interface OptionGroupEditViewController : UIViewController


@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSManagedObject *group;

@property (weak, nonatomic) id <OptionGroupSelectorDelegate> delegate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

-(IBAction)didPressSave:(id)sender;

@end
