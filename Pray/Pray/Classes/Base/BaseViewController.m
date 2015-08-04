//
//  BaseViewController.m
//  Grape
//
//  Created by Jason LAPIERRE on 07/10/2013.
//  Copyright (c) 2013 - All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [navTitle setText:@""];
}


#pragma mark - setup
- (void)setupNavigationBar {
    if (!navTitle) {
        navTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.navigationController.navigationBar.width-240)/2, 0, 240, self.navigationController.navigationBar.height)];
        navTitle.font = [FontService prayRegular:13];
        navTitle.textColor = [UIColor blackColor];
        navTitle.adjustsFontSizeToFitWidth = YES;
        navTitle.textAlignment = NSTextAlignmentCenter;
        navTitle.backgroundColor = [UIColor clearColor];
        [self.navigationController.navigationBar addSubview:navTitle];
    }
    
    [self.navigationController.navigationBar setBarTintColor:Colour_White];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:Colour_White];
    self.navigationController.navigationBar.shadowImage = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setupTransparentNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]//[UIImage imageNamed:@"transparentHeaderGreen"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:YES];
    navTitle.textColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)setupPlainNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.shadowImage = nil;
    navTitle.textColor = Colour_DarkGray;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setupCustomBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 57, 17)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}


#pragma mark - Public customisation
- (void)setupTitle:(NSString *)titleText {
    [navTitle setText:titleText];
}

- (void)setupAsModal {
    [self.navigationController setNavigationBarHidden:NO];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 32, 32)];
    [cancelButton setImage:[UIImage imageNamed:@"cancelCrossButton"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *closeNavBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setLeftBarButtonItem:closeNavBtn];
}

- (void)closeModal {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
