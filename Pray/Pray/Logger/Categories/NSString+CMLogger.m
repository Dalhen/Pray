//
//  NSString+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/14/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "NSString+CMLogger.h"

@implementation NSString (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{    
    if ([self length] == 0)
        {
        return @"string is empty\n";
        }
    return [NSString stringWithFormat:@"\"%@\" (length: %lu)\n", self, (unsigned long)[self length]];
}

@end
