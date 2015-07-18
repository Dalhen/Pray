//
//  UIColor+CMLogger.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 1/25/12.
//  Copyright (c) 2012 Jason LAPIERRE. All rights reserved.
//

#import "UIColor+CMLogger.h"

@implementation UIColor (CMLogger)

- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString 
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    [self getRed:&red 
            green:&green 
             blue:&blue 
            alpha:&alpha];

    if (alpha < 0 || red < 0 || green < 0 || blue < 0)
        {
        return @"color uses pattern image\n";
        }
    return [NSString stringWithFormat:@"R:%.3f | G:%.3f | B:%.3f | A:%.3f\n", red, green, blue, alpha];
}

@end
