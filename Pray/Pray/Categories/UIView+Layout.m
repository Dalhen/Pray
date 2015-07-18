//
//  UIView+Layout.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIView+Layout.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Layout)

- (void) removeSubviews {
	for(UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
}

- (double)width {
	CGRect frame = [self frame];
	return frame.size.width;
}

- (void)setWidth:(double)value {
	CGRect frame = [self frame];
	frame.size.width = round(value);
	[self setFrame:frame];
}

- (double)height {
	CGRect frame = [self frame];
	return frame.size.height;	
}

- (void)setHeight:(double)value {
	CGRect frame = [self frame];
	frame.size.height = round(value);
	[self setFrame:frame];
}

- (void)setSize:(CGSize)size {
	CGRect frame = [self frame];
	frame.size.width = round(size.width);
	frame.size.height = round(size.height);
	[self setFrame:frame];
}

- (CGSize)size {
	CGRect frame = [self frame];
	return frame.size;
}

- (CGPoint)origin {
	CGRect frame = [self frame];
	return frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect frame = [self frame];
	frame.origin.x = origin.x;
	frame.origin.y = origin.y;
	[self setFrame:frame];
}

- (CGFloat)left {
	return self.origin.x;
}

- (CGFloat)right {
	return self.origin.x + self.size.width;
}

- (CGFloat)top {
	return self.origin.y;
}

- (CGFloat)bottom {
	return self.origin.y + self.size.height;
}

- (void)setLeft:(CGFloat)value {
	CGRect frame = [self frame];
	frame.origin.x = value;
	[self setFrame:frame];	
}

- (void)setRight:(CGFloat)value {
	CGRect frame = [self frame];
	frame.origin.x = value - frame.size.width;
	[self setFrame:frame];	
}

- (void)setTop:(CGFloat)value {
	CGRect frame = [self frame];
	frame.origin.y = value;
	[self setFrame:frame];
}

- (void)setBottom:(CGFloat)value {
	CGRect frame = [self frame];
	frame.origin.y = value - frame.size.height;
	[self setFrame:frame];
}

- (void) centerInSuperView {
	double xPos = round(([self.superview width] - [self width]) / 2.0);
	double yPos = round(([self.superview height] - [self height]) / 2.0);	
	[self setOrigin:CGPointMake(xPos, yPos)];
}

- (void) centerHorizontallyInSuperView {
	double xPos = round(([self.superview width] - [self width]) / 2.0);
	self.left = xPos;
}

- (void) centerVerticallyInSuperView {
	double yPos = round(([self.superview height] - [self height]) / 2.0);	
    self.top  = yPos;
}

- (void) bringToFront {
	[self.superview bringSubviewToFront:self];	
}

- (void) sendToBack {
	[self.superview sendSubviewToBack:self];
}

- (void)verticalAlignToView:(UIView *)aView {
	self.top = roundf(aView.top + ((aView.size.height - self.size.height) * 0.5));
}

- (void)horizontalAlignToView:(UIView *)aView {
	self.left = roundf(aView.left + ((aView.size.width - self.size.width) * 0.5));	
}

- (void)resizeForSubviews {
    float w = 0;
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

- (void)show
{
    self.alpha = 1.0;
}

- (void)hide
{
    self.alpha = 0.0;
}

- (void)showAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self show];
                     }];
}

- (void)hideAnimated
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self hide];
                     }];
}

- (void)hideViews:(UIView *)view, ... {
    va_list args;
    va_start(args, view);
    
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        arg.alpha = 0.0;
    }
    va_end(args);
}

- (void)showViews:(UIView *)view, ... {
    va_list args;
    va_start(args, view);
    
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView *)) {
        arg.alpha = 1.0;
    }
    va_end(args);
}

- (void) addShadowWithColor:(UIColor *)shadowColor
                     offset:(CGSize)offset
                     radius:(float)radius
                 andOpacity:(float)opacity
{
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void) addBorderWithColor:(UIColor *)borderColor
                   andWidth:(float)radius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = radius;
}

- (void) addRoundEdgesWithRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end
