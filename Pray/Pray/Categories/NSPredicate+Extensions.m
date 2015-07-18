//
//  NSPredicate+Extensions.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSPredicate+Extensions.h"

@implementation NSPredicate (Extensions)

- (NSPredicate *)andPredicateByAppendingPredicate:(NSPredicate *)aPredicate {
    return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:self, aPredicate, nil]];
}

- (NSPredicate *)orPredicateByAppendingPredicate:(NSPredicate *)aPredicate {
    return [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:self, aPredicate, nil]];
}

- (NSPredicate *)notPredicateByAppendingPredicate:(NSPredicate *)aPredicate {
    return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:self, aPredicate, nil]];
}


@end
