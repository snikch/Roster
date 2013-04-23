//
//  UIViewController+CloseButton.m
//  Roster
//
//  Created by Mal Curtis on 22/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "UIViewController+CloseButton.h"

@implementation UIViewController (CloseButton)

-(IBAction)didPressClose:(id)sender{
    if(self.tabBarController != nil){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    if(self.navigationController != nil){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
