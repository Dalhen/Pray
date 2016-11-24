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
    
//    logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prayLogo"]];
//    [logoImage setFrame:CGRectMake(0, 110*sratio, 84*sratio, 88*sratio)];
//    [logoImage setContentMode:UIViewContentModeCenter];
//    logoImage.alpha = 0;
//    [self.view addSubview:logoImage];
//    [logoImage centerHorizontallyInSuperView];
//    
//    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*sratio, logoImage.bottom + 18*sratio, self.view.screenWidth - 40*sratio, 50*sratio)];
//    [titleLabel setFont:[FontService systemFont:15*sratio]];
//    [titleLabel setTextColor:Colour_White];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setText:LocString(@"Different Beliefs\nCommon Prayers")];
//    [titleLabel setNumberOfLines:2];
//    logoImage.alpha = 0;
//    [self.view addSubview:titleLabel];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.screenHeight, self.view.screenWidth, 208*sratio)];
    [bottomView setBackgroundColor:Colour_255RGB(38, 41, 50)];
    [self.view addSubview:bottomView];

    NSLog(@"arrive a la creatoin du bouton");
    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsButton setFrame:CGRectMake(0, 110*sratio, 84*sratio, 88*sratio)];
    [friendsButton setTitle:LocString(@"friends LOGIN") forState:UIControlStateNormal];
    [friendsButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [friendsButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [friendsButton setBackgroundColor:Colour_255RGB(89, 117, 177)];
    [friendsButton addTarget:self action:@selector(friendsConnect) forControlEvents:UIControlEventTouchUpInside];
    [friendsButton.layer setCornerRadius:5*sratio];
    [self.view addSubview:friendsButton];
    [friendsButton centerHorizontallyInSuperView];
    
    UIButton *ContinueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ContinueButton setFrame:CGRectMake(0, 350*sratio, 84*sratio, 88*sratio)];
    [ContinueButton setTitle:LocString(@"Continue") forState:UIControlStateNormal];
    [ContinueButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [ContinueButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [ContinueButton setBackgroundColor:Colour_255RGB(89, 117, 177)];
    [ContinueButton addTarget:self action:@selector(Continue) forControlEvents:UIControlEventTouchUpInside];
    [ContinueButton.layer setCornerRadius:5*sratio];
    [self.view addSubview:ContinueButton];
    [ContinueButton centerHorizontallyInSuperView];
}

-(void)Continue{
    [AppDelegate displayMainView];

}

- (void)friendsConnect {
    NSLog(@"Passe dans friendsconnect");
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[@"Join and pray with me on PRAY! Download the app here: https://itunes.apple.com/us/app/pray-for-iphone/id860868081?mt=8"] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}


@end
