//
//  NSArray+Extension.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

#pragma mark - utility
- (id)firstObject {
	if(self.count == 0) {
		return nil;
	}
	
	return [self objectAtIndex:0];
}

- (id)randomObject {
 	if(self.count == 0) {
		return nil;
	}
	
	return [self objectAtIndex:arc4random() % self.count];
}

@end
