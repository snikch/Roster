//
//  CharacteristicsSelectorEditViewController.m
//  Roster
//
//  Created by Mal Curtis on 2/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "CharacteristicsSelectorEditViewController.h"

@interface CharacteristicsSelectorEditViewController ()
@property (strong, nonatomic) NSMutableDictionary *characteristicEntries;
@end

@implementation CharacteristicsSelectorEditViewController

-(void)viewDidLoad{
    self.customKeyboard = [[CustomKeyboard alloc] init];
    self.customKeyboard.delegate = self;
    self.characteristicEntries = [NSMutableDictionary dictionary];
}

-(IBAction)didPressSave:(id)sender{
    if(self.delegate != nil){
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *values = [NSMutableArray array];
        int count = 0;
        for(NSManagedObject *object in [_fetchedResultsController fetchedObjects]){
            [keys addObject:[object valueForKey:@"name"]];
            id value = [self.characteristicEntries valueForKey:[NSString stringWithFormat:@"%i", count]];
            if (value == nil){
                value = [NSNull null];
            }
            NSDictionary *valueDict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:count], value] forKeys:@[@"sortOrder", @"value"]];
            [values
             addObject:valueDict];
            count++;
        }
        NSDictionary *characteristics = [NSDictionary dictionaryWithObjects:values forKeys:keys];

        [self.delegate didSelectCharacteristics:characteristics ];
    }
    [self.presentingPopoverController dismissPopoverAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateFetchResultsControllerPredicate];
}
-(void)viewWillDisappear:(BOOL)animated{
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",self.type];
    NSLog(@"Updating fetch request to use type: %@", self.type);
    
    [fetchRequest setPredicate:predicate];
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CharacteristicTemplate" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOrder" ascending:YES];
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
    UILabel *label = (UILabel*)[cell viewWithTag:101];
    label.text = [[object valueForKey:@"name"] description];    
    UITextField *input = (UITextField*)[cell viewWithTag:102];
    
    NSString* inputValue = [self.characteristicEntries
                            valueForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    input.text = inputValue;
    input.delegate = self;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Keyboard Control
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell*) textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _currentTextField = textField;
    NSLog(@"Text field did begin editing in cell %@, ", indexPath);

    _customKeyboard.currentSelectedTextboxIndex = indexPath.row;
    [textField setInputAccessoryView:[_customKeyboard
                                      getToolbarWithPrevNextDone:indexPath.row != 0 :indexPath.row < ([self.tableView numberOfRowsInSection:0]-1)]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _currentTextField = nil;
}


-(void)nextClicked:(NSUInteger)selectedId{
    NSLog(@"Next clicked (%i)", selectedId);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedId+1 inSection:0];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [(UITextField*)[nextCell viewWithTag:102] becomeFirstResponder];
}

-(void)previousClicked:(NSUInteger)selectedId{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedId-1 inSection:0];
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [(UITextField*)[nextCell viewWithTag:102] becomeFirstResponder];
}

-(void)doneClicked:(NSUInteger)selectedId{
    if(_currentTextField){
        [_currentTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Text Field should return called");
    if(_customKeyboard.currentSelectedTextboxIndex < ([self.tableView numberOfRowsInSection:0]-1)){
        [self nextClicked:_customKeyboard.currentSelectedTextboxIndex];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Compute the new text that we will obtain once the new character has been validated
    NSMutableString* newText = [NSMutableString stringWithString:textField.text];
    [newText replaceCharactersInRange:range withString:string];
    // Store it in our dictionary. Same as before, but use newText instead of textField.text
    UITableViewCell* containerCell = (UITableViewCell*)textField.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:containerCell];
    // Store the text, for example in an NSMutableDictionary using the indexPath as a key
    NSLog(@"Setting char entry %@ for ipr %i", newText, indexPath.row);
    [self.characteristicEntries setValue:(NSString*)newText forKey:[NSString stringWithFormat:@"%i",indexPath.row]];
    // Accept the new character
    return YES;
}

@end
