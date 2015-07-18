//
//  JXFontService.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sizeSmall = 0,
    sizeMedium,
    sizeLarge,
}FontSize;

@interface JXFontService : NSObject
@property (nonatomic, unsafe_unretained) FontSize appFontSize;


#pragma mark - Shared Instance
+ (JXFontService *)sharedInstance;


#pragma mark - Font Fetching
- (UIFont *)prayRegular:(NSInteger)fontSize;
- (UIFont *)prayRegularItalic:(NSInteger)fontSize;
- (UIFont *)prayBold:(NSInteger)fontSize;
- (UIFont *)systemFont:(NSInteger)fontSize;
- (UIFont *)systemFontBold:(NSInteger)fontSize;

@end
