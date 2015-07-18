//
//  JXFontService.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXFontService.h"

#define kJXFontMedium @"Omnes-Medium"
#define kJXFontSemiBold @"Omnes-Semibold"
#define kJXFontMediumItalic @"Omnes-MediumItalic"

@implementation JXFontService
@synthesize appFontSize;


#pragma mark - Shared instance
+ (JXFontService *)sharedInstance
{
    static JXFontService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXFontService alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initializer
-(JXFontService *)init
{
    self = [super init];
    if (self){
    }
    return self;
}


#pragma mark - Font fetching
- (UIFont *)prayRegular:(NSInteger)fontSize {
    return [UIFont fontWithName:kJXFontMedium size:fontSize];
}
    
- (UIFont *)prayBold:(NSInteger)fontSize {
    return [UIFont fontWithName:kJXFontSemiBold size:fontSize];
}

- (UIFont *)prayRegularItalic:(NSInteger)fontSize {
    return [UIFont fontWithName:kJXFontMediumItalic size:fontSize];
}

- (UIFont *)systemFont:(NSInteger)fontSize {
    return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)systemFontBold:(NSInteger)fontSize {
    return [UIFont boldSystemFontOfSize:fontSize];
}

@end
