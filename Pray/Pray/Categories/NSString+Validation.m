//
//  NSString+Validation.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidString
{
    return ([self isValidObject] && ![self isEqualToString:@""]);
}

@end
