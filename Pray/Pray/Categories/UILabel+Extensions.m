//
//  UILabel+AppExtensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font colour:(UIColor *)colour frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = Colour_Clear;
    label.textColor = colour;
    label.font = font;
    label.text = text;
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text textAlignment:(UITextAlignment)alignment font:(UIFont *)font colour:(UIColor *)colour frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = Colour_Clear;
    label.textColor = colour;
    label.font = font;
    label.textAlignment = (NSTextAlignment)alignment;
    label.text = text;
    return label;
}

@end
