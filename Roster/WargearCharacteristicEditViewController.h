//
//  WargearCharacteristicEditViewController.h
//  Roster
//
//  Created by Mal Curtis on 7/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WargearCharacteristicDelegate <NSObject>

-(void)didChangeWargearCharacteristic:(NSManagedObject*)characteristic toValues:(NSDictionary*)values;

@end

@interface WargearCharacteristicEditViewController : UIViewController

@property (strong, nonatomic) NSManagedObject *wargearCharacteristic;

@property (strong, nonatomic) id <WargearCharacteristicDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *valueField;
@property (strong, nonatomic) IBOutlet UISwitch *modifySwitch;

-(IBAction)didPressSave:(id)sender;

@end
