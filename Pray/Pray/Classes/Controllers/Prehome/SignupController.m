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
#import "UIImageView+WebCache.h"

@interface SignupController ()

@end

@implementation SignupController


- (id)initForSignup {
    self = [super init];
    if (self) {
        isProfileEditing = NO;
    }
    
    return self;
}

- (id)initForProfileEditing {
    self = [super init];
    if (self) {
        isProfileEditing = YES;
    }
    
    return self;
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
    Notification_Observe(JXNotification.UserServices.RegistrationSuccess, signupAccountSuccess:);
    Notification_Observe(JXNotification.UserServices.RegistrationFailed, signupAccountFailed:);
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsSuccess, updateProfileSuccess:);
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsFailed, updateProfileFailed:);
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
    [backButton setImage:[UIImage imageNamed:@"backButtonWhite"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)setupLayout {
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundWelcome.jpg"]];
    [backImage setFrame:self.view.frame];
    [backImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backImage];
    
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 58*sratio, self.view.screenWidth, self.view.screenHeight - 58*sratio)];
    [mainScroll setContentSize:CGSizeMake(self.view.screenWidth, 522*sratio)];
    [mainScroll setDelegate:self];
    [self.view addSubview:mainScroll];
    
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90*sratio, 90*sratio)];
    [profileImage setImage:[UIImage imageNamed:@"avatarEmpty"]];
    [profileImage setRoundedToDiameter:90*sratio];
    [profileImage setClipsToBounds:YES];
    [mainScroll addSubview:profileImage];
    [profileImage centerHorizontallyInSuperView];
    
    if (isProfileEditing) {
        NSString *profileURL = [UserService getAvatarURL];
        if (![profileURL isEqualToString:@""] && profileURL) {
            [profileImage sd_setImageWithURL:[NSURL URLWithString:[UserService getAvatarURL]]];
        }
    }
    
    UIButton *profilePictureEditor = [UIButton buttonWithType:UIButtonTypeCustom];
    [profilePictureEditor setFrame:profileImage.frame];
    [profilePictureEditor addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:profilePictureEditor];
    
    profileUsername = [[UITextField alloc] initWithFrame:CGRectMake(0, profileImage.bottom + 40*sratio, 280*sratio, 42*sratio)];
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
    [profileUsername.layer setCornerRadius:5.0f*sratio];
    [profileUsername setDelegate:self];
    [mainScroll addSubview:profileUsername];
    [profileUsername centerHorizontallyInSuperView];
    
    if (isProfileEditing) {
        [profileUsername setText:[UserService getUsername]];
    }
    
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
    [profilePassword.layer setCornerRadius:5.0f*sratio];
    [profilePassword setDelegate:self];
    [mainScroll addSubview:profilePassword];
    [profilePassword centerHorizontallyInSuperView];
    
    if (isProfileEditing) {
        [profilePassword setText:[UserService getPassword]];
    }

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
    [profileEmail.layer setCornerRadius:5.0f*sratio];
    [profileEmail setDelegate:self];
    [mainScroll addSubview:profileEmail];
    [profileEmail centerHorizontallyInSuperView];
    
    if (isProfileEditing) {
        profileEmail.userInteractionEnabled = NO;
        profileEmail.enabled = NO;
        [profileEmail setText:[UserService getEmail]];
        [profileEmail setAlpha:0.7];
    }
    
    UIView *nameBox = [[UIView alloc] initWithFrame:CGRectMake(profileEmail.left, profileEmail.bottom + 14*sratio, 280*sratio, 42*sratio)];
    [nameBox setBackgroundColor:Colour_White];
    [nameBox.layer setCornerRadius:3.0f*sratio];
    [mainScroll addSubview:nameBox];
    
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
    [profileFirstName.layer setCornerRadius:5.0f*sratio];
    [profileFirstName setDelegate:self];
    [mainScroll addSubview:profileFirstName];
    
    if (isProfileEditing) {
        [profileFirstName setText:[UserService getFirstname]];
    }
    
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
    [profileLastName.layer setCornerRadius:5.0f*sratio];
    [profileLastName setDelegate:self];
    [mainScroll addSubview:profileLastName];
    
    if (isProfileEditing) {
        [profileLastName setText:[UserService getLastname]];
    }
    
    UIView *verticalSeparator = [[UIView alloc] initWithFrame:CGRectMake(profileFirstName.left + 120*sratio, profileFirstName.top + 8*sratio, 1, 28*sratio)];
    [verticalSeparator setBackgroundColor:Colour_255RGB(183, 183, 183)];
    [mainScroll addSubview:verticalSeparator];
    
    profileBlob = [[UITextView alloc] initWithFrame:CGRectMake(0, profileFirstName.bottom + 14*sratio, 280*sratio, 90*sratio)];
    [profileBlob setTextAlignment:NSTextAlignmentLeft];
    [profileBlob setFont:[FontService systemFont:13*sratio]];
    [profileBlob setTextColor:Colour_PrayBlue];
    [profileBlob setBackgroundColor:Colour_White];
    [profileBlob setReturnKeyType:UIReturnKeyDone];
    [profileBlob setUserInteractionEnabled:YES];
    [profileBlob setSelectable:YES];
    [profileBlob.layer setCornerRadius:5.0f*sratio];
    [profileBlob setDelegate:self];
    [mainScroll addSubview:profileBlob];
    [profileBlob centerHorizontallyInSuperView];
    
    if (isProfileEditing) {
        if (![[UserService getBio] isEqualToString:@""]) {
            [profileBlob setText:[UserService getBio]];
        }
        else {
            
        }
    }
    else {
        [profileBlob setText:LocString(@"Write something about you (optional)")];
        [profileBlob setTextColor:Colour_255RGB(200, 200, 200)];
    }
    
    UIButton *blobAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [blobAction setFrame:profileBlob.frame];
    [blobAction addTarget:self action:@selector(showBlobEditor) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:blobAction];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.screenHeight - 58*sratio, self.view.screenWidth, 58*sratio)];
    [bottomView setBackgroundColor:Colour_255RGB(38, 41, 50)];
    [self.view addSubview:bottomView];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, self.view.screenHeight - 70*sratio, 178*sratio, 42*sratio)];
    [saveButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [saveButton.layer setCornerRadius:5.0f*sratio];
    [saveButton setBackgroundColor:Colour_PrayBlue];
    if (isProfileEditing) {
        [saveButton setTitle:LocString(@"UPDATE") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(updateProfile) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [saveButton setTitle:LocString(@"SIGN UP") forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(signupAccount) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:saveButton];
    [saveButton centerHorizontallyInSuperView];
}


#pragma mark - Register
- (void)signupAccount {
    NSData *imageData = [self compressImage:selectedImage];
    
    if (![profileUsername.text isEqualToString:@""] &&
        ![profilePassword.text isEqualToString:@""] &&
        ![profileEmail.text isEqualToString:@""] &&
        ![profileFirstName.text isEqualToString:@""] &&
        ![profileLastName.text isEqualToString:@""]) {
        
        if ([profilePassword.text length]>= 6) {
            if ([profileUsername.text length]>2 && [profileUsername.text length]<16) {
                [SVProgressHUD showWithStatus:LocString(@"Signing up...") maskType:SVProgressHUDMaskTypeGradient];
                [NetworkService signupWithUsername:profileUsername.text firstName:profileFirstName.text lastName:profileLastName.text password:profilePassword.text email:profileEmail.text bio:profileBlob.text avatarURL:nil avatarImage:imageData];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:LocString(@"Incorrect Username") message:LocString(@"Please make sure your username lengh is contained between 3 and 15 characters.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:LocString(@"Incorrect Password") message:LocString(@"Please make sure your password is at least 6 characters before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    else {
        [[[UIAlertView alloc] initWithTitle:LocString(@"Fill the form") message:LocString(@"Please make sure you have filled your firstname, lastname, email, password and position before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)signupAccountSuccess:(NSNotification *)notification {
    
    [SVProgressHUD dismiss];
    
    NSDictionary *data = [notification object];
    [UserService setUserWithUsername:[self validString:[data objectForKey:@"username"]]
                               email:[self validString:[data objectForKey:@"email"]]
                              userID:[self validString:[data objectForKey:@"id"]]
                           firstname:[self validString:[data objectForKey:@"first_name"]]
                            lastname:[self validString:[data objectForKey:@"last_name"]]
                            fullname:[self validString:[data objectForKey:@"full_name"]]
                                 bio:[self validString:[data objectForKey:@"bio"]]
                                city:[self validString:[data objectForKey:@"city"]]
                          profileURL:[self validString:[data objectForKey:@"avatar"]]];
    
    [AppDelegate displayMainView];
    
//    LoginController *loginController = [[LoginController alloc] initWithEmail:profileEmail.text andPassword:profilePassword.text];
//    [self.navigationController setViewControllers:@[[self.navigationController.viewControllers objectAtIndex:0], loginController] animated:YES];
//    
//    [[[UIAlertView alloc] initWithTitle:LocString(@"Account created!") message:LocString(@"Your account has been created. Please click on the link in the email we've just sent you and press login.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)signupAccountFailed:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    
    if (notification.object) {
        
        NSInteger statusCode = [notification.object integerValue];
        
        switch (statusCode) {
            case 403:
                [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"This email is already registered on Pray. Please login or select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                break;
                
            case 406:
                [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"This username is already taken. Please select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                break;
                
            case 415:
                [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"Your image is incorrect. Please select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                break;
                
            default:
                [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"We couldn't create your account. Please check your internet connection and try again.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                break;
        }
    }
    
    else {
        [[[UIAlertView alloc] initWithTitle:LocString(@"Account creation") message:LocString(@"We couldn't create your account. Please check your internet connection and try again.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (NSString *)validString:(NSString *)string {
    return (string && ![string isKindOfClass:[NSNull class]])? string : @"";
}


#pragma mark - Profile Edition
- (void)updateProfile {
    NSData *imageData = [self compressImage:selectedImage];
    
    if (![profileUsername.text isEqualToString:@""] &&
        ![profileEmail.text isEqualToString:@""] &&
        ![profileFirstName.text isEqualToString:@""] &&
        ![profileLastName.text isEqualToString:@""]) {
        
        if ([profilePassword.text length]>= 6 || [profilePassword.text length] == 0) {
            [SVProgressHUD showWithStatus:LocString(@"Updating your profile...") maskType:SVProgressHUDMaskTypeGradient];
            
            if ([profileBlob.text isEqualToString:LocString(@"Write something about you (optional)")]) {
                [profileBlob setText:@""];
            }
            
            [NetworkService updateProfileWithUsername:profileUsername.text firstName:profileFirstName.text lastName:profileLastName.text password:profilePassword.text email:profileEmail.text bio:profileBlob.text avatarImage:imageData];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:LocString(@"Incorrect Password") message:LocString(@"Please make sure your password is at least 6 characters before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    else {
        [[[UIAlertView alloc] initWithTitle:LocString(@"Fill the form") message:LocString(@"Please make sure you have filled your firstname, lastname, email, password and position before proceeding.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)updateProfileSuccess:(NSNotification *)notification {
    [SVProgressHUD showSuccessWithStatus:LocString(@"Profile updated!")];
    
    NSDictionary *data = [notification object];
    [UserService setUserWithUsername:[self validString:[data objectForKey:@"username"]]
                               email:[self validString:[data objectForKey:@"email"]]
                              userID:[self validString:[data objectForKey:@"id"]]
                           firstname:[self validString:[data objectForKey:@"first_name"]]
                            lastname:[self validString:[data objectForKey:@"last_name"]]
                            fullname:[self validString:[data objectForKey:@"full_name"]]
                                 bio:[self validString:[data objectForKey:@"bio"]]
                                city:[self validString:[data objectForKey:@"city"]]
                          profileURL:[self validString:[data objectForKey:@"avatar"]]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateProfileFailed:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    
    NSInteger statusCode = [notification.object integerValue];
    
    switch (statusCode) {
        case 403:
            [[[UIAlertView alloc] initWithTitle:LocString(@"Profile update") message:LocString(@"This email is already registered on Pray. Please login or select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            break;
            
        case 406:
            [[[UIAlertView alloc] initWithTitle:LocString(@"Profile update") message:LocString(@"This username is already taken. Please select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            break;
            
        case 415:
            [[[UIAlertView alloc] initWithTitle:LocString(@"Profile update") message:LocString(@"Your image is incorrect. Please select another one.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            break;
            
        default:
            [[[UIAlertView alloc] initWithTitle:LocString(@"Profile update") message:LocString(@"We couldn't update your profile. Please check your internet connection and try again.") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            break;
    }
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


#pragma mark - UIScrollView delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        [profileUsername resignFirstResponder];
        [profileFirstName resignFirstResponder];
        [profileLastName resignFirstResponder];
        [profileEmail resignFirstResponder];
        [profilePassword resignFirstResponder];
        [profileBlob resignFirstResponder];
    }
}


#pragma mark - UITextField delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [mainScroll setContentSize:CGSizeMake(self.view.screenWidth, self.view.screenHeight + 200*sratio)];
    
    CGPoint bottomOffset;
    
    if (textField == profileUsername) {
        bottomOffset = CGPointMake(0, profileUsername.top);
    }
    else if (textField == profilePassword) {
        bottomOffset = CGPointMake(0, profilePassword.top);
    }
    else if (textField == profileEmail) {
        bottomOffset = CGPointMake(0, profileEmail.top);
    }
    else if (textField == profileFirstName) {
        bottomOffset = CGPointMake(0, profileFirstName.top);
    }
    else if (textField == profileLastName) {
        bottomOffset = CGPointMake(0, profileLastName.top);
    }
    
    [mainScroll setContentOffset:bottomOffset animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (textField == profileUsername) {
            [profilePassword becomeFirstResponder];
        }
        if (textField == profilePassword) {
            [profileEmail becomeFirstResponder];
        }
        else if (textField == profileEmail) {
            [profileFirstName becomeFirstResponder];
        }
        else if (textField == profileFirstName) {
            [profileLastName becomeFirstResponder];
        }
        else if (textField == profileLastName) {
            [profileBlob becomeFirstResponder];
        }
        return NO;
    }
    
    else {
        if (textField == profileUsername) {
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] length]<16) {
                if ([string isEqualToString:@" "]) {
                    [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:@"_"]];
                    return NO;
                }
                else return YES;
            }
            else return NO;
        }
        
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


#pragma mark - UITextView delegates
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:LocString(@"Write something about you (optional)")]) {
        [textView setText:@""];
        [textView setTextColor:Colour_PrayBlue];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [profileBlob resignFirstResponder];
        [mainScroll setContentSize:CGSizeMake(self.view.screenWidth, 590*sratio)];
        CGPoint bottomOffset = CGPointMake(0, mainScroll.contentSize.height - mainScroll.bounds.size.height);
        [mainScroll setContentOffset:bottomOffset animated:YES];
        return NO;
    }
    
    if ([[textView.text stringByReplacingCharactersInRange:range withString:text] length] > 170) {
        return NO;
    }
    
    return YES;
}


#pragma mark - Actions
- (void)showBlobEditor {
    [mainScroll setContentSize:CGSizeMake(self.view.screenWidth, 800*sratio)];
    CGPoint bottomOffset = CGPointMake(0, mainScroll.contentSize.height - mainScroll.bounds.size.height);
    [mainScroll setContentOffset:bottomOffset animated:YES];
    
    [profileBlob becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
