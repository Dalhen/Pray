//
//  UIView+Layout.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Layout)

- (double)width;
- (void)setWidth:(double)width;

- (double)height;
- (void)setHeight:(double)height;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint) origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;

- (void)setLeft:(CGFloat)value;
- (void)setRight:(CGFloat)value;
- (void)setTop:(CGFloat)value;
- (void)setBottom:(CGFloat)value;

- (void) removeSubviews;
- (void) centerInSuperView;
- (void) centerHorizontallyInSuperView;
- (void) centerVerticallyInSuperView;

- (void) bringToFront;
- (void) sendToBack;

- (void)verticalAlignToView:(UIView *)aView;
- (void)horizontalAlignToView:(UIView *)aView;

- (void)hideViews:(UIView *)view, ...;
- (void)showViews:(UIView *)view, ...;

- (void)resizeForSubviews;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

@end
