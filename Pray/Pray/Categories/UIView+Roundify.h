//
//  UIView+Roundify.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Roundify)

-(void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;
-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

@end
