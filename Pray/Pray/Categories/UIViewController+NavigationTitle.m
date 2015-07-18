//
//  UIViewController+NavigationTitle.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIViewController+NavigationTitle.h"
#import "UILabel+Dynamic.h"
#import "UIImage+Resize.h"

@implementation UIViewController (NavigationTitle)

#define kBarButtonBackgroundImage       @"BarButton.png"
#define kBackBarButtonBackgroundImage   @"AppTitleBarButtonBack.png"

- (void)setNavigationTitle:(NSString *)aTitle {
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setBackgroundColor:Colour_Clear];
    [titleLabel setTextColor:Colour_White];
    [titleLabel setFont:[UIFont fontWithName:@"KlavikaMedium-Plain" size:18]];
    [titleLabel setText:aTitle];
    [titleLabel resize];
    
    self.navigationItem.titleView = titleLabel;
}

- (UIButton *)addRightButtonWithTitle:(NSString *)title target:(id)aTarget selector:(SEL)aSelector {
    UIImage *buttonImage = [[JXImageCache imageNamed:kBarButtonBackgroundImage] stretchableWidth];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:10]];
    [aButton setTitle:title forState:UIControlStateNormal];
    [aButton sizeToFit];
    aButton.width = 67.0;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightButton;

    return aButton;
}

- (UIButton *)addLeftButtonWithTitle:(NSString *)title target:(id)aTarget selector:(SEL)aSelector backButton:(BOOL)isBackButton {
    
    UIImage *buttonImage = (isBackButton) ? [[JXImageCache imageNamed:kBackBarButtonBackgroundImage] stretchableImageWithLeftCapWidth:22.0 topCapHeight:0.0] : [[JXImageCache imageNamed:kBarButtonBackgroundImage] stretchableWidth];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, isBackButton ? kPadding : 0.0, 0.0, 0.0)];
    [aButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [aButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:10]];
    [aButton setTitle:title forState:UIControlStateNormal];
    [aButton sizeToFit];
    
    aButton.width = 67.0;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftButton;

    return aButton;
}

- (void)addRightButton:(UIButton *)button target:(id)aTarget selector:(SEL)aSelector
{
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = leftItem;
}

- (void)addLeftButton:(UIButton *)button target:(id)aTarget selector:(SEL)aSelector
{
    [button addTarget:aTarget action:aSelector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)removeLeftButton {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)removeRightButton {
    self.navigationItem.rightBarButtonItem = nil;
}




@end
