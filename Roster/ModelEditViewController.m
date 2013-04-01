//
//  ModelEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ModelEditViewController.h"
#import "OptionEditViewController.h"
#import "Option.h"
#import "Unit.h"

@interface ModelEditViewController ()
-(void)applyModelValues;
-(void)commitChanges;
@end

@implementation ModelEditViewController

@synthesize nameField, costField, typeField;
@synthesize availableLabel, includedLabel, maxLabel;
@synthesize availableSlider, includedSlider, maxSlider;


#pragma mark - Lifecycle

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
    [super viewWillAppear:animated];
    [self applyModelValues];
    [self updateFetchResultsControllerPredicate];
    NSLog(@"ME will appear");
}

-(void)applyModelValues{
    nameField.text = [_model valueForKey:@"name"];
    typeField.text = [_model valueForKey:@"type"];
    costField.text = [NSString stringWithFormat:@"%i", [(NSNumber *)[_model valueForKey:@"cost"] intValue]];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newOption"]) {
        OptionEditViewController *vc = (OptionEditViewController *)[segue destinationViewController];
        
        Option *option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
        
        [option setValue:_model forKey:@"model"];
        
        [vc setOption:option];
        [vc setIsNewOption:YES];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"editOption"]) {
        OptionEditViewController *vc = (OptionEditViewController *)[segue destinationViewController];
        
        Option *option = (Option *)[[self optionsResultsController] objectAtIndexPath:[self.optionsTableView indexPathForSelectedRow]];
        NSLog(@"showing option %@ at ip %@", option, [self.optionsTableView indexPathForSelectedRow]);
        
        [vc setOption:option];
        [vc setIsNewOption:NO];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"selectWargear"]) {
        WargearSelectorViewController *vc = (WargearSelectorViewController *)[segue destinationViewController];
        
        Unit *unit = [_model valueForKey:@"unit"];
        Army *army = [unit valueForKey:@"army"];
        
        [vc setArmy:army];
        [vc setWargearDelegate:self];
        [vc setManagedObjectContext: self.managedObjectContext];
        [vc setMultiple:YES];
        [vc setSelectedWargear:_model.wargear];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self commitChanges];
    _optionsResultsController = nil;
    NSLog(@"ME will disappear");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [self.optionsResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"Option";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Options", @"Options");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *object;
        object = (NSManagedObject *)[self.optionsResultsController objectAtIndexPath:indexPath];
        
        [self.managedObjectContext deleteObject:object];
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object;
    object = [self.optionsResultsController objectAtIndexPath:indexPath];
    NSNumber * cost = [object valueForKey:@"cost"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i pts)",[[object valueForKey:@"name"] description],[cost intValue]];
}


#pragma mark - Fetched results controller

-(void)updateFetchResultsControllerPredicate{
    NSFetchRequest *fetchRequest = [self.optionsResultsController fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model == %@",_model];
    
    [fetchRequest setPredicate:predicate];
    
    [NSFetchedResultsController deleteCacheWithName:@"Models"];
    
    NSError *error;
    if (![self.optionsResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.optionsTableView reloadData];
}

- (NSFetchedResultsController *)optionsResultsController
{
    if (_optionsResultsController != nil) {
        return _optionsResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Options"];
    aFetchedResultsController.delegate = self;
    self.optionsResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.optionsResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _optionsResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.optionsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.optionsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.optionsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.optionsTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.optionsTableView endUpdates];
}

# pragma mark - Wargear Selector

-(void)didSelectWargear:(NSArray *)array{
    NSLog(@"Did select wargear! %@", array);
    NSError *error;
    
    // Clear existing wargear
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ModelWargear" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model == %@",_model];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];
    NSArray *currentObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(NSManagedObject *object in currentObjects){
        NSLog(@"Deleting wargear %@", [[object valueForKey:@"wargear"] valueForKey:@"name"]);
        [self.managedObjectContext deleteObject:object];
    }
    
    // Create new records
    for(Wargear *wargear in array){
        NSManagedObject *modelWargear = [NSEntityDescription insertNewObjectForEntityForName:@"ModelWargear" inManagedObjectContext:self.managedObjectContext];
        NSLog(@"Adding wargear %@", [wargear valueForKey:@"name"]);
        [modelWargear setValue:_model forKey:@"model"];
        [modelWargear setValue:wargear forKey:@"wargear"];
    }
    
    if (![self.optionsResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
}

@end
