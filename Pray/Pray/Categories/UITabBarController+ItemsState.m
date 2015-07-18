//
//  UITabBarController+ItemsState.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UITabBarController+ItemsState.h"


@implementation UITabBarController (ItemsState)

- (void) setItemsEnabled:(BOOL)enabled {
	for(UITabBarItem *item in [self.tabBar items]) {
		[item setEnabled:enabled];
	}	
}

@end
