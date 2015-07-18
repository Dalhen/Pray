//
//  UIImageView+Utilities.m
//  Tigress
//
//  Created by Jason LAPIERRE on 25/11/2013.
//  Copyright (c) 2013 Jason LAPIERRE. All rights reserved.
//

#import "UIImageView+Utilities.h"

@implementation UIImageView (Utilities)


- (UIImage *) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)sourceImage {
    
    UIImage *newImage = nil;
    BOOL keepAspectRatio = NO;
    
    if (!keepAspectRatio) {
        // Don't care about aspect, stretch away....
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        
        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        {
            CGFloat widthFactor = targetWidth / width;
            CGFloat heightFactor = targetHeight / height;
            
            if (widthFactor > heightFactor)
                scaleFactor = widthFactor; // scale to fit height
            else
                scaleFactor = heightFactor; // scale to fit width
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            // center the image
            if (widthFactor > heightFactor)
            {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            else
                if (widthFactor < heightFactor)
                {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                }
        }
        
        //    UIGraphicsBeginImageContext(targetSize); // this will crop
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetSize.width, targetSize.height), NO, 0);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
            NSLog(@"could not scale image 1");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    } else {
        //NSLog(@"Keep Aspect");
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        //NSLog(@"current image wdith: %lf, height:%lf", width, height);
        //NSLog(@"frame wdith: %lf, height:%lf", self.frame.size.width, self.frame.size.height);
        
        CGFloat scaleFactor = 0;
        
        if (width > height) {
            // Landscape
            [self setAccessibilityHint:@"landscape"];
            if (width > self.frame.size.width) {
                // Image is too wide, adjust...
                scaleFactor = self.frame.size.width / width;
            }
        } else  if (height > width) {
            // Protrait
            [self setAccessibilityHint:@"portrait"];
            if (height > self.frame.size.height) {
                scaleFactor = self.frame.size.height / height;
            }
        } else {
            // Square
            [self setAccessibilityHint:@"square"];
        }
        //NSLog(@"ScaleFactor: %lf", scaleFactor);
        
        CGFloat scaledWidth  = width * scaleFactor;
        CGFloat scaledHeight = height * scaleFactor;
        
        //    UIGraphicsBeginImageContext(targetSize); // this will crop
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetSize.width, targetSize.height), NO, 0);
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0.0,0.0);
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        if (scaledWidth < imageSize.width) {
            CGRect thisFrame = self.frame;
            thisFrame.origin.x += (self.frame.size.width - scaledWidth) / 2;
            //thisFrame.size.width = scaledWidth;
            self.frame = thisFrame;
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
            NSLog(@"could not scale image 2");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

@end
