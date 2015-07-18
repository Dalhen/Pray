//
//  UILabel+Dynamic.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (Dynamic)

+ (double) getSizeWithText:(NSString *)text andWidth:(double)width forFont:(UIFont *)font;
- (double) setText:(NSString *)text withWidth:(double)width;
- (void) alignTop;
- (void) alignBottom;

- (void)resize;
- (void)resizeToWidth;

- (void)sizeTextToFitWidth:(CGFloat)aWidth fontName:(NSString *)aFontName fontSize:(CGFloat)aFontSize;

@end
