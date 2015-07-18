//
//  NSArray+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/14/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "CMLoggerCategoryExtensions.h"
#import "CMLogger.h"

@implementation NSArray (CMLogger)

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
        [outputString appendFormat:@"array with %lu objects\n", (unsigned long)[self count]];
        NSString *tabString = @"    ";
        CMLogger *logger = [CMLogger logger];
        for (id object in self)
            {
            if ([object respondsToSelector:@selector(logDescriptionWithSpacing:)])
                {
                [outputString appendFormat:@"%@%@%u - %@:: %@", spaceString, tabString, count, [logger getValidClassName:[object class]], [object logDescriptionWithSpacing:[spaceString stringByAppendingString:tabString]]];
                }
            else
                {
                [outputString appendFormat:@"%@%@%u - %@\n", spaceString, tabString, count, [logger getValidClassName:[object class]]];
                }
            count++;
            }
        }
    return outputString;
}

@end
