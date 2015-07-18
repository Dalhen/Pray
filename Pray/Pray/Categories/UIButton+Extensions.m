//
//  UIButton+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName imageName:(NSString *)imageName frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[JXImageCache imageNamed:backgroundImageName] stretchable] forState:UIControlStateNormal];
    [button setImage:[JXImageCache imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[JXImageCache imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}


+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[JXImageCache imageNamed:backgroundImageName] stretchable] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName title:(NSString *)title alternateTitle:(NSString *)alternateTitle frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[JXImageCache imageNamed:backgroundImageName] stretchable] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:alternateTitle forState:UIControlStateSelected];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateSelected];
    button.titleLabel.font = font;
    button.frame = frame;
    button.selected = NO;
    return button;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[JXImageCache imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName imageName:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[JXImageCache imageNamed:backgroundImageName] stretchable] forState:UIControlStateNormal];
    [button setImage:[JXImageCache imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.frame = frame;
    button.selected = NO;
    return button;
}

+ (UIButton *)blankButtonWithFrame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)colour title:(NSString *)title origin:(CGPoint)origin
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(origin.x, origin.y, 320-origin.x*2, 40)];
    [button.layer setCornerRadius:6.0f];
    [button setBackgroundColor:colour];
    [button setTitle:title forState:UIControlStateNormal];
    [button showsTouchWhenHighlighted];

    return button;
}


@end
