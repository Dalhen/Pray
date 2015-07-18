//
//  UIButton+AppExtensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIButton+AppExtensions.h"
#import "UIButton+Extensions.h"

#define kUIButton_NavButtonFont [UIFont fontWithName:@"OpenSans-Semibold" size:12]

#define kUIButton_backgroundImage @"TitleBarButton.png"
#define kUIButton_cogImage @"TitleBarSettingsIcon.png"
#define kUIButton_dashboardImage @"TitleBarDashboardIcon.png"
#define kUIButton_backImage @"TitleBarBackButton.png"

@implementation UIButton (AppExtensions)

#pragma mark - utility
+(UIButton *)configButton
{
    return [UIButton buttonWithBackgroundImageName:kUIButton_backgroundImage imageName:kUIButton_cogImage frame:CGRectMake(0, 0, 30, 30)];
}

+(UIButton *)loginButton
{
    UIButton *button = [UIButton buttonWithBackgroundImageName:kUIButton_backgroundImage title:@"Login" frame:CGRectMake(0, 0, 70, 30) textColor:Colour_255RGB(215, 214, 214) font:kUIButton_NavButtonFont];
    return button;
}

+(UIButton *)closeButton
{
    UIButton *button = [UIButton buttonWithBackgroundImageName:kUIButton_backgroundImage title:@"Close" frame:CGRectMake(0, 0, 70, 30) textColor:Colour_255RGB(215, 214, 214) font:kUIButton_NavButtonFont];
    return button;
}

+(UIButton *)logoutButton
{
    UIButton *button = [UIButton buttonWithBackgroundImageName:kUIButton_backgroundImage title:@"Logout" frame:CGRectMake(0, 0, 70, 30) textColor:Colour_255RGB(215, 214, 214) font:kUIButton_NavButtonFont];
    return button;
}

+(UIButton *)dashboardButton
{
    return [UIButton buttonWithBackgroundImageName:kUIButton_backgroundImage imageName:kUIButton_dashboardImage frame:CGRectMake(0, 0, 38, 30)];
}

+(UIButton *)backButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[JXImageCache imageNamed:kUIButton_backImage] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 3)] forState:UIControlStateNormal];
    [button setTitle:@"   Back" forState:UIControlStateNormal];
    [button setTitleColor:Colour_255RGB(215, 214, 214) forState:UIControlStateNormal];
    button.titleLabel.font = kUIButton_NavButtonFont;
    button.frame = CGRectMake(0, 0, 50, 30);
    return button;
}

+(UIButton *)mapButtonWithIconName:(NSString *)iconName
{
    return [UIButton buttonWithBackgroundImageName:@"VenueGuideCommonElement.png" imageName:iconName frame:CGRectMake(0, 0, 40, 40)];
}

@end
