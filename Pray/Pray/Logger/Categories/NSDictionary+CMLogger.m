//
//  NSDictionary+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/16/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "CMLoggerCategoryExtensions.h"
#import "CMLogger.h"

@implementation NSDictionary (CMLogger)
- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    NSMutableString *outputString = [NSMutableString string];
    if ([self count] == 0)
        {
        [outputString appendFormat:@"array has no objects.\n"];
        }
    else
        {
        unsigned int count = 0;
        [outputString appendFormat:@"dictionary with %lu key <-> value pairs\n", (unsigned long)[self count]];
        NSString *tabString = @"    ";
        CMLogger *logger = [CMLogger logger];
        for (NSString *key in [self allKeys])
            {
            id object = [self objectForKey:key];
            if ([object respondsToSelector:@selector(logDescriptionWithSpacing:)])
                {
                [outputString appendFormat:@"%@%@%u - \"%@\" <-> %@:: %@", spaceString, tabString, count, key, [logger getValidClassName:[object class]], [object logDescriptionWithSpacing:[spaceString stringByAppendingString:tabString]]];
                }
            else
                {
                [outputString appendFormat:@"%@%@%u - \"%@\" <-> %@\n", spaceString, tabString, count, key, [logger getValidClassName:[object class]]];
                }
            count++;
            }
        }
    return outputString;
}

@end
