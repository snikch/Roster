//
//  WargearEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "WargearEditViewController.h"
#import "WargearSelectorViewController.h"

@interface WargearEditViewController ()

@end

@implementation WargearEditViewController

@synthesize nameField, characteristicsField;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self applyModelValues];
}

-(void)applyModelValues{
    nameField.text = [_wargear valueForKey:@"name"];
    characteristicsField.text = [_wargear valueForKey:@"characteristics"];
    }

-(void)commitChanges{
    [_wargear setValue:nameField.text forKey:@"name"];
    [_wargear setValue:characteristicsField.text forKey:@"characteristics"];
}

-(IBAction)didPressCancel:(id)sender{
    if(self.isNew){
        [self.managedObjectContext deleteObject:_wargear];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)didPressSave:(id)sender{
    [self commitChanges];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if(![self.selectedWargear containsObject:self.wargear]){
        [self.selectedWargear addObject:self.wargear];
    }
    
    if(self.isNew){
        if(self.isMultiple == YES){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            WargearSelectorViewController *vc = (WargearSelectorViewController *) self.navigationController;
            [vc didSelectWargear:@[self.wargear]];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
