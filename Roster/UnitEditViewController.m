//
//  UnitEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 29/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "UnitEditViewController.h"

#import "ModelEditViewController.h"
#import "OptionEditViewController.h"
#import "Model.h"
#import "Option.h"

@interface UnitEditViewController ()
-(void)commitChanges;
-(void)applyUnitValues;
-(void)updateFetchResultsControllerPredicate;
@end

@implementation UnitEditViewController

@synthesize nameField, costField, classificationField, infoField;
@synthesize managedObjectContext;

# pragma mark - Lifecycle
- (id)init {
    if (self = [super init]) {
        //other your stuff goes here
        //...
        //here we customize the target and action for the backBarButtonItem
        //every navigationController has one of this item automatically configured to pop back
    }
    return self;
}
-(void)commitChanges{
    [_unit setValue:nameField.text forKey:@"name"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [_unit setValue:[f numberFromString:costField.text] forKey:@"cost"];
    [_unit setValue:classificationField.text forKey:@"classification"];
    [_unit setValue:infoField.text forKey:@"info"];
}
-(void)setUnit:(Unit *)unit{
    _unit = unit;
}

-(void)applyUnitValues{
    NSLog(@"Applying unit values to fields for unit named: %@", [_unit valueForKey:@"name"]);
    nameField.text = [_unit valueForKey:@"name"];
    costField.text = [(NSNumber *)[_unit valueForKey:@"cost"] stringValue];
    classificationField.text = [_unit valueForKey:@"classification"];
    infoField.text = [_unit valueForKey:@"info"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _optionsResultsController = nil;
    _modelsResultsController = nil;
    [self commitChanges];
}

-(void) viewWillAppear:(BOOL)animated{
    [self applyUnitValues];
    [self updateFetchResultsControllerPredicate];
    [super viewWillAppear:animated];

}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateFetchResultsControllerPredicate];
}

-(void)didPressBackButton:(id)sender{
    NSLog(@"Did press back button");
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newModel"]) {
        ModelEditViewController *vc = (ModelEditViewController *)[segue destinationViewController];
        
        Model *model = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
        
        [model setValue:_unit forKey:@"unit"];
        
        [vc setModel:model];
        [vc setIsNewModel:YES];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"editModel"]) {
        NSLog(@"Showing model edit controller with moc %@", self.managedObjectContext);
        ModelEditViewController *vc = (ModelEditViewController *)[segue destinationViewController];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Model *model = (Model *)[[self modelsResultsController] objectAtIndexPath:indexPath];
        
        [vc setModel:model];
        [vc setIsNewModel:NO];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"newOption"]) {
        OptionEditViewController *vc = (OptionEditViewController *)[segue destinationViewController];
        
        Option *option = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:self.managedObjectContext];
        
        [option setValue:_unit forKey:@"unit"];
        
        [vc setOption:option];
        [vc setIsNewOption:YES];
        [vc setManagedObjectContext: self.managedObjectContext];
    }else if ([[segue identifier] isEqualToString:@"editOption"]) {
        OptionEditViewController *vc = (OptionEditViewController *)[segue destinationViewController];
        
        Option *option = (Option *)[[self optionsResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:[[self.tableView indexPathForSelectedRow] row] inSection:0]];
        
        [vc setOption:option];
        [vc setIsNewOption:NO];
        [vc setManagedObjectContext: self.managedObjectContext];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    if (0 == section){
        sectionInfo = [self.modelsResultsController sections][0];
    }else{
        sectionInfo = [self.optionsResultsController sections][0];
    }
    NSLog(@"Rows in section %i: %i", section, [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (0 == [indexPath section]){
        CellIdentifier = @"Model";
    }else{
        CellIdentifier = @"Option";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    NSLog(@"Configuring cell");
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Models", @"Models");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Wargear Options", @"Wargear Options");
            break;
            // ...
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
        if(0 == [indexPath section]){
            object = (NSManagedObject *)[[self modelsResultsController] objectAtIndexPath:indexPath];
        }else{
            object = (NSManagedObject *)[[self optionsResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
        }
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
    NSLog(@"Retrieving object for row %i in section %i", [indexPath row], [indexPath section]);
    if(0 == [indexPath section]){
        object = [self.modelsResultsController objectAtIndexPath:indexPath];
    }else{
        object = [self.optionsResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
    }
    NSLog(@"Configuring cell: %@", [object valueForKey:@"name"]);
    NSNumber * cost = [object valueForKey:@"cost"];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i pts)",[[object valueForKey:@"name"] description],[cost intValue]];
}


#pragma mark - Fetched results controller

-(void)updateFetchResultsControllerPredicate{
    NSFetchRequest *modelsFetchRequest = [self.modelsResultsController fetchRequest];
    NSFetchRequest *optionsFetchRequest = [self.optionsResultsController fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unit == %@",_unit];
    NSLog(@"Setting frc predicate to unit %@", _unit);
    
    [optionsFetchRequest setPredicate:predicate];
    [modelsFetchRequest setPredicate:predicate];
    
    [NSFetchedResultsController deleteCacheWithName:@"Models"];
    [NSFetchedResultsController deleteCacheWithName:@"Options"];
    
    NSError *error;
    if (![self.modelsResultsController performFetch:&error] || ![self.optionsResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)modelsResultsController
{
    if (_modelsResultsController != nil) {
        return _modelsResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Models"];
    aFetchedResultsController.delegate = self;
    self.modelsResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.modelsResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _modelsResultsController;
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
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"Did change section info: %@", sectionInfo);
   // if([anObject isMemberOfClass:[Option class]]){
     //   sectionIndex = 1;
   // }
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
    if([anObject isMemberOfClass:[Option class]]){
        indexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:1];
    }
    NSLog(@"did change object %@ at indexPath: %@ for type %i", anObject, indexPath, type);
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

@end
