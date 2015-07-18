//
//  NSData+Extension.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Extension)

#pragma mark - remote fetching
+ (NSData *) dataFromUrl:(NSString *)aUrl;

#pragma mark - encryption
+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSData *)AESEncryptWithKey:(NSString *)key;
- (NSData *)AESDecryptWithKey:(NSString *)key;
- (NSData *)SHA1Hash;

@end
