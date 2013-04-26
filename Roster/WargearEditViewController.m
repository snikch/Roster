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

@property (weak, nonatomic) UIPopoverController *characteristicPopoverController;

@end

@implementation WargearEditViewController

@synthesize nameField, typeField, infoField;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WargearCharacteristicEditViewController *vc = (WargearCharacteristicEditViewController *)[segue destinationViewController];
    vc.delegate = self;
    _characteristicPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
    if ([[segue identifier] isEqualToString:@"editCharacteristic"]) {
        
        //        Wargear *wargear = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:self.managedObjectContext];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSManagedObject *object = (NSManagedObject *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
                
        [vc setWargearCharacteristic:object];
        
        UITableViewCell *cell = (UITableViewCell*)sender;
        CGRect displayFrom = CGRectMake(self.tableView.frame.origin.x + cell.frame.size.width, cell.center.y + self.tableView.frame.origin.y - self.tableView.contentOffset.y, 1, 1);
        _hiddenEditPopoverButton.frame = displayFrom;
        
    }else if ([[segue identifier] isEqualToString:@"addCharacteristic"]) {
       
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self applyModelValues];
    self.title = @"Edit Wargear";
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fetchedResultsController = nil;
}

-(void)applyModelValues{
    NSLog(@"Applying wargear values for: %@", [_wargear valueForKey:@"name"]);
    nameField.text = [_wargear valueForKey:@"name"];
    infoField.text = [_wargear valueForKey:@"info"];
    typeField.text = [_wargear valueForKey:@"type"];
}

-(void)commitChanges{
    [_wargear setValue:nameField.text forKey:@"name"];
    [_wargear setValue:typeField.text forKey:@"type"];
    [_wargear setValue:infoField.text forKey:@"info"];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"%d rows in section", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Char" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Characteristics", @"Characteristics");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WargearCharacteristic" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wargear == %@",self.wargear];
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
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
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if([(NSNumber*)[object valueForKey:@"modify"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        cell.textLabel.text = [NSString stringWithFormat:@"Modify %@: %@", [object valueForKey:@"name"], [object valueForKey:@"value"]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [object valueForKey:@"name"], [object valueForKey:@"value"]];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"editCharacteristic" sender:[tableView cellForRowAtIndexPath:indexPath]];

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

# pragma  mark - Wargear Characteristic Delegate

-(void)didChangeWargearCharacteristic:(NSManagedObject *)characteristic toValues:(NSDictionary *)values{
    NSLog(@"Did change wargear chars: %@", values);
    if(characteristic == nil){
        characteristic = [NSEntityDescription insertNewObjectForEntityForName:@"WargearCharacteristic" inManagedObjectContext:self.managedObjectContext];
        [characteristic setValue:_wargear forKey:@"wargear"];
//        NSMutableSet *characteristics = [NSMutableSet setWithSet:[_wargear mutableSetValueForKey:@"characteristics"]];
//        NSLog(@"Characteristics: %@", characteristics);
//        [characteristics addObject:characteristic];
//        NSLog(@"Characteristics: %@", characteristics);
//
//        [_wargear setValue:characteristics forKey:@"characteristics"];
    }
    NSLog(@"Did create characteristic");
    [characteristic setValuesForKeysWithDictionary:values];
    [characteristic setValue:[NSNumber numberWithBool:[[NSNumber numberWithBool:YES] isEqualToNumber:(NSNumber*)[values valueForKey:@"modify"]]] forKey:@"modify"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
    if(_characteristicPopoverController){
        [_characteristicPopoverController dismissPopoverAnimated:YES];
    }
}

@end