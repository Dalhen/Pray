//
//  InviteFriends.m
//  Pray
//
//  Created by Clement on 24/11/2016.
//  Copyright © 2016 Pray Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FeedController.h"
#import "PKRevealController.h"
#import "CommentsController.h"
#import "SearchController.h"
#import "ProfileController.h"
#import "UsersListController.h"
#import "SDWebImagePrefetcher.h"
#import "InviteFriends.h"
#import "BaseView.h"

@interface InviteFriends ()
@end

@implementation InviteFriends

- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self setupLayout];
}


- (void)setupLayout {
    
    UIImageView *backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundWelcome.jpg"]];
    [backImage setFrame:self.view.frame];
    [backImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:backImage];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight)];
    [scrollView setContentSize:CGSizeMake(self.view.screenWidth, self.view.screenHeight)];
    [self.view addSubview:scrollView];
    
   logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayLogo"]];
    [logoImage setFrame:CGRectMake(0, 110*sratio, 90*sratio, 96*sratio)];
    [logoImage setContentMode:UIViewContentModeCenter];
    [scrollView addSubview:logoImage];
    [logoImage centerHorizontallyInSuperView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, logoImage.bottom + 192*sratio, 176*sratio, 40*sratio)];
    [loginButton setTitle:LocString(@"Invite my friends") forState:UIControlStateNormal];
    [loginButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [loginButton setBackgroundColor:Colour_PrayBlue];
    [loginButton addTarget:self action:@selector(friendsConnect) forControlEvents:UIControlEventTouchUpInside];
    [loginButton.layer setCornerRadius:3.0f*sratio];
    [scrollView addSubview:loginButton];
    [loginButton centerHorizontallyInSuperView];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setFrame:CGRectMake(0, loginButton.bottom + 30*sratio, 220*sratio, 36*sratio)];
    [resetButton setTitle:LocString(@"Continue to Pray") forState:UIControlStateNormal];
    [resetButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [resetButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [resetButton setBackgroundColor:Colour_255RGB(64, 67, 79)];
    [resetButton addTarget:self action:@selector(Continue) forControlEvents:UIControlEventTouchUpInside];
    [resetButton.layer setCornerRadius:5*sratio];

    [scrollView addSubview:resetButton];
    [resetButton centerHorizontallyInSuperView];
}

-(void)Continue{
    [AppDelegate displayMainView];
}

- (void)friendsConnect {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[@"Join and pray with me on PRAY! Download the app here: https://itunes.apple.com/us/app/pray-for-iphone/id860868081?mt=8"] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
