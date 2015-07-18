//
//  JXImageCache.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//


#import "JXImageCache.h"


@implementation JXImageCache

static JXImageCache *instance = nil;

#pragma mark -
#pragma mark Singleton Methods

+ (JXImageCache *)instance {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        instance = [[JXImageCache alloc] init];
    });
    
    return instance;
}

#pragma mark -
#pragma mark Convenience Methods

+ (void)clearCache {
	[[self instance] clearCache];
}

+ (UIImage *)imageNamed:(NSString *)imageName {
	return [UIImage imageNamed:imageName];
}

+ (UIImage *)imageFromPath:(NSString *)imagePath {
	return [[self instance] imageFromPath:imagePath];
}

+ (UIImage *)imageFromCache:(NSString *)imageName {
	return [[self instance] imageFromCache:imageName];
}

+ (void)cacheImage:(UIImage *)image forName:(NSString *)imageName {
	[[self instance] cacheImage:image forName:imageName];
}

+ (void)uncacheImageForName:(NSString *)imageName {
	[[self instance] uncacheImageForName:imageName];
}

+ (void)downloadAndCacheImageUrl:(NSString *)url delegate:(id<JXImageCacheDelegate>)delegate {
	[[self instance] downloadAndCacheImageUrl:url delegate:delegate];
}

+ (void)delegateClosing:(id<JXImageCacheDelegate>)delegate {
	[[self instance] delegateClosing:delegate];
}

#pragma mark -
#pragma mark Instance Methods

- (id)init {
	self = [super init];
	
	if(self != nil) {
		images = [[NSMutableDictionary alloc] init];
		downloads = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


#pragma mark -
#pragma mark Cache Methods

- (void)clearCache {
	[images removeAllObjects];
}
	
- (UIImage *)imageNamed:(NSString *)imageName {
	UIImage *image = [self imageFromCache:imageName];
	
	if(image != nil) {
		return image;
	}
	
	image = [UIImage imageNamed:imageName];
	[self cacheImage:image forName:imageName];
	
	return image;
}

- (UIImage *)imageFromPath:(NSString *)imagePath {
	UIImage *image = [self imageFromCache:imagePath];
	
	if(image != nil) {
		return image;
	}
	
	image = [UIImage imageWithContentsOfFile:imagePath];
	[self cacheImage:image forName:imagePath];
	
	return image;
}

- (UIImage *)imageFromCache:(NSString *)imageName {
	return [images objectForKey:imageName];
}

- (void)cacheImage:(UIImage *)image forName:(NSString *)imageName {
	if(image != nil) {
		[images setObject:image forKey:imageName];
	}
}

- (void)uncacheImageForName:(NSString *)imageName {
	[images removeObjectForKey:imageName];
}

- (void)downloadAndCacheImageUrl:(NSString *)url delegate:(id<JXImageCacheDelegate>)delegate {
	if(url == nil) {
		return;
	}
	
    UIImage *image = [self imageFromCache:url];
    
    if(image != nil) {
        [delegate imageDownloaded:image forUrl:url];
        return;
    }
    
	NSMutableArray *delegates = [downloads objectForKey:url];
	
	if(delegates == nil) {
		delegates = [NSMutableArray arrayWithObject:delegate];
		[downloads setObject:delegates forKey:url];
	} else {
        [delegates addObject:delegate];
    }
	
	[NSThread detachNewThreadSelector:@selector(downloadInThread:) toTarget:self withObject:url];
}

- (void)downloadInThread:(NSString *)url {
	@autoreleasepool {

		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
		UIImage *image = [[UIImage alloc] initWithData:imageData];	
		[self cacheImage:image forName:url];
		
		NSMutableArray *delegates = [NSMutableArray arrayWithArray:[downloads objectForKey:url]];
    
		for(id<JXImageCacheDelegate> delegate in delegates) {
        [delegate imageDownloaded:image forUrl:url];
		}
		
		[downloads removeObjectForKey:url];
	
	}
}

- (void)delegateClosing:(id<JXImageCacheDelegate>)delegate {
	for(NSString *url in [downloads allKeys]) {
		NSMutableArray *delegates = [downloads objectForKey:url];
		[delegates removeObject:delegate];
		
		if([delegates count] == 0) {
			[downloads removeObjectForKey:url];
		}
	}
}

@end
