//
//  WargearListViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "WargearListViewController.h"
#import "WargearSelectorViewController.h"
#import "WargearEditViewController.h"

@interface WargearListViewController ()
-(IBAction)didPressDone:(id)sender;
@end

@implementation WargearListViewController

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WargearEditViewController *vc = (WargearEditViewController *)[segue destinationViewController];
    vc.isMultiple = self.multiple;
    vc.selectedWargear = self.selectedWargear;
    if ([[segue identifier] isEqualToString:@"addWargear"]) {
        
        Wargear *wargear = [NSEntityDescription insertNewObjectForEntityForName:@"Wargear" inManagedObjectContext:self.managedObjectContext];
        
        [wargear setValue:_army forKey:@"army"];
        
        [vc setWargear:wargear];
        [vc setIsNew:YES];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"editWargear"]) {
        //TODO index path doesnt exist since sender isnt the accessory view. Use an image for checkbox
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Wargear *wargear = (Wargear *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        NSLog(@"Wargear: %@ at: %@", wargear, indexPath);
        
        [vc setWargear:wargear];
        [vc setIsNew:NO];
        [vc setManagedObjectContext: self.managedObjectContext];
    }
}
# pragma mark - Lifecycle

-(void)viewDidLoad{
    WargearSelectorViewController *vc = (WargearSelectorViewController *) self.navigationController;
    self.managedObjectContext = vc.managedObjectContext;
    self.army = vc.army;
    self.multiple = vc.multiple;
    self.selectedWargear = vc.selectedWargear;
    NSLog(@"wargear Index view selected wargear is %@", self.selectedWargear);
    self.title = @"Select Wargear";
}

-(IBAction)didPressDone:(id)sender{
    WargearSelectorViewController *vc = (WargearSelectorViewController *) self.navigationController;
    [vc didSelectWargear:self.selectedWargear];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fetchedResultsController = nil;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Wargear" forIndexPath:indexPath];
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

-(void)updateFetchResultsControllerPredicate{
    NSFetchRequest *fetchRequest = [self.fetchedResultsController fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"army == %@",self.army];
    
    [fetchRequest setPredicate:predicate];
    
    [NSFetchedResultsController deleteCacheWithName:@"Army"];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wargear" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Wargear"];
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
    UILabel *title = (UILabel*)[cell viewWithTag:101];
    title.text = [[object valueForKey:@"name"] description];
    Wargear *wargear = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UISwitch *toggle = (UISwitch*)[cell viewWithTag:102];
    if([self.selectedWargear containsObject:wargear]){
        [toggle setOn:YES animated:NO];
    }else{
        [toggle setOn:NO animated:NO];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Wargear *wargear = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(self.multiple == YES){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UISwitch *toggle = (UISwitch*)[cell viewWithTag:102];
        if([self.selectedWargear containsObject:wargear]){
            [self.selectedWargear removeObject:wargear];
            [toggle setOn:NO animated:YES];
        }else{
            [self.selectedWargear addObject:wargear];
            [toggle setOn:YES animated:YES];
        }
    }else{
        WargearSelectorViewController *vc = (WargearSelectorViewController *) self.navigationController;
        [vc didSelectWargear:@[wargear]];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}


@end
