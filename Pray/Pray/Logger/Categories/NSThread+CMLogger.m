//
//  NSThread+CMLogger.m
//  CMLogger
//
//  Created by Jason LAPIERRE on 19/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

#import "NSThread+CMLogger.h"

@implementation NSThread (CMLogger)
- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString
{
    NSString *tabString = @"    ";
    NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n%@%@name:             %@\n", spaceString, tabString, ([[self name] isEqualToString:@""] ? @"(null)" : [self name])];
    [outputString appendFormat:@"%@%@stack size:       %lu\n", spaceString, tabString, (unsigned long)[self stackSize]];
    [outputString appendFormat:@"%@%@is main thread:   %s\n", spaceString, tabString, ([self isMainThread] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@is multithreaded: %s\n", spaceString, tabString, ([NSThread isMultiThreaded] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@status:           %s\n", spaceString, tabString, ([self isExecuting] ? "executing" : [self isCancelled] ? "cancelled" : [self isFinished] ? "finished" : "n/a" )];
    [outputString appendFormat:@"%@%@priority:         %.3F\n", spaceString, tabString, [self threadPriority]];
    return outputString;
}

- (NSString *) logStackDescriptionWithSpacing:(NSString *)spaceString
{
    NSString *tabString = @"    ";
    NSMutableString *outputString = [NSMutableString string];
    NSArray *callStack = [NSThread callStackSymbols];
    NSArray *callStackAddresses = [NSThread callStackReturnAddresses];
    int callIndex = 0;
    for (NSString *call in callStack)
        {
        [outputString appendFormat:@"%@%@%@ - %@\n", spaceString, tabString, call, [[callStackAddresses objectAtIndex:callIndex] stringValue]];
        callIndex++;
        }
    
    return outputString;
}
@end
