//
//  UIImage+Tint.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Tint)

- (UIImage *) tintWithColor:(UIColor *)color andMask:(UIImage *)imageMask;

@end
