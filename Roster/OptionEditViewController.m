//
//  OptionEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "OptionEditViewController.h"

#import "Army.h"
#import "Unit.h"
#import "Model.h"

@interface OptionEditViewController ()

-(void)applyValues;
-(void)commitChanges;
@end

@implementation OptionEditViewController

@synthesize nameField, costField;
@synthesize availableLabel;
@synthesize availableSlider;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"selectWargear"]) {
        WargearSelectorViewController *vc = (WargearSelectorViewController *)[segue destinationViewController];
        
        Model *model = [_option valueForKey:@"model"];
        Unit *unit = [model valueForKey:@"unit"];
        Army *army = [unit valueForKey:@"army"];
        
        [vc setArmy:army];
        [vc setWargearDelegate:self];
        [vc setManagedObjectContext: self.managedObjectContext];
        [vc setMultiple:NO];
        NSMutableArray *wargearArray = [NSMutableArray array];
        Wargear *wargear = (Wargear *)[_option valueForKey:@"wargear"];
        if(wargear != nil){
            [wargearArray addObject:wargear];
        }
        NSLog(@"Loading wargear selector with wargear: %@", wargearArray);
        [vc setSelectedWargear:wargearArray];
    }
}


-(void)didSelectWargear:(NSArray *)array{
    NSLog(@"Did select wargear! %@", array);
    if(array.count > 0){
        [_option setValue:[array objectAtIndex:0] forKey:@"wargear"];
    }else{
        [_option setValue:nil forKey:@"wargear"];
    }
}

-(void)viewDidLoad{
    [availableSlider
     addTarget:self
     action:@selector(availableSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
}

-(IBAction)availableSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    NSLog(@"Available did change to %i", value);
    availableLabel.text = [NSString stringWithFormat:@"%i", value];
}

-(void)viewWillAppear:(BOOL)animated{
    [self applyModelValues];
}

-(void)applyModelValues{
    nameField.text = [_option valueForKey:@"name"];
    
    availableLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_option valueForKey:@"available"] intValue]];
    
    [availableSlider setValue:[(NSNumber *)[_option valueForKey:@"available"] floatValue]];
}

-(void)commitChanges{
    [_option setValue:nameField.text forKey:@"name"];
    
    [_option setValue:[NSNumber numberWithInt:(int)(availableSlider.value + 0.5)] forKey:@"available"];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [_option setValue:[f numberFromString:costField.text] forKey:@"cost"];
}

-(IBAction)didPressCancel:(id)sender{
    if(self.isNewOption){
        [self.managedObjectContext deleteObject:_option];
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
