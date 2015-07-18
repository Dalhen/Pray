//
//  JXRESTModel.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXRESTManagedObject : NSManagedObject {
    NSMutableSet *ignoreDecodeList;
    NSMutableSet *ignoreEncodeList;
    NSMutableDictionary *mappings;
    NSMutableDictionary *classMapping;
    NSMutableDictionary *classUniqueIdentifierMapping;
}

#define REST_IGNORE_DECODE(aKey)                    [self ignoreDecodeKey:aKey]
#define REST_IGNORE_ENCODE(aKey)                    [self ignoreEncodeKey:aKey]
#define REST_MAP(sourceKey, destinationKey)         [self addMappingFromKey:sourceKey toKey:destinationKey]
#define REST_MAP_CLASS(sourceKey, destinationClass, uniqueIdentifierKey) [self addMappingFromKey:sourceKey toClassName:destinationClass usingUniqueIdentifier:uniqueIdentifierKey]

- (void)ignoreDecodeKey:(NSString *)aKey;
- (void)ignoreEncodeKey:(NSString *)aKey;
- (void)addMappingFromKey:(NSString *)fromKey
                    toKey:(NSString *)toKey;
- (void)addMappingFromKey:(NSString *)fromKey
              toClassName:(NSString *)className
    usingUniqueIdentifier:(NSString *)uniqueIdentifierKey;
- (NSMutableDictionary *)dictionary;

@end
