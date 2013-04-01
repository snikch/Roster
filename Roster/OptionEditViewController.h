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

@interface OptionEditViewController : UIViewController <WargearSelectorDelegate>

@property (nonatomic) BOOL isNewOption;

@property (strong, nonatomic) Option *option;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *costField;
@property (strong, nonatomic) IBOutlet UISwitch *isUnitSwitch;

@property (strong, nonatomic) IBOutlet UILabel *wargearLabel;
@property (strong, nonatomic) IBOutlet UILabel *availableLabel;

@property (strong, nonatomic) IBOutlet UISlider *availableSlider;

-(IBAction)didPressCancel:(id)sender;
-(IBAction)didPressSave:(id)sender;


@end
