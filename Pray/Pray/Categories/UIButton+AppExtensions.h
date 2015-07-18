//
//  UIButton+AppExtensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AppExtensions)

#pragma mark - utility
+(UIButton *)configButton;
+(UIButton *)loginButton;
+(UIButton *)closeButton;
+(UIButton *)logoutButton;
+(UIButton *)dashboardButton;
+(UIButton *)backButton;
+(UIButton *)mapButtonWithIconName:(NSString *)iconName;

@end
