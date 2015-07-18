//
//  UILabel+Boldify.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 03/03/2014.
//  Copyright (c) 2014 Notiss. All rights reserved.
//

#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)


- (void) boldRange: (NSRange) range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    
    self.attributedText = attributedText;
}

- (void) boldSubstring: (NSString*) substring {
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

@end
