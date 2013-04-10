//
//  ListNewViewController.m
//  Roster
//
//  Created by Mal Curtis on 9/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListNewViewController.h"

@interface ListNewViewController ()

@end

@implementation ListNewViewController

-(IBAction)didPressSave:(id)sender{
    if(self.delegate){
        [self.delegate didCreateNew:@{@"name":_nameField.text, @"info":_infoField.text}];
    }
}

@end
