//
//  ListNewViewController.h
//  Roster
//
//  Created by Mal Curtis on 9/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListNewDelegate <NSObject>

-(void)didCreateNew:(NSDictionary*)values;

@end

@interface ListNewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *infoField;

@property (strong, nonatomic) id <ListNewDelegate> delegate;

-(IBAction)didPressSave:(id)sender;

@end
