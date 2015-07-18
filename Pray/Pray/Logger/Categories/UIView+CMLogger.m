//
//  UIView+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/18/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "UIView+CMLogger.h"

@implementation UIView (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    NSString *tabString = @"    ";
    NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n%@%@subviews:    %lu\n", spaceString, tabString, (unsigned long)[[self subviews] count]];
    [outputString appendFormat:@"%@%@is hidden:   %s\n", spaceString, tabString, ([self isHidden] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@is opaque:   %s\n", spaceString, tabString, ([self isOpaque] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@clipping:    %s\n", spaceString, tabString, ([self clipsToBounds] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@interactive: %s\n", spaceString, tabString, ([self isUserInteractionEnabled] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@multitouch:  %s\n", spaceString, tabString, ([self isMultipleTouchEnabled] ? "YES" : "NO")];
    [outputString appendFormat:@"%@%@exclusive:   %s\n", spaceString, tabString, ([self isExclusiveTouch] ? "YES" : "NO")];
    CGRect frame = self.frame;
    [outputString appendFormat:@"%@%@frame:       ( %.0f, %.0f, %.0f, %.0f )\n", spaceString, tabString, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    CGRect bounds = self.bounds;
    [outputString appendFormat:@"%@%@bounds:      ( %.0f, %.0f, %.0f, %.0f )\n", spaceString, tabString, bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height];
    CGPoint center = self.center;
    [outputString appendFormat:@"%@%@center:      ( %.0f, %.0f)\n", spaceString, tabString, center.x, center.y];

    return outputString;
}

@end
