//
//  UINavigationController+Fade.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UINavigationController+Fade.h"
#import <QuartzCore/QuartzCore.h>


@implementation UINavigationController (fade)

#define kAnimationDuration	0.3f

- (void)pushFadeViewController:(UIViewController *)aController {
	CATransition *transition = [CATransition animation];
	transition.duration = kAnimationDuration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
	[self pushViewController:aController animated:NO];
}

- (void)popFadeViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = kAnimationDuration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
	[self popViewControllerAnimated:NO];
}


- (void)pushFlipViewController:(UIViewController *)aController {
    [UIView  transitionWithView:[[self.view subviews] objectAtIndex:0] duration:0.8  options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^(void) {
                         BOOL oldState = [UIView areAnimationsEnabled];
                         [UIView setAnimationsEnabled:NO];
                         [self pushViewController:aController animated:YES];
                         [UIView setAnimationsEnabled:oldState];
                     }
                     completion:nil];
}

- (void)popFlipViewController {
    [UIView  transitionWithView:[[self.view subviews] objectAtIndex:0] duration:0.8  options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^(void) {
                         BOOL oldState = [UIView areAnimationsEnabled];
                         [UIView setAnimationsEnabled:NO];
                         [self popViewControllerAnimated:YES];
                         [UIView setAnimationsEnabled:oldState];
                     }
                     completion:nil];
}

@end
