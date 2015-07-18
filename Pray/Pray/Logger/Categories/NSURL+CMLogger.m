//
//  NSURL+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/25/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "NSURL+CMLogger.h"

@implementation NSURL (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    return [NSString stringWithFormat:@"%@\n", [self description]];
}

@end
