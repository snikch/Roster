//
//  UIViewController+ImagePicker.m
//  Roster
//
//  Created by Mal Curtis on 26/04/13.
//  Copyright (c) 2013 Mal Curtis. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import <objc/runtime.h>

static char const * const imagePopoverControllerKey = "ImagePopoverController";

@implementation UIViewController (ImagePicker)

#pragma mark - FilePicker

-(IBAction)didPressAddImage:(id)sender{
    FPPickerController *fpController = [[FPPickerController alloc] init];
    fpController.dataTypes = [NSArray arrayWithObjects:@"image/*", nil];
    fpController.fpdelegate = self;
    fpController.allowsEditing = YES;
    fpController.sourceNames = @[FPSourceCamera, FPSourceCameraRoll, FPSourceImagesearch, FPSourceFlickr, FPSourceFacebook, FPSourceGmail, FPSourceDropbox, FPSourcePicasa];
    
    [self setImagePopoverController: [[UIPopoverController alloc] initWithContentViewController:fpController]];
    [self imagePopoverController].popoverContentSize = CGSizeMake(320, 520);
    [[self imagePopoverController] presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)FPPickerController:(FPPickerController *)picker didPickMediaWithInfo:(NSDictionary *)info {
}

- (void)FPPickerControllerDidCancel:(FPPickerController *)picker
{
    [[self imagePopoverController] dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
};

#pragma mark instance variable getter / setters

- (UIPopoverController *)imagePopoverController {
    return objc_getAssociatedObject(self, imagePopoverControllerKey);
}

- (void)setImagePopoverController:(UIPopoverController *)newValue {
    objc_setAssociatedObject(self,
                             imagePopoverControllerKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
