//
//  NSMutableArray+Access.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSMutableArray+Access.h"


@implementation NSMutableArray (Access)

- (id)firstObject {
	if(self.count == 0) {
		return nil;
	}
	
	return [self objectAtIndex:0];
}

- (void)removeFirstObject {
	if(self.count == 0) {
		return;
	}
	
	[self removeObjectAtIndex:0];
}

@end
