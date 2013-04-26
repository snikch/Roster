//
//  ListUnitSummaryViewController.m
//  Roster
//
//  Created by Mal Curtis on 22/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "ListUnitSummaryViewController.h"
#import "CharacteristicsView.h"
#import "ListModel.h"
#import "ListOption.h"
#import "ModelSummaryCell.h"

@interface ListUnitSummaryViewController ()

@property (strong, nonatomic) NSMutableDictionary *characteristics;

@end

@implementation ListUnitSummaryViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configure];
}
-(void)configureModels{
    NSMutableArray *temp = [NSMutableArray array];
    for (ListModel *listModel in _listUnit.listModels) {
        NSMutableArray *tempOptions = [NSMutableArray array];
        for (ListOption *listOption in listModel.listOptions) {
            if ([listOption.count integerValue] > 0) {
                [tempOptions addObject:listOption];
            }
        }
        [temp addObject:@{@"model": listModel, @"options": [tempOptions copy]}];
    }
    _listModels = [temp copy];
}
-(void)configure{
    [self configureModels];
       
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ListModel *listModel = [[_listModels objectAtIndex:section] valueForKey:@"model"];
    return listModel.model.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listModels count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = [_listModels objectAtIndex:section];
    NSArray *options = [sectionInfo valueForKey:@"options"];
    return [options count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelSummaryCell *cell = (ModelSummaryCell*)[tableView dequeueReusableCellWithIdentifier:@"Model" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)configureCell:(ModelSummaryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [_listModels objectAtIndex:indexPath.section];
    NSArray *options = [sectionInfo valueForKey:@"options"];
    ListModel *listModel = [sectionInfo valueForKey:@"model"];
    NSLog(@"options %@", options);
    CharacteristicsView *charactericView;
    
    if(indexPath.row == 0){
        cell.textLabel.text = listModel.model.name;
        NSLog(@"Model chars: %@", [listModel.model characteristicsWithOption:nil]);
        
        charactericView = [CharacteristicsView viewWithCharacteristics:[listModel.model characteristicsWithOption:nil]];
        
        CGRect newFrame = charactericView.frame;
        newFrame.origin.x = cell.frame.size.width - newFrame.size.width;
        charactericView.frame = newFrame;
        
    }else{
        ListOption *listOption = [options objectAtIndex:indexPath.row-1];
        cell.textLabel.text = listOption.option.name;
        charactericView = [CharacteristicsView viewWithCharacteristics:[listModel.model characteristicsWithOption:listOption.option]];
        
        CGRect newFrame = charactericView.frame;
        newFrame.origin.x = cell.frame.size.width - newFrame.size.width;
        charactericView.frame = newFrame;
    }
    
    if(cell.characteristicsView != nil){
        [cell.characteristicsView removeFromSuperview];
    }
    [cell setCharacteristicsView:charactericView];
    
    [cell addSubview:charactericView];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}


@end


