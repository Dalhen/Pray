//
//  NSSet+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 14/01/2013.
//  Copyright (c) 2013 Jason LAPIERRE. All rights reserved.
//

#import "NSSet+CMLogger.h"

@implementation NSSet (CMLogger)
- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString
{
    NSMutableString *outputString = [NSMutableString string];
    if ([self count] == 0)
        {
        [outputString appendFormat:@"set has no objects.\n"];
        }
    else
        {
        [outputString appendFormat:@"set with %lu objects\n", (unsigned long)[self count]];
        NSString *tabString = @"    ";
        CMLogger *logger = [CMLogger logger];
        for (id object in self)
            {
            if ([object respondsToSelector:@selector(logDescriptionWithSpacing:)])
                {
                [outputString appendFormat:@"%@%@- %@:: %@", spaceString, tabString, [logger getValidClassName:[object class]], [object logDescriptionWithSpacing:[spaceString stringByAppendingString:tabString]]];
                }
            else
                {
                [outputString appendFormat:@"%@%@- %@\n", spaceString, tabString, [logger getValidClassName:[object class]]];
                }
            }
        }
    return outputString;
}

@end
