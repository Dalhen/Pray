//
//  UITextField+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extensions)

+(UITextField *)textfieldWithFrame:(CGRect)frame textColor:(UIColor *)textColor clearMode:(UITextFieldViewMode)clearMode;
+(UITextField *)textfieldWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText textColor:(UIColor *)textColor keyboardMode:(UIKeyboardType)keyboardMode clearMode:(UITextFieldViewMode)clearMode;

@end
