//
//  UIViewController+NavigationTitle.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationTitle)

- (void)setNavigationTitle:(NSString *)aTitle;
- (UIButton *)addRightButtonWithTitle:(NSString *)title target:(id)aTarget selector:(SEL)aSelector;
- (UIButton *)addLeftButtonWithTitle:(NSString *)title target:(id)aTarget selector:(SEL)aSelector backButton:(BOOL)isBackButton;
- (void)addRightButton:(UIButton *)button target:(id)aTarget selector:(SEL)aSelector;
- (void)addLeftButton:(UIButton *)button target:(id)aTarget selector:(SEL)aSelector;
- (void)removeLeftButton;
- (void)removeRightButton;

@end
