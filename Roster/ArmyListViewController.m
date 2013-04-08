//
//  ArmyListViewController.m
//  Roster
//
//  Created by Mal Curtis on 7/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ArmyListViewController.h"
#import "ArmyUnitViewController.h"

@interface ArmyListViewController ()

@end

@implementation ArmyListViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editArmy"]) {
        NSLog(@"Did prepare for segue");
        //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //        Army *army = (Army *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        //        [[segue destinationViewController] setArmy:army];
        NSLog(@"Showing new army controller with moc %@", self.managedObjectContext);
        ArmyUnitViewController *vc = (ArmyUnitViewController *)[segue destinationViewController];
        [vc setManagedObjectContext: self.managedObjectContext];
        [vc setArmy:self.army];
    }
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configureView];
}

- (void)setArmy:(Army *)newArmy
{
    NSLog(@"Did receive setArmy with %@", newArmy);
    if (_army != newArmy) {
        _army = newArmy;
        
        // Update the view.
        [self configureView];
    }
}

-(void)configureView{
    self.title = [_army valueForKey: @"name"];
    NSMutableArray *toolbarButtons = [self.navigationItem.leftBarButtonItems mutableCopy];
    if(_army == nil){
        NSLog(@"Removing button from: %@", toolbarButtons);
        [toolbarButtons removeObject:self.editArmyButton];
        [self.navigationItem setLeftBarButtonItems:toolbarButtons animated:NO];
    }else{
        
        // This is how you remove the button from the toolbar and animate it
        // This is how you add the button to the toolbar and animate it
        if (![toolbarButtons containsObject:self.editArmyButton]) {
            [toolbarButtons addObject:self.editArmyButton];
            [self.navigationItem setLeftBarButtonItems:toolbarButtons animated:YES];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
}

@end
