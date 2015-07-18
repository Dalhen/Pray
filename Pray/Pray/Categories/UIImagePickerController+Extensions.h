//
//  UIImagePickerController+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface UIImagePickerController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - validation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)hasCamera;
+ (BOOL)hasLibrary;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - creation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImagePickerController *)controllerForCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;
+ (UIImagePickerController *)controllerForLibraryWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end
