//
//  UIImageView+ImageCache.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "JXImageCache.h"

@implementation UIImageView (ImageCache)

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName
{
    return [[UIImageView alloc] initWithImageNamed:imageName];
}

+ (UIImageView *)imageViewWithImageNamed:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName
{
    return [[UIImageView alloc] initWithImageNamed:imageName highlightedImageName:highlightedImageName];
}

- (id)initWithImageNamed:(NSString *)anImageName
{
    return [self initWithImage:[JXImageCache imageNamed:anImageName]];
}

- (id)initWithImageNamed:(NSString *)image highlightedImageName:(NSString *)highlightedImage
{
    return [self initWithImage:[JXImageCache imageNamed:image] highlightedImage:[JXImageCache imageNamed:highlightedImage]];
}

@end
