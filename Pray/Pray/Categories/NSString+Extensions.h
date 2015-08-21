//
//  NSString+Extensions.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

@interface NSString (Extensions)

#pragma mark - generation
+ (NSString *)UUIDString;
+ (NSString *)randomFirstName;
+ (NSString *)randomLastName;
+ (NSString *)randomTitle;
+ (NSString *)randomWord;
+ (NSString *)randomAlphaStringWithLength:(int)len andNumeric:(BOOL)isNumeric;
+ (NSString *)lipsumWithParagraphs:(NSUInteger)numberOfParagraphs;
+ (NSString *)shortLipsum;
+ (NSString *)mediumLipsum;
+ (NSString *)longLipsum;

#pragma mark - validation
- (BOOL)isValidEmailAddress;
- (BOOL)isValidWebAddress;
- (BOOL)isValidPhoneNumber;

#pragma mark - comparison
- (BOOL)containsString:(NSString *)string;
- (BOOL)hasOnlyCharactersInString:(NSString *)string;
- (BOOL)hasNoCharactersInString:(NSString *)string;

#pragma mark - search
- (BOOL)isIn:(NSString *)stringsToCompare, ...;

#pragma mark - utility
- (NSString*) trim;


@end
