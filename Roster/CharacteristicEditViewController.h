//
//  CharacteristicEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 4/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CharacteristicEditDelegate <NSObject>

-(void)didEditCharacteristic:(NSManagedObject*)modelCharacteristic name:(NSString*)name value:(NSString*)value;
@end

@interface CharacteristicEditViewController : UIViewController

@property (strong, nonatomic) NSManagedObject *modelCharacteristic;
@property (strong, nonatomic) UIPopoverController *presentedPopoverController;
@property (strong, nonatomic) id <CharacteristicEditDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *valueField;

-(IBAction)didPressSave:(id)sender;

@end
