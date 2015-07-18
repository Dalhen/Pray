//
//  NSMutableArray+StringSerialiser.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (StringSerialiser)

- (NSString *) stringValue;
+ (NSMutableArray *) fromStringValue:(NSString *)string;

@end
