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

@property (weak, nonatomic) UIPopoverController *groupPopoverController;

@end

@implementation OptionEditViewController

@synthesize nameField, costField, infoView;
@synthesize availableLabel, wargearLabel, limitLabel, groupLabel;
@synthesize isUnitSwitch;
@synthesize availableSlider, limitSlider;

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
    }else if ([[segue identifier] isEqualToString:@"selectGroup"]) {
        _groupPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        [_groupPopoverController setPopoverContentSize:CGSizeMake(500, 250)];
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        OptionGroupListViewController *vc = (OptionGroupListViewController *)[nc.viewControllers objectAtIndex:0];
        vc.delegate = self;
        vc.managedObjectContext = self.managedObjectContext;
        vc.model = [_option valueForKey:@"model"];
        
        vc.group = [_option valueForKey:@"group"];
    }
}


-(void)didSelectWargear:(NSArray *)array{
    NSLog(@"Did select wargear! %@", array);
    if(array.count > 0){
        [_option setValue:[array objectAtIndex:0] forKey:@"wargear"];
    }else{
        [_option setValue:nil forKey:@"wargear"];
    }
    Wargear *wargear = (Wargear*)[_option valueForKey:@"wargear"];
    if(wargear){
        wargearLabel.text = [wargear valueForKey:@"name"];
    }else{
        wargearLabel.text = @"(no attached wargear)";
    }
}

-(void)viewDidLoad{
    [availableSlider
     addTarget:self
     action:@selector(availableSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
    [limitSlider
     addTarget:self
     action:@selector(limitSliderDidChange:)
     forControlEvents:UIControlEventValueChanged];
    
    self.selectedWargear = _option.replacesWargear;
}

-(IBAction)availableSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    NSLog(@"Available did change to %i", value);
    availableLabel.text = [NSString stringWithFormat:@"%i", value];
}

-(IBAction)limitSliderDidChange:(UISlider *)sender
{
    int value = (int)(sender.value + 0.5);
    NSLog(@"Available did change to %i", value);
    limitLabel.text = [NSString stringWithFormat:@"%i", value];
}

-(void)viewWillAppear:(BOOL)animated{
    [self applyModelValues];
    self.title = @"Edit Option";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fetchedResultsController = nil;
}

-(void)applyModelValues{
    nameField.text = [_option valueForKey:@"name"];
    costField.text = [NSString stringWithFormat:@"%i", [(NSNumber *)[_option valueForKey:@"cost"] intValue]];
    infoView.text = [_option valueForKey:@"info"];
    
    availableLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_option valueForKey:@"available"] intValue]];
    limitLabel.text = [NSString stringWithFormat:@"%i", [(NSNumber*)[_option valueForKey:@"max"] intValue]];
    
    [availableSlider setValue:[(NSNumber *)[_option valueForKey:@"available"] floatValue]];
    [limitSlider setValue:[(NSNumber *)[_option valueForKey:@"max"] floatValue]];
    [isUnitSwitch setOn:[(NSNumber *)[_option valueForKey:@"isUnit"] boolValue] animated:NO];
    
    Wargear *wargear = (Wargear*)[_option valueForKey:@"wargear"];
    if(wargear){
        wargearLabel.text = [wargear valueForKey:@"name"];
    }else{
        wargearLabel.text = @"(no attached wargear)";
    }
    
    NSManagedObject *group = [_option valueForKey:@"group"];
    if(group){
        self.groupLabel.text = [group valueForKey:@"name"];
    }else{
        self.groupLabel.text = @"Single";
    }

}

-(void)commitChanges{
    NSLog(@"Commiting changes");
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    [_option setValue:nameField.text forKey:@"name"];
//    [_option setValue:infoView.text forKey:@"info"];
    [_option setValue:[NSNumber numberWithBool:isUnitSwitch.isOn] forKey:@"isUnit"];
    [_option setValue:[NSNumber numberWithInt:(int)(availableSlider.value + 0.5)] forKey:@"available"];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [_option setValue:[f numberFromString:costField.text] forKey:@"cost"];
    
    NSError *error;
    
    // Clear existing wargear
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OptionReplacement" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"option == %@",_option];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];
    NSArray *currentObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(NSManagedObject *object in currentObjects){
        [self.managedObjectContext deleteObject:object];
    }
    
    // Create new records
    for(NSManagedObject *modelWargear in self.selectedWargear){
        NSManagedObject *optionReplacement = [NSEntityDescription insertNewObjectForEntityForName:@"OptionReplacement" inManagedObjectContext:self.managedObjectContext];
        [optionReplacement setValue:_option forKey:@"option"];
        [optionReplacement setValue:modelWargear forKey:@"modelWargear"];
    }
    
    /** Manage Group Membership
     * Update max limit for all group members
     */
    NSManagedObject *group = [_option valueForKey:@"group"];
    NSArray *members;
    if(group){
        NSMutableArray *tempMembers = [NSMutableArray array];
        // Options already contains the current _option
        for(NSManagedObject *option in [group valueForKey:@"options"]){
            [tempMembers addObject:option];
        }
        members = [tempMembers copy];
    }else{
        members = @[_option];
    }
    for (NSManagedObject *option in members){
        [option setValue:[NSNumber numberWithInt:(int)(limitSlider.value + 0.5)] forKey:@"max"];
    }
    NSLog(@"Saved");

    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
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

-(IBAction)didPressRemoveWargear:(id)sender{
    [_option setValue:nil forKey:@"wargear"];
    wargearLabel.text = @"(no attached wargear)";
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo;
    sectionInfo = [self.modelsResultsController sections][0];
    NSLog(@"Rows in section %i: %i", section, [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"Replacement";
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
            sectionName = NSLocalizedString(@"Replaces Wargear", @"Replaces Wargear");
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
        object = (NSManagedObject *)[[self modelsResultsController] objectAtIndexPath:indexPath];
        
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
    NSManagedObject *modelWargear = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([self.selectedWargear containsObject:modelWargear]){
        [self.selectedWargear removeObject:modelWargear];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        [self.selectedWargear addObject:modelWargear];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object;
    object = [self.modelsResultsController objectAtIndexPath:indexPath];
    
    Wargear *wargear = [object valueForKey:@"wargear"];
    cell.textLabel.text = [wargear valueForKey:@"name"];
    
    if([self.selectedWargear containsObject:object]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)modelsResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ModelWargear" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    Model *model = (Model*)[_option valueForKey:@"model"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"model == %@",model];
    
    [fetchRequest setPredicate:predicate];

    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wargear.name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.modelsResultsController performFetch:&error]) {
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

# pragma mark - Option Group Delegate

-(void)didSelectOptionGroup:(NSManagedObject *)group{
    [_groupPopoverController dismissPopoverAnimated:YES];
    
    [_option setValue:group forKey:@"group"];
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    self.groupLabel.text = [group valueForKey:@"name"];
}

-(IBAction)didPressRemoveGroup:(id)sender{
    NSManagedObject *group = [_option valueForKey:@"group"];
    if(group){
        [_option setValue:NULL forKey:@"group"];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        self.groupLabel.text = @"Single";
    }
}


@end
