//
//  CharacteristicsSelectorListViewController.h
//  Roster
//
//  Created by Mal Curtis on 2/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CharacteristicsSelectorDelegate <NSObject>

-(void)didSelectCharacteristics:(NSDictionary*)characteristics;

@end

@interface CharacteristicsSelectorListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIPopoverController *presentingPopoverController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) id <CharacteristicsSelectorDelegate> delegate;

@end
