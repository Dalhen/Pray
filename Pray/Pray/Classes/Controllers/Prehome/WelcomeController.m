//
//  WelcomeController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "WelcomeController.h"
#import "SigninController.h"
#import "SignupController.h"

@interface WelcomeController ()

@end

@implementation WelcomeController


- (void)loadView {
    self.view = [[UIView alloc] init];
    [self setupLayout];
}

- (void)setupLayout {
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundWelcome.jpg"]];
    [backImage setFrame:self.view.frame];
    [backImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backImage];
    
    logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayLogo"]];
    [logoImage setFrame:CGRectMake(0, 52*sratio, 84*sratio, 88*sratio)];
    [logoImage setContentMode:UIViewContentModeCenter];
    logoImage.alpha = 0;
    [self.view addSubview:logoImage];
    [logoImage centerHorizontallyInSuperView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*sratio, logoImage.bottom + 18*sratio, self.view.screenWidth - 40*sratio, 50*sratio)];
    [titleLabel setFont:[FontService systemFont:15*sratio]];
    [titleLabel setTextColor:Colour_White];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:LocString(@"Share your prayers with\nyour community.")];
    [titleLabel setNumberOfLines:2];
    logoImage.alpha = 0;
    [self.view addSubview:titleLabel];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.screenHeight, self.view.screenWidth, 208*sratio)];
    [bottomView setBackgroundColor:Colour_255RGB(38, 41, 50)];
    [self.view addSubview:bottomView];
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setFrame:CGRectMake(0, 26*sratio, 178*sratio, 40*sratio)];
    [facebookButton setTitle:LocString(@"FACEBOOK LOGIN") forState:UIControlStateNormal];
    [facebookButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [facebookButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [facebookButton setBackgroundColor:Colour_255RGB(89, 117, 177)];
    [facebookButton addTarget:self action:@selector(facebookConnect) forControlEvents:UIControlEventTouchUpInside];
    [facebookButton.layer setCornerRadius:5*sratio];
    [bottomView addSubview:facebookButton];
    [facebookButton centerHorizontallyInSuperView];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(0, facebookButton.bottom + 16*sratio, 178*sratio, 40*sratio)];
    [registerButton setTitle:LocString(@"SIGN UP") forState:UIControlStateNormal];
    [registerButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [registerButton setBackgroundColor:Colour_PrayBlue];
    [registerButton addTarget:self action:@selector(manualRegistration) forControlEvents:UIControlEventTouchUpInside];
    [registerButton.layer setCornerRadius:5*sratio];
    [bottomView addSubview:registerButton];
    [registerButton centerHorizontallyInSuperView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, registerButton.bottom + 28*sratio, 178*sratio, 40*sratio)];
    [loginButton setTitle:LocString(@"LOG IN") forState:UIControlStateNormal];
    [loginButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [loginButton setBackgroundColor:Colour_255RGB(64, 67, 79)];
    [loginButton addTarget:self action:@selector(manualLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginButton.layer setCornerRadius:5*sratio];
    [bottomView addSubview:loginButton];
    [loginButton centerHorizontallyInSuperView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.3 animations:^{
        [logoImage setAlpha:1.0];
        [titleLabel setAlpha:1.0];
        [bottomView setTop:self.view.screenHeight - 208*sratio];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.UserServices.FacebookLoginSuccess, facebookLoginSuccess);
    Notification_Observe(JXNotification.UserServices.FacebookLoginFailed, facebookLoginFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.FacebookLoginSuccess);
    Notification_Remove(JXNotification.UserServices.FacebookLoginFailed);
    Notification_RemoveObserver;
}


#pragma mark - Facebook Login
- (void)facebookConnect {
    
}

- (void)facebookLoginSuccess {
    
}

- (void)facebookLoginFailed {
    
}


#pragma mark - Manual Signup
- (void)manualRegistration {
    SignupController *signupController = [[SignupController alloc] init];
    [self.navigationController pushViewController:signupController animated:YES];
}


#pragma mark - Manual Signin
- (void)manualLogin {
    SigninController *signinController = [[SigninController alloc] init];
    [self.navigationController pushViewController:signinController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
