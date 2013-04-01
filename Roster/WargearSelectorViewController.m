//
//  WargearSelectorViewController.m
//  Roster
//
//  Created by Mal Curtis on 31/03/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "WargearSelectorViewController.h"

@interface WargearSelectorViewController ()
@end

@implementation WargearSelectorViewController

-(void)didSelectWargear:(NSArray *)wargear{
    if(self.wargearDelegate != nil){
        [self.wargearDelegate didSelectWargear:wargear];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
