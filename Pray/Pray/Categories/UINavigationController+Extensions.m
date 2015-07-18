//
//  UINavigationController+Transitions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "UINavigationController+Extensions.h"
#import <QuartzCore/QuartzCore.h>

/*-----------------------------------------------------------------------------------------------------*/

@implementation UINavigationController (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - transitions
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushViewControllerWithFadeTransition:(UIViewController *)viewController
{
    [self.view.layer addAnimation:[self baseFadeTransition]
                           forKey:kCATransition];
    [self pushViewController:viewController
                    animated:NO];
}

- (void)popViewControllerWithFadeTransition
{
    [self.view.layer addAnimation:[self baseFadeTransition]
                           forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)pushViewController:(UIViewController *)viewController
             withDirection:(JXDirection)direction
{
    [self.view.layer addAnimation:[self baseTransitionWithDirection:direction]
                           forKey:kCATransition];
    [self pushViewController:viewController
                    animated:NO];
}

- (void)popViewControllerWithDirection:(JXDirection)direction
{
    
    [self.view.layer addAnimation:[self baseTransitionWithDirection:direction]
                           forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

/*-----------------------------------------------------------------------------------------------------*/

- (CATransition *)baseTransition
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    return transition;
}

- (CATransition *)baseFadeTransition
{
    CATransition* transition = [self baseTransition];
    transition.type = kCATransitionFade;
    return transition;
}

- (CATransition *)baseTransitionWithDirection:(JXDirection)direction
{
    CATransition* transition = [self baseTransition];
    switch (direction) {
        case JXDirection_Up:
            transition.type = kCATransitionFromBottom;
            break;
        case JXDirection_Down:
            transition.type = kCATransitionFromTop;
            break;
        case JXDirection_Left:
            transition.type = kCATransitionFromRight;
            break;
        case JXDirection_Right:
            transition.type = kCATransitionFromLeft;
            break;
        default:
            printFailPointAndAbort;
            break;
    }
    return transition;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removePreviousViewController
{
    NSMutableArray *viewControllers = [[self viewControllers] mutableCopy];
    if (viewControllers.count > 1)
        {
        [viewControllers removeObjectAtIndex:(viewControllers.count-2)];
        self.viewControllers = viewControllers;
        }
}

- (void)removeIntermediaryControllers
{
    NSArray *viewControllers = [self viewControllers];
    if (viewControllers.count > 2)
        {
        NSArray *newStack = [NSArray arrayWithObjects:
                             [viewControllers objectAtIndex:0],
                             [viewControllers objectAtIndex:(viewControllers.count-1)],
                             nil];
        self.viewControllers = newStack;
        }
}

- (void)addSkippedViewController:(UIViewController *)viewController
{
    NSMutableArray *viewControllers = [[self viewControllers] mutableCopy];
    [viewControllers insertObject:viewController atIndex:viewControllers.count-1];
    self.viewControllers = viewControllers;
}

- (void)addSkippedViewControllerAndRemoveIntermediary:(UIViewController *)viewController
{
    NSArray *viewControllers = [self viewControllers];
    if (viewControllers.count > 2)
        {
        NSArray *newStack = [NSArray arrayWithObjects:
                             [viewControllers objectAtIndex:0],
                             viewController,
                             [viewControllers objectAtIndex:(viewControllers.count-1)],
                             nil];
        self.viewControllers = newStack;
        }
}

/*-----------------------------------------------------------------------------------------------------*/

- (void)setPreviousController:(UIViewController *)viewController
{
    NSArray *viewControllers = [self viewControllers];
    if (viewControllers.count > 1)
        {
        NSArray *newStack = [NSArray arrayWithObjects:
                             viewController,
                             [viewControllers objectAtIndex:(viewControllers.count-1)],
                             nil];
        self.viewControllers = newStack;
        }
}

- (void)setPreviousControllers:(NSArray *)viewControllers
{
    NSMutableArray *newStack = [NSMutableArray arrayWithArray:viewControllers];
    self.viewControllers = [newStack arrayByAddingObject:[self.viewControllers objectAtIndex:(viewControllers.count-1)]];
}

@end
