//
//  UILabel+DynamicHeight.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (DynamicHeight)

+ (double) getSizeWithText:(NSString *)text andWidth:(double)width forFont:(UIFont *)font;
- (double) setText:(NSString *)text withWidth:(double)width;
- (void) alignTop;
- (void) alignBottom;

@end
