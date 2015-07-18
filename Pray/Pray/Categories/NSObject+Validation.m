//
//  NSObject+Validation.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSObject+Validation.h"

@implementation NSObject (Validation)

+ (BOOL) object:(NSObject *)object1 isEqual:(NSObject *)object2 {
	BOOL result;
	if (object1 && object2)
	{
		result = [object1 isEqual:object2];
	}
	else
	{
		result = (object1 == object2);
	}
	return result;
}

-(BOOL)isValidObject
{
    return (self && ![self isEqual:[NSNull null]]);
}

@end
