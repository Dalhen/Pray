//
//  NSNumber+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSNumber+Extensions.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSNumber (Extensions)

#pragma mark - arithmetic
- (NSNumber *)increase {
    NSUInteger value = [self intValue] + 1.0;
    return [NSNumber numberWithInt:(CC_LONG)value];
}

- (NSNumber *)decrease {
    NSUInteger value = [self intValue] - 1.0;
    return [NSNumber numberWithInt:(CC_LONG)value];
}

- (NSNumber *)add:(NSNumber *)aNumber{
    CGFloat result = [self floatValue] + [aNumber floatValue];
    return [NSNumber numberWithFloat:result];
}

- (NSNumber *)subtract:(NSNumber *)aNumber {
    CGFloat result = [self floatValue] - [aNumber floatValue];
    return [NSNumber numberWithFloat:result];
}

- (NSNumber *)multiply:(NSNumber *)aNumber{
    CGFloat result = [self floatValue] * [aNumber floatValue];
    return [NSNumber numberWithFloat:result];
}

- (NSNumber *)divide:(NSNumber *)aNumber{
    CGFloat result = [self floatValue] / [aNumber floatValue];
    return [NSNumber numberWithFloat:result];
}

#pragma mark - comparison
- (BOOL)isGreaterThanNumber:(NSNumber *)aNumber {
    return [self compare:aNumber] == NSOrderedDescending;
}

- (BOOL)isGreaterThanOrEqualToNumber:(NSNumber *)aNumber {
    NSComparisonResult result = [self compare:aNumber];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

- (BOOL)isLessThanNumber:(NSNumber *)aNumber {
    return [self compare:aNumber] == NSOrderedAscending;
}

- (BOOL)isLessThanOrEqualToNumber:(NSNumber *)aNumber {
    NSComparisonResult result = [self compare:aNumber];
    return result == NSOrderedAscending || result == NSOrderedSame;
}

@end
