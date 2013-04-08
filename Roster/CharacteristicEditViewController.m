//
//  CharacteristicEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 4/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "CharacteristicEditViewController.h"

@interface CharacteristicEditViewController ()

@end

@implementation CharacteristicEditViewController

-(IBAction)didPressSave:(id)sender{
    [_presentedPopoverController dismissPopoverAnimated:YES];
    if(self.delegate){
        [self.delegate didEditCharacteristic:_modelCharacteristic name:self.nameField.text value:self.valueField.text];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self applyValues];
}

-(void)applyValues{
    if(_modelCharacteristic == nil) return;
    
    self.nameField.text = [_modelCharacteristic valueForKey:@"name"];
    self.valueField.text = [_modelCharacteristic valueForKey:@"value"];
}
@end
