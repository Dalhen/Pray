//
//  UINavigationController+Transitions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXDirection.h"

/*-----------------------------------------------------------------------------------------------------*/

@interface UINavigationController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - transitions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushViewControllerWithFadeTransition:(UIViewController *)viewController;
- (void)popViewControllerWithFadeTransition;

/*-----------------------------------------------------------------------------------------------------*/

- (void)pushViewController:(UIViewController *)viewController
             withDirection:(JXDirection)direction;
- (void)popViewControllerWithDirection:(JXDirection)direction;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removePreviousViewController;
- (void)removeIntermediaryControllers;
- (void)addSkippedViewController:(UIViewController *)viewController;
- (void)addSkippedViewControllerAndRemoveIntermediary:(UIViewController *)viewController;

/*-----------------------------------------------------------------------------------------------------*/

- (void)setPreviousController:(UIViewController *)viewController;
- (void)setPreviousControllers:(NSArray *)viewControllers;

@end
