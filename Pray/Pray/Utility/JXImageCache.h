//
//  JXImageCache.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol JXImageCacheDelegate<NSObject>

- (void)imageDownloaded:(UIImage *)image forUrl:(NSString *)url;

@end

@interface JXImageCache : NSObject {
	NSMutableDictionary *images;
	NSMutableDictionary *downloads;
}

+ (JXImageCache *)instance;
+ (void)clearCache;
+ (UIImage *)imageNamed:(NSString *)imageName;
+ (UIImage *)imageFromPath:(NSString *)imagePath;
+ (UIImage *)imageFromCache:(NSString *)imageName;
+ (void)cacheImage:(UIImage *)image forName:(NSString *)imageName;
+ (void)uncacheImageForName:(NSString *)imageName;
+ (void)downloadAndCacheImageUrl:(NSString *)url delegate:(id<JXImageCacheDelegate>)delegate;
+ (void)delegateClosing:(id<JXImageCacheDelegate>)delegate;

- (void)clearCache;
- (UIImage *)imageNamed:(NSString *)imageName;
- (UIImage *)imageFromPath:(NSString *)imagePath;
- (UIImage *)imageFromCache:(NSString *)imageName;
- (void)cacheImage:(UIImage *)image forName:(NSString *)imageName;
- (void)uncacheImageForName:(NSString *)imageName;
- (void)downloadAndCacheImageUrl:(NSString *)url delegate:(id<JXImageCacheDelegate>)delegate;
- (void)delegateClosing:(id<JXImageCacheDelegate>)delegate;

@end
