//
//  UIImage+Tint.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

- (UIImage *) tintWithColor:(UIColor *)color andMask:(UIImage *)imageMask {
	UIGraphicsBeginImageContext(self.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
	
	CGContextScaleCTM(ctx, 1, -1);
	CGContextTranslateCTM(ctx, 0, -area.size.height);
	CGContextSaveGState(ctx);
	
	CGImageRef maskRef = [imageMask CGImage];
	
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),	CGImageGetDataProvider(maskRef), NULL, false);
	
	CGContextClipToMask(ctx, area, mask);
	
	[color set];
	CGContextFillRect(ctx, area);
	
	CGContextRestoreGState(ctx);
	CGContextSetBlendMode(ctx, kCGBlendModeMultiply);    
	CGContextDrawImage(ctx, area, self.CGImage);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CGImageRelease(mask);
	
	return newImage;
}

@end
