//
//  UIImagePickerController+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIImagePickerController+Extensions.h"

@implementation UIImagePickerController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)hasLibrary
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImagePickerController *)controllerForCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerControllerSourceType sourceType = -1;
    if ([self hasCamera])
        {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    else
        {
        printFailPointAndAbort;
        }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = delegate;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = sourceType;
        
    return imagePicker;
}

+ (UIImagePickerController *)controllerForLibraryWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerControllerSourceType sourceType = -1;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    else
        {
        printFailPointAndAbort;
        }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = delegate;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = sourceType;
    return imagePicker;
}

@end
