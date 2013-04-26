//
//  UIViewController+ImagePicker.h
//  Roster
//
//  Created by Mal Curtis on 26/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FPPicker/FPPicker.h>

@interface UIViewController (ImagePicker) <FPPickerDelegate>

- (UIPopoverController *)imagePopoverController;

@end
