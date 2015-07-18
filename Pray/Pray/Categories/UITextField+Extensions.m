//
//  UITextField+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UITextField+Extensions.h"

@implementation UITextField (Extensions)

+(UITextField *)textfieldWithFrame:(CGRect)frame textColor:(UIColor *)textColor clearMode:(UITextFieldViewMode)clearMode
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.clearButtonMode = clearMode;
    textField.textColor = textColor;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

+(UITextField *)textfieldWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText textColor:(UIColor *)textColor keyboardMode:(UIKeyboardType)keyboardMode clearMode:(UITextFieldViewMode)clearMode
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.clearButtonMode = clearMode;
    textField.textColor = textColor;
    textField.placeholder = placeholderText;
    textField.keyboardAppearance = (UIKeyboardAppearance)keyboardMode;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

@end
