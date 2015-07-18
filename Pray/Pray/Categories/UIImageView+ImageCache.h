//
//  UIImageView+ImageCache.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCache)

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName;
+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName;

- (id)initWithImageNamed:(NSString *)anImageName;
- (id)initWithImageNamed:(NSString *)image highlightedImageName:(NSString *)highlightedImage;

@end
