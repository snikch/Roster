//
//  ListUnitOptionViewController.m
//  Roster
//
//  Created by Mal Curtis on 11/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListUnitOptionViewController.h"

@interface ListUnitOptionViewController ()

@end

@implementation ListUnitOptionViewController


-(void)viewWillDisappear:(BOOL)animated{
    _fetchedResultsController = nil;
    [self commitChanges];
    [super viewWillDisappear:animated];
}

-(void)commitChanges{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListOption" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listModel.listUnit == %@",self.listUnit];
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"listModel.model.name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"listModel.model.name" cacheName:@"Master"];
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
    NSManagedObject *listOption = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObject *option = (NSManagedObject *)[listOption valueForKey:@"option"];
    UILabel *label = (UILabel*)[cell viewWithTag:101];
    label.text = [NSString stringWithFormat:@"%@ (%i pts)",[option valueForKey:@"name"], [(NSNumber*)[option valueForKey:@"cost"] integerValue]];
    
    UISlider *slider = (UISlider*)[cell viewWithTag:102];
    [slider addTarget:self action:@selector(didChangeSlider:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(didFinishChangingSlider:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(didFinishChangingSlider:) forControlEvents:UIControlEventTouchUpOutside];
    slider.minimumValue = 0.0f;
    slider.maximumValue = [(NSNumber*)[option valueForKey:@"max"] floatValue];
    
    UILabel *valueLabel = (UILabel*)[cell viewWithTag:103];
    NSNumber *value = (NSNumber*)[listOption valueForKey:@"count"];
    [slider setValue:[value floatValue] animated:NO];
    valueLabel.text = [NSString stringWithFormat:@"%i", [value integerValue]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

# pragma mark - Touch Events
-(void)didChangeSlider:(UISlider*)sender{
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    //    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:hitIndex];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:hitIndex];
    
    int value = (int)(sender.value+0.5);
    NSLog(@"Did change slider to %i", value);
    UILabel *label = (UILabel*)[cell viewWithTag:103];
    NSString *textValue = [NSString stringWithFormat:@"%i", value];
    label.text = textValue;
}

-(void)didFinishChangingSlider:(UISlider*)sender{
    NSLog(@"Did finish changing slider");
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    NSManagedObject *listOption = [self.fetchedResultsController objectAtIndexPath:hitIndex];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:hitIndex];
    UISlider *slider = (UISlider*)[cell viewWithTag:102];
    NSManagedObject *option = (NSManagedObject*)[listOption valueForKey:@"option"];
    NSManagedObject *groupMembership = (NSManagedObject*)[option valueForKey:@"groupMembership"];
    NSManagedObject *group = (NSManagedObject*)[groupMembership valueForKey:@"group"];
    
    int value = (int)(sender.value+0.5);
    [slider setValue:value animated:YES];
    [listOption setValue:[NSNumber numberWithInt:value] forKey:@"count"];
    
    if(group == nil){
        return;
    }
    
    // Find all other listOptions with options in the group
    NSMutableArray *listOptionsInGroup = [NSMutableArray array];
    int total = value;
    for(NSManagedObject *thisListOption in [self.fetchedResultsController fetchedObjects]){
        NSManagedObject *thisGroupMembership = (NSManagedObject*)[(NSManagedObject*)[thisListOption valueForKey:@"option"] valueForKey:@"groupMembership"];
        NSManagedObject *thisGroup = (NSManagedObject*)[thisGroupMembership valueForKey:@"group"];
        if(![thisListOption isEqual:listOption] && [thisGroup isEqual:group]){
            [listOptionsInGroup addObject:thisListOption];
            total += [(NSNumber*)[thisListOption valueForKey:@"count"] integerValue];
        }
    }
    
    int max = [(NSNumber*)[option valueForKey:@"max"] integerValue];
    
    NSLog(@"Total: %i Max: %i Count: %i", total, max, listOptionsInGroup.count);
    
    // Check if total count is greater than the max
    if(total <= max){
        return;
    }
    
    // Reduce the count & slider of other listOptions until total == max
    while (total > max && listOptionsInGroup.count > 0) {
        NSManagedObject *object = (NSManagedObject*)[listOptionsInGroup objectAtIndex:0];
        int thisCount = [(NSNumber*)[object valueForKey:@"count"] integerValue];
        NSLog(@"Total: %i Max: %i Count: %i ThisCount: %i", total, max, listOptionsInGroup.count, thisCount);
        
        int newVal;
        if ((total - max) > thisCount) {
            newVal = 0;
            total -= thisCount;
        }else{
            int diff = total - max;
            total -= diff;
            newVal = thisCount - diff;
        }
        
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UISlider *slider = (UISlider*)[cell viewWithTag:102];
        [object setValue:[NSNumber numberWithInt:newVal] forKey:@"count"];
        [slider setValue:newVal animated:YES];
        [listOptionsInGroup removeObject:object];
        NSLog(@"Total: %i Max: %i Count: %i", total, max, listOptionsInGroup.count);
        NSLog(@"Changed to %i in %@", newVal, object);
    }
    
    
}

@end
