//
//  NSPredicate+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate (Extensions)

- (NSPredicate *)andPredicateByAppendingPredicate:(NSPredicate *)aPredicate;
- (NSPredicate *)orPredicateByAppendingPredicate:(NSPredicate *)aPredicate;
- (NSPredicate *)notPredicateByAppendingPredicate:(NSPredicate *)aPredicate;

@end
