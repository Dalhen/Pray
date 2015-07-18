//
//  UIButton+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName imageName:(NSString *)imageName frame:(CGRect)frame;
+ (UIButton *)buttonWithImageName:(NSString *)imageName frame:(CGRect)frame;
+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;
+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName title:(NSString *)title alternateTitle:(NSString *)alternateTitle frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;
+ (UIButton *)buttonWithImageName:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;
+ (UIButton *)blankButtonWithFrame:(CGRect)frame;
+ (UIButton *)buttonWithBackgroundImageName:(NSString *)backgroundImageName imageName:(NSString *)imageName title:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;
+ (UIButton *)buttonWithBackgroundColor:(UIColor *)colour title:(NSString *)title origin:(CGPoint)origin;

@end
