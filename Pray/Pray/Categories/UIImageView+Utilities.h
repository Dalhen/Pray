//
//  UIImageView+Utilities.h
//  Jason LAPIERRE
//
//  Created by Jason LAPIERRE on 25/11/2013.
//  Copyright (c) 2013 Jason LAPIERRE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utilities)


- (UIImage *) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)sourceImage;

@end
