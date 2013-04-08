//
//  OptionGroupEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 6/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "OptionGroupEditViewController.h"

@interface OptionGroupEditViewController ()

@end

@implementation OptionGroupEditViewController

-(IBAction)didPressSave:(id)sender{
    if(_group == nil){
        _group = [NSEntityDescription insertNewObjectForEntityForName:@"OptionGroup" inManagedObjectContext:self.managedObjectContext];
        [_group setValue:_model forKey:@"model"];
    }
    
    [_group setValue:self.nameField.text forKey:@"name"];
    
    if(self.delegate){
        [self.delegate didSelectOptionGroup:_group];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if(_group){
        self.nameField = [_group valueForKey:@"name"];
    }
}

@end
