//
//  UINavigationController+Fade.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UINavigationController (fade)

- (void)pushFadeViewController:(UIViewController *)aController;
- (void)popFadeViewController;
- (void)pushFlipViewController:(UIViewController *)aController;
- (void)popFlipViewController;

@end
