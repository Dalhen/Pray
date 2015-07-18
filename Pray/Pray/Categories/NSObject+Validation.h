//
//  NSObject+Validation.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

@interface NSObject (Validation)

+ (BOOL) object:(NSObject *)object1 isEqual:(NSObject *)object2;
-(BOOL)isValidObject;

@end
