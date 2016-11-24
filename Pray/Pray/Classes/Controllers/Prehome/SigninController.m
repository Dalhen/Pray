//
//  SigninController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SigninController.h"
#import "BaseView.h"
#import "InviteFriends.h"
@interface SigninController ()

@end

@implementation SigninController


- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self setupLayout];
    [self setupHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [emailField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.UserServices.LoginSuccess, loginSuccess:);
    Notification_Observe(JXNotification.UserServices.LoginFailed, loginFailed);
    Notification_Observe(JXNotification.UserServices.ResetPasswordSuccess, resetPasswordSuccess);
    Notification_Observe(JXNotification.UserServices.ResetPasswordFailed, resetPasswordFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.LoginSuccess);
    Notification_Remove(JXNotification.UserServices.LoginFailed);
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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight)];
    [scrollView setContentSize:CGSizeMake(self.view.screenWidth, self.view.screenHeight + 120*sratio)];
    [self.view addSubview:scrollView];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayLogo"]];
    [logoImage setFrame:CGRectMake(0, 52*sratio, 84*sratio, 88*sratio)];
    [logoImage setContentMode:UIViewContentModeCenter];
    [scrollView addSubview:logoImage];
    [logoImage centerHorizontallyInSuperView];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(18*sratio, 170*sratio, self.view.screenWidth - 36*sratio, 42*sratio)];
    [emailField setTextAlignment:NSTextAlignmentLeft];
    [emailField setFont:[FontService systemFont:13*sratio]];
    [emailField setTextColor:Colour_PrayBlue];
    [emailField setPlaceholder:LocString(@"Your email")];
    [emailField setBackgroundColor:Colour_White];
    UIView *padding1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding1 setBackgroundColor:Colour_Clear];
    [emailField setLeftView:padding1];
    [emailField setLeftViewMode:UITextFieldViewModeAlways];
    [emailField setReturnKeyType:UIReturnKeyNext];
    [emailField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailField.layer setCornerRadius:3.0f*sratio];
    [emailField setDelegate:self];
    [scrollView addSubview:emailField];
    
    passwordField = [[UITextField alloc] initWithFrame:CGRectMake(18*sratio, emailField.bottom + 20*sratio, self.view.screenWidth - 36*sratio, 42*sratio)];
    [passwordField setTextAlignment:NSTextAlignmentLeft];
    [passwordField setFont:[FontService systemFont:13*sratio]];
    [passwordField setTextColor:Colour_PrayBlue];
    [passwordField setPlaceholder:LocString(@"Password")];
    [passwordField setBackgroundColor:Colour_White];
    UIView *padding2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14*sratio, 40*sratio)];
    [padding2 setBackgroundColor:Colour_Clear];
    [passwordField setLeftView:padding2];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordField setReturnKeyType:UIReturnKeyNext];
    [passwordField setSecureTextEntry:YES];
    [passwordField.layer setCornerRadius:3.0f*sratio];
    [passwordField setDelegate:self];
    [scrollView addSubview:passwordField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, passwordField.bottom + 20*sratio, 176*sratio, 40*sratio)];
    [loginButton setTitle:LocString(@"SIGN IN") forState:UIControlStateNormal];
    [loginButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [loginButton setBackgroundColor:Colour_PrayBlue];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [loginButton.layer setCornerRadius:3.0f*sratio];
    [scrollView addSubview:loginButton];
    [loginButton centerHorizontallyInSuperView];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setFrame:CGRectMake(0, loginButton.bottom + 10*sratio, 220*sratio, 36*sratio)];
    [resetButton setTitle:LocString(@"Forgot your password?") forState:UIControlStateNormal];
    [resetButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[FontService systemFont:12*sratio]];
    [resetButton setBackgroundColor:Colour_Clear];
    [resetButton addTarget:self action:@selector(askForPasswordReset) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:resetButton];
    [resetButton centerHorizontallyInSuperView];
}


#pragma mark - Login process
- (void)login {
    [SVProgressHUD showWithStatus:LocString(@"Logging in...") maskType:SVProgressHUDMaskTypeGradient];
    [NetworkService loginUserWithEmail:emailField.text password:passwordField.text];
}

- (void)loginSuccess:(NSNotification *)notification {
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
    
    [AppDelegate launchPushNotifications];
//    [AppDelegate displayMainView];
    InviteFriends *signinController = [[InviteFriends alloc] init];
    [self.navigationController pushViewController:signinController animated:YES];

}

- (void)loginFailed {
    [SVProgressHUD dismiss];
    
    [[[UIAlertView alloc] initWithTitle:LocString(@"Login failed.") message:LocString(@"We couldn't log you in. Please check your email/password and try again.") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
}

- (NSString *)validString:(NSString *)string {
    return (string && ![string isKindOfClass:[NSNull class]])? string : @"";
}


#pragma mark - Reset Password
- (void)askForPasswordReset {
    [[[UIAlertView alloc] initWithTitle:LocString(@"Reset your password?") message:LocString(@"Do you really want to reset your password? We'll send you an email to do so.") delegate:self cancelButtonTitle:LocString(@"No") otherButtonTitles:LocString(@"Yes, reset it!"), nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self resetPassword];
    }
}

- (void)resetPassword {
    if ([emailField.text length]>0) {
        [NetworkService resetPasswordForEmailAddress:emailField.text];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:LocString(@"Password reset") message:LocString(@"Please enter a valid email address before proceeding.") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
    }
}

- (void)resetPasswordSuccess {
    [[[UIAlertView alloc] initWithTitle:LocString(@"Password reset") message:LocString(@"We've sent you an email to reset your password and get a temporary one.") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
}

- (void)resetPasswordFailed {
    [[[UIAlertView alloc] initWithTitle:LocString(@"Password reset") message:LocString(@"We couldn't reset your password. Please check the email provided and try again.") delegate:nil cancelButtonTitle:LocString(@"Ok") otherButtonTitles:nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
