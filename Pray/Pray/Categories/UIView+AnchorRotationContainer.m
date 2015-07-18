//
//  UIView+AnchorRotationContainer.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIView+AnchorRotationContainer.h"

@implementation UIView (AnchorRotationContainer)
- (UIView *) rotationContainerForAnchorPoint:(CGPoint)anchorPoint 
{
    if (self.superview.tag == AnchorViewContainerTag) 
        {
        if (![self doesContainerCenterMatchAnchorPoint:anchorPoint]) 
            {
            [self adaptContainerFrameToAnchorPoint:anchorPoint];
            }
        return self.superview;
        }
    
    
    UIView *containerView = [self createRotationContainer];
    [self adaptContainerFrameToAnchorPoint:anchorPoint];
    [self.superview insertSubview:containerView 
                     aboveSubview:self];
    
    CGRect originalFrame = self.frame;
    CGRect newFrame = [self convertRect:originalFrame 
                                 toView:containerView];
    [self removeFromSuperview];
    [self setFrame:newFrame];
    [containerView addSubview:self];
    
    return containerView;
}

- (UIView *) createRotationContainer
{
    if (!(self.superview.tag == AnchorViewContainerTag)) 
        {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [containerView setClipsToBounds:NO];
        [containerView setBackgroundColor:[UIColor clearColor]];
        [containerView setAutoresizingMask:[self autoresizingMask]];
        return containerView;
        }
    
    printFail(@"method should never reach this point. are you calling the create rotation container method directly?");
    return nil;
    
}

- (void) removeRotationContainer 
{
    if (self.superview.tag == AnchorViewContainerTag) 
        {
        UIView *newSuperview = self.superview.superview;
        UIView *containerView = self.superview;
        
        CGRect originalFrame = self.frame;
        CGRect newFrame = [self convertRect:originalFrame 
                                     toView:newSuperview];
        
        [self removeFromSuperview];
        [self setFrame:newFrame];
        [newSuperview insertSubview:self 
                       aboveSubview:containerView];
        [containerView removeFromSuperview];
        }
    else 
        {
        printImportant(@"there is no rotation container set to remove.");
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CONTAINER ADAPTATION
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)adaptContainerFrameToAnchorPoint:(CGPoint)anchorPoint
{
    [self.superview setCenter:anchorPoint];
}

- (BOOL)doesContainerCenterMatchAnchorPoint:(CGPoint)anchorPoint
{
    if (self.superview.tag == AnchorViewContainerTag) 
        {
        int anchorPointX = anchorPoint.x - self.superview.center.x;
        int anchorPointY = anchorPoint.y - self.superview.center.y;
        int viewCenterX = self.superview.center.x;
        int viewCenterY = self.superview.center.y;
        
        if (anchorPointX == viewCenterX && anchorPointY == viewCenterY)
            {
            return YES;
            }
        
        return NO;
        }
    
    printFail(@"there is no rotation container set to match coordinates with anchor point: %@", NSStringFromCGPoint(anchorPoint));
    return NO;
}

@end
