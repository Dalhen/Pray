//
//  SignupController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SignupController.h"
#import "UIImageView+Rounded.h"
#import "NSString+Extensions.h"
#import "BaseView.h"

@interface SignupController ()

@end

@implementation SignupController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self setupLayout];
    [self setupHeader];
}


#pragma mark - Appearance
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self registerForEvents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.UserServices.RegistrationSuccess, signupAccountSuccess);
    Notification_Observe(JXNotification.UserServices.RegistrationFailed, signupAccountFailed);
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsSuccess, updateUserProfileSuccess);
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsFailed, updateUserProfileFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.RegistrationSuccess);
    Notification_Remove(JXNotification.UserServices.RegistrationFailed);
    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsSuccess);
    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsFailed);
    Notification_RemoveObserver;
}


#pragma mark - Layout
- (void)setupHeader {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 28*sratio, 48*sratio, 14*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)setupLayout {
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44*sratio, 90*sratio, 90*sratio)];
    [profileImage setImage:[UIImage imageNamed:@"addProfilePicture"]];
    [profileImage setRoundedToDiameter:90*sratio];
    [profileImage setClipsToBounds:YES];
    [self.view addSubview:profileImage];
    [profileImage centerHorizontallyInSuperView];
    
    UIButton *profilePictureEditor = [UIButton buttonWithType:UIButtonTypeCustom];
    [profilePictureEditor setFrame:profileImage.frame];
    [profilePictureEditor addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:profilePictureEditor];
    
    profileUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, profileImage.bottom + 22*sratio, 280*sratio, 42*sratio)];
    [profileUsername setTextAlignment:NSTextAlignmentLeft];
    [profileUsername setFont:[FontService systemFont:13*sratio]];
    [profileUsername setTextColor:Colour_PrayBlue];
    [profileUsername setPlaceholder:LocString(@"Username")];
    [profileUsername setBackgroundColor:Colour_White];
    UIView *padding4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding4 setBackgroundColor:Colour_Clear];
    [profileUsername setLeftView:padding4];
    [profileUsername setLeftViewMode:UITextFieldViewModeAlways];
    [profileUsername setReturnKeyType:UIReturnKeyNext];
    [profileUsername setKeyboardType:UIKeyboardTypeEmailAddress];
    [profileUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [profileUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
    [profileUsername.layer setCornerRadius:3.0f*sratio];
    [profileUsername setDelegate:self];
    [mainScroll addSubview:profileUsername];
    [profileUsername centerHorizontallyInSuperView];
    
    profilePassword = [[UITextField alloc] initWithFrame:CGRectMake(0, profileUsername.bottom + 14*sratio, 280*sratio, 42*sratio)];
    [profilePassword setTextAlignment:NSTextAlignmentLeft];
    [profilePassword setFont:[FontService systemFont:13*sratio]];
    [profilePassword setTextColor:Colour_PrayBlue];
    [profilePassword setPlaceholder:LocString(@"Password")];
    [profilePassword setBackgroundColor:Colour_White];
    UIView *padding5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding5 setBackgroundColor:Colour_Clear];
    [profilePassword setLeftView:padding5];
    [profilePassword setLeftViewMode:UITextFieldViewModeAlways];
    [profilePassword setReturnKeyType:UIReturnKeyNext];
    [profilePassword setSecureTextEntry:YES];
    [profilePassword.layer setCornerRadius:3.0f*sratio];
    [profilePassword setDelegate:self];
    [mainScroll addSubview:profilePassword];
    [profilePassword centerHorizontallyInSuperView];

    profileEmail = [[UITextField alloc] initWithFrame:CGRectMake(0, profilePassword.bottom + 14*sratio, 280*sratio, 42*sratio)];
    [profileEmail setTextAlignment:NSTextAlignmentLeft];
    [profileEmail setFont:[FontService systemFont:13*sratio]];
    [profileEmail setTextColor:Colour_PrayBlue];
    [profileEmail setPlaceholder:LocString(@"Email")];
    [profileEmail setBackgroundColor:Colour_White];
    UIView *padding6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding6 setBackgroundColor:Colour_Clear];
    [profileEmail setLeftView:padding6];
    [profileEmail setLeftViewMode:UITextFieldViewModeAlways];
    [profileEmail setReturnKeyType:UIReturnKeyNext];
    [profileEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [profileEmail setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [profileEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    [profileEmail.layer setCornerRadius:3.0f*sratio];
    [profileEmail setDelegate:self];
    [mainScroll addSubview:profileEmail];
    
    profileFirstName = [[UITextField alloc] initWithFrame:CGRectMake(profileEmail.left, profileEmail.bottom + 14*sratio, 120*sratio, 42*sratio)];
    [profileFirstName setTextAlignment:NSTextAlignmentLeft];
    [profileFirstName setFont:[FontService systemFont:13*sratio]];
    [profileFirstName setTextColor:Colour_PrayBlue];
    [profileFirstName setPlaceholder:LocString(@"First name")];
    [profileFirstName setBackgroundColor:Colour_White];
    UIView *padding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding1 setBackgroundColor:Colour_Clear];
    [profileFirstName setLeftView:padding1];
    [profileFirstName setLeftViewMode:UITextFieldViewModeAlways];
    [profileFirstName setReturnKeyType:UIReturnKeyNext];
    [profileFirstName.layer setCornerRadius:3.0f*sratio];
    [profileFirstName setDelegate:self];
    [mainScroll addSubview:profileFirstName];
    
    profileLastName = [[UITextField alloc] initWithFrame:CGRectMake(profileFirstName.right, profileFirstName.top, 160*sratio, 42*sratio)];
    [profileLastName setTextAlignment:NSTextAlignmentLeft];
    [profileLastName setFont:[FontService systemFont:13*sratio]];
    [profileLastName setTextColor:Colour_PrayBlue];
    [profileLastName setPlaceholder:LocString(@"Last name")];
    [profileLastName setBackgroundColor:Colour_White];
    UIView *padding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding2 setBackgroundColor:Colour_Clear];
    [profileLastName setLeftView:padding2];
    [profileLastName setLeftViewMode:UITextFieldViewModeAlways];
    [profileLastName setReturnKeyType:UIReturnKeyNext];
    [profileLastName.layer setCornerRadius:3.0f*sratio];
    [profileLastName setDelegate:self];
    [mainScroll addSubview:profileLastName];
    
    profileBlob = [[UITextView alloc] initWithFrame:CGRectMake(0, profileFirstName.bottom + 14*sratio, 280*sratio, 110*sratio)];
    [profileBlob setTextAlignment:NSTextAlignmentLeft];
    [profileBlob setFont:[FontService systemFont:13*sratio]];
    [profileBlob setTextColor:Colour_PrayBlue];
    [profileBlob setBackgroundColor:Colour_White];
    [profileBlob setReturnKeyType:UIReturnKeyDone];
    [profileBlob setUserInteractionEnabled:YES];
    [profileBlob setSelectable:YES];
    [profileBlob.layer setCornerRadius:3.0f*sratio];
    [profileBlob setDelegate:self];
    [mainScroll addSubview:profileBlob];
    [profileBlob centerHorizontallyInSuperView];
    
    UIButton *blobAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [blobAction setFrame:profileBlob.frame];
    [blobAction addTarget:self action:@selector(showBlobEditor) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:blobAction];
}


#pragma mark - Register
- (void)signupAccount {
    NSData *imageData = [self compressImage:selectedImage];
    
    if (![profileFirstName.text isEqualToString:@""] &&
        ![profileLastName.text isEqualToString:@""] &&
        ![profilePassword.text isEqualToString:@""] &&
        ![profileEmail.text isEqualToString:@""] &&
        ![profilePosition.text isEqualToString:@""]) {
        
        if ([profilePassword.text length]>= 6) {
            [NetworkService signupWithFirstName:profileFirstName.text lastName:profileLastName.text password:profilePassword.text linkedinID:linkedInID email:profileEmail.text position:profilePosition.text bio:profileBlob.text departmentID:[selectedDepartment objectForKey:@"id"] avatarURL:linkedProfileURL avatarImage:imageData];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:LocString(@"Incorrect Password") message:LocString(@"Please make sure your password is at least 6 characters before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    else {
        [[[UIAlertView alloc] initWithTitle:LocString(@"Fill the form") message:LocString(@"Please make sure you have filled your firstname, lastname, email, password and position before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)signupAccountSuccess {
//    LoginController *loginController = [[LoginController alloc] initWithEmail:profileEmail.text andPassword:profilePassword.text];
//    [self.navigationController setViewControllers:@[[self.navigationController.viewControllers objectAtIndex:0], loginController] animated:YES];
//    
//    [[[UIAlertView alloc] initWithTitle:LocString(@"Account created!") message:LocString(@"Your account has been created. Please click on the link in the email we've just sent you and press login.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)signupAccountFailed {
    [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"We couldn't create your account. Please check your internet connection and try again.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}


#pragma mark UIImagePicker delegates & Camera
- (void)takePhoto {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LocString(@"Select Photo Source")
                                                             delegate:self cancelButtonTitle:LocString(@"Cancel") destructiveButtonTitle:nil
                                                    otherButtonTitles:LocString(@"Photo Library"), LocString(@"Camera"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setupCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    else if (buttonIndex == 1) {
        [self setupCamera:UIImagePickerControllerSourceTypeCamera];
    }
    
    else if (buttonIndex == actionSheet.cancelButtonIndex) {
        
    }
}

- (void)setupCamera:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    [cameraController setSourceType:sourceType];
    cameraController.delegate = self;
    cameraController.allowsEditing = YES;
    cameraController.navigationBarHidden = YES;
    cameraController.toolbarHidden = YES;
    
    [self presentViewController:cameraController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self gotPicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)gotPicture:(UIImage *)img {
	   
    //UIImageView *finalImage = [[UIImageView alloc] initWithImage:img];
    [profileImage setImage:img]; //.image = [finalImage imageByScalingAndCroppingForSize:CGSizeMake(40*sratio, 40*sratio) image:img];
    selectedImage = img;
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (UIImage *)resizePhoto:(UIImage *)originalImage newSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);// a CGSize that has the size you want
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSData *)compressImage:(UIImage *)image {
    NSData *unCompressedImage = UIImageJPEGRepresentation(image, 1.0);
    if ([unCompressedImage length]<1000*MAXImageKbSizeBeforeCompression) {
        return unCompressedImage;
    }
    else return UIImageJPEGRepresentation(image, POSTImageQuality);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
