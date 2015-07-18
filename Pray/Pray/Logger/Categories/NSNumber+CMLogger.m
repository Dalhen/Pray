//
//  NSNumber+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/25/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "NSNumber+CMLogger.h"

@implementation NSNumber (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    return [NSString stringWithFormat:@"%@\n", [self stringValue]];
}

@end
