//
//  NSNumber+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSNumber (Extensions)

#pragma mark - arithmetic
- (NSNumber *)increase;
- (NSNumber *)decrease;
- (NSNumber *)add:(NSNumber *)aNumber;
- (NSNumber *)subtract:(NSNumber *)aNumber;
- (NSNumber *)multiply:(NSNumber *)aNumber;
- (NSNumber *)divide:(NSNumber *)aNumber;

#pragma mark - comparison
- (BOOL)isGreaterThanNumber:(NSNumber *)aNumber;
- (BOOL)isGreaterThanOrEqualToNumber:(NSNumber *)aNumber;
- (BOOL)isLessThanNumber:(NSNumber *)aNumber;
- (BOOL)isLessThanOrEqualToNumber:(NSNumber *)aNumber;

@end
