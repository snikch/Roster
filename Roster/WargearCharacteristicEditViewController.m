//
//  WargearCharacteristicEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 7/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "WargearCharacteristicEditViewController.h"

@interface WargearCharacteristicEditViewController ()

@end

@implementation WargearCharacteristicEditViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self applyValues];
}

-(void)applyValues{
    if(_wargearCharacteristic){
        _nameField.text = [_wargearCharacteristic valueForKey:@"name"];
        _valueField.text = [_wargearCharacteristic valueForKey:@"value"];
        [_modifySwitch setOn:(BOOL)[_wargearCharacteristic valueForKey:@"modify"] animated:NO];
    }
}

-(IBAction)didPressSave:(id)sender{
    if(self.delegate){
        [self.delegate
         didChangeWargearCharacteristic:_wargearCharacteristic
         toValues:@{@"name": _nameField.text, @"value": _valueField.text, @"modify": [NSNumber numberWithBool:_modifySwitch.on]}
         ];
    }
}

@end
