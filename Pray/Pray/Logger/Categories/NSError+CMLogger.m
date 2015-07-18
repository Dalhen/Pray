//
//  NSError+CMLogger.m
//  CMLogger
//
//  Created by Jason LAPIERRE on 19/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

#import "NSError+CMLogger.h"
#import "NSDictionary+CMLogger.h"

@implementation NSError (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString
{
    NSString *tabString = @"    ";
    NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n%@%@code:                  %ldd\n", spaceString, tabString,(long) (long)[self code]];
    [outputString appendFormat:@"%@%@domain:                %@\n", spaceString, tabString, [self domain]];
    [outputString appendFormat:@"%@%@description:           %@\n", spaceString, tabString, [self localizedDescription]];
    [outputString appendFormat:@"%@%@failure reason:        %@\n", spaceString, tabString, [self localizedFailureReason]];
    [outputString appendFormat:@"%@%@recoveryOptions:\n", spaceString, tabString];

    int count = 0;
    for (NSString *recoveryOption in [self localizedRecoveryOptions])
        {
        count ++;
        [outputString appendFormat:@"%@%@%@%d - %@\n", spaceString, tabString, tabString, count, recoveryOption];
        }
    
    [outputString appendFormat:@"%@%@recovery sugestion:    %@\n", spaceString, tabString, [self localizedRecoverySuggestion]];
    [outputString appendFormat:@"%@%@user info: %@\n", spaceString, tabString, [[self userInfo] logDescriptionWithSpacing:[NSString stringWithFormat:@"%@%@",spaceString,tabString]]];

    return outputString;
}

@end
