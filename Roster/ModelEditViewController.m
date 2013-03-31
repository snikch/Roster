//
//  ModelEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ModelEditViewController.h"

@interface ModelEditViewController ()
-(void)applyModelValues;
-(void)commitChanges;
@end

@implementation ModelEditViewController

@synthesize nameField, costField, typeField;
@synthesize availableLabel, includedLabel, maxLabel;
@synthesize availableSlider, includedSlider, maxSlider;

-(void)viewDidLoad{
    [availableSlider
     addTarget:self
     action:@selector(availableSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
    
    [includedSlider
     addTarget:self
     action:@selector(includedSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
    
    [maxSlider
     addTarget:self
     action:@selector(maxSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
}

-(IBAction)availableSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    NSLog(@"Available did change to %i", value);
    availableLabel.text = [NSString stringWithFormat:@"%i", value];
}
-(IBAction)includedSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    includedLabel.text = [NSString stringWithFormat:@"%i", value];
}
-(IBAction)maxSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    maxLabel.text = [NSString stringWithFormat:@"%i", value];
}

-(void)viewWillAppear:(BOOL)animated{
    [self applyModelValues];
}

-(void)applyModelValues{
    nameField.text = [_model valueForKey:@"name"];
    typeField.text = [_model valueForKey:@"type"];
    
    availableLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_model valueForKey:@"available"] intValue]];
    includedLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_model valueForKey:@"included"] intValue]];
    maxLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_model valueForKey:@"max"] intValue]];
    
    [availableSlider setValue:[(NSNumber *)[_model valueForKey:@"available"] floatValue]];
    [includedSlider setValue:[(NSNumber *)[_model valueForKey:@"included"] floatValue]];
    [maxSlider setValue:[(NSNumber *)[_model valueForKey:@"max"] floatValue]];
}

-(void)commitChanges{    
    [_model setValue:nameField.text forKey:@"name"];
    [_model setValue:typeField.text forKey:@"type"];
    
    [_model setValue:[NSNumber numberWithInt:(int)(availableSlider.value + 0.5)] forKey:@"available"];
    [_model setValue:[NSNumber numberWithInt:(int)(includedSlider.value + 0.5)] forKey:@"included"];
    [_model setValue:[NSNumber numberWithInt:(int)(maxSlider.value + 0.5)] forKey:@"max"];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [_model setValue:[f numberFromString:costField.text] forKey:@"cost"];
}

-(IBAction)didPressCancel:(id)sender{
    if(self.isNewModel){
        [self.managedObjectContext deleteObject:_model];
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
