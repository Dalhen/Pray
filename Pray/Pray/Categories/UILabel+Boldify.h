//
//  UILabel+Boldify.h
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 03/03/2014.
//  Copyright (c) 2014 Notiss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Boldify)

- (void) boldSubstring: (NSString*) substring;
- (void) boldRange: (NSRange) range;

@end
