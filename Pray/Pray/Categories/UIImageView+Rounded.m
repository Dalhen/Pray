//
//  UIImageView+Rounded.m
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 20/11/2013.
//  Copyright (c) 2013 Jason LAPIERRE. All rights reserved.
//

#import "UIImageView+Rounded.h"

@implementation UIImageView (Rounded)

- (void)setRoundedToDiameter:(float)newSize {
    CGPoint saveCenter = self.center;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newSize, newSize);
    self.frame = newFrame;
    self.layer.cornerRadius = newSize / 2.0;
    self.center = saveCenter;
    [self setClipsToBounds:YES];
}

@end
