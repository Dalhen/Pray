//
//  UILabel+AppExtensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extensions)

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font colour:(UIColor *)colour frame:(CGRect)frame;
+ (UILabel *)labelWithText:(NSString *)text textAlignment:(UITextAlignment)alignment font:(UIFont *)font colour:(UIColor *)colour frame:(CGRect)frame;

@end
