//
//  UIView+Roundify.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIView+Roundify.h"

@implementation UIView (Roundify)

-(void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CALayer *tMaskLayer = [self maskForRoundedCorners:corners withRadii:radii];
    
    UIView *tSuperview = self.superview;
    if (tSuperview) {
        [self removeFromSuperview];
    }
    
    self.layer.mask = tMaskLayer;
    
    if (tSuperview) {
        [tSuperview addSubview:self];
    }
}

-(CALayer*)maskForRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:
                                 maskLayer.bounds byRoundingCorners:corners cornerRadii:radii];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    maskLayer.path = [roundedPath CGPath];
    //maskLayer.borderWidth = 1.0f;
    //maskLayer.borderColor = Colour_BrownBoxBorder.CGColor;
    
    return maskLayer;
}

@end