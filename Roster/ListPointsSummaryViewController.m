//
//  ListPointsSummaryViewController.m
//  Roster
//
//  Created by Mal Curtis on 22/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListPointsSummaryViewController.h"
#import "ListUnit.h"
#import "ListOption.h"

@interface ListPointsSummaryViewController ()

@end

@implementation ListPointsSummaryViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configure];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ (%@): %i pts", self.list.name, self.list.army.name, self.list.cost];
}

-(void)configure{
    _extras = [NSMutableDictionary dictionary];
    _cellHeights = [NSMutableDictionary dictionary];
    for (ListUnit *listUnit in [self.fetchedResultsController fetchedObjects]) {
        NSLog(@"Working out listUnit: %@", listUnit.unit.name);
        NSMutableArray *strings = [NSMutableArray array];
        NSMutableArray *optionsStrings = [NSMutableArray array];
        [strings addObject:[NSString stringWithFormat:@"Base Cost: %i pts\nModels:", [listUnit.unit.cost integerValue]]];
        
        // Space Marine Squad: 280 pts
        // Base Cost: 200 pts
        // Models:
        //  10x Space Marine (5 included + 5 @ 16 pts ea): 80pts
        //  1x Space Marine Sergeant (1 included): 0 pts
        // Options:
        //  1x Flamer (1 @ 5 pts ea): 5 pts
        //  1x Heavy Bolter (1 @ 15 pts ea):
        for (ListModel *listModel in listUnit.listModels) {
            int included = [listModel.model.included integerValue];
            int count = [listModel.count integerValue];
            int extra = count - included;
            int cost = [listModel.model.cost integerValue];
            //  10x Space Marine (5 included + 5 @ 16 pts ea): 80pts
            NSString *extraString = extra > 0 ? [NSString stringWithFormat:@" + %i @ %i pts each", extra, cost] : @"";
            NSString *modelString = [NSString stringWithFormat:@"\n\t%ix %@ (%i included%@): %i pts", count, listModel.model.name, included, extraString, cost * extra];
            [strings addObject:modelString];
            for (ListOption *listOption in listModel.listOptions) {
                count = [listOption.count integerValue];
                if(count > 0 ){
                    cost = [listOption.option.cost integerValue];
                    [optionsStrings addObject:
                     [NSString stringWithFormat:@"\n\t%ix %@ (%i pts ea): %i pts", count, listOption.option.name, cost, cost * count]];
                }
            }
        }
        
        if(optionsStrings.count > 0){
            [strings addObject:[NSString stringWithFormat:@"\nOptions:%@", [optionsStrings componentsJoinedByString:@""]]];
        }
        
        NSString *extra = [strings componentsJoinedByString:@""];
        CGSize size = CGSizeMake(400 - 8 - 8, 100000);
        UITextView *textField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 400, 10000)];
        size.height = [extra sizeWithFont:textField.font constrainedToSize:size].height + 8 + 8;
        NSString *key = [[[listUnit objectID] URIRepresentation] absoluteString];
        NSLog(@"Height: %i for key %@", (int)size.height , key);
        
        [_extras setObject:extra forKey:key];
        [_cellHeights setObject:[NSNumber numberWithFloat:size.height] forKey:key];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _fetchedResultsController = nil;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *key = [[[object objectID] URIRepresentation] absoluteString];
    NSNumber *extrasHeight = [_cellHeights valueForKey:key];
    if(extrasHeight == nil){
        extrasHeight = [NSNumber numberWithInt:44];
    }
    float height = [extrasHeight floatValue] + 44.0;
    NSLog(@"Height for row at %i: %i: for key %@", indexPath.row, [extrasHeight integerValue], key);
    return height;
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Unit" forIndexPath:indexPath];
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListUnit" inManagedObjectContext:[Database context]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"list == %@",self.list];
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"unit.classification" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"unit.name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[Database context] sectionNameKeyPath:@"unit.classification" cacheName:@"Master"];
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
    ListUnit *listUnit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *key = [[[listUnit objectID] URIRepresentation] absoluteString];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 400, 44)];
    title.text = [NSString stringWithFormat:@"%@: %i pts", listUnit.unit.name, listUnit.cost];
    
    NSNumber *height = [_cellHeights valueForKey:key];
    UITextView *extras = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 400, [height integerValue])];
    [extras setScrollEnabled:NO];
    [extras setUserInteractionEnabled:NO];
    [extras setText:(NSString*)[_extras valueForKey:key]];
    
    [cell addSubview:title];
    [cell addSubview:extras];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}


@end

