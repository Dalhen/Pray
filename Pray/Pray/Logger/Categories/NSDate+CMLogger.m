//
//  NSDate+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/25/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "NSDate+CMLogger.h"

@implementation NSDate (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd/MM/yyyy"];
    return [NSString stringWithFormat:@"%@\n", [dateFormatter stringFromDate:self]];
}

@end
