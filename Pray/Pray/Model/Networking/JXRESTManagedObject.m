//
//  JXRESTModel.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXRESTManagedObject.h"
#import <objc/runtime.h>

@implementation JXRESTManagedObject

- (void)ignoreDecodeKey:(NSString *)aKey {
    if(ignoreDecodeList == nil) {
        ignoreDecodeList = [[NSMutableSet alloc] init];
    }
    
    [ignoreDecodeList addObject:aKey];
}

- (void)ignoreEncodeKey:(NSString *)aKey {
    if(ignoreEncodeList == nil) {
        ignoreEncodeList = [[NSMutableSet alloc] init];
    }
    
    [ignoreEncodeList addObject:aKey];
}

- (void)addMappingFromKey:(NSString *)fromKey toKey:(NSString *)toKey {
    if(mappings == nil) {
        mappings = [[NSMutableDictionary alloc] init];
    }
    
    [mappings setObject:toKey forKey:fromKey];
}

- (void)addMappingFromKey:(NSString *)fromKey
              toClassName:(NSString *)className
    usingUniqueIdentifier:(NSString *)uniqueIdentifierKey
{
    if (classMapping == nil)
        {
        classMapping = [[NSMutableDictionary alloc] init];
        classUniqueIdentifierMapping = [[NSMutableDictionary alloc] init];
        }
    [classMapping setObject:classMapping
                     forKey:fromKey];
    [classUniqueIdentifierMapping setObject:uniqueIdentifierKey.isValidString ? uniqueIdentifierKey : @""
                                     forKey:fromKey];
}

- (void)setValue:(id)aValue forKey:(NSString *)aKey {
    if([ignoreDecodeList containsObject:aKey]) {
        return;
    }
    
    //this is to force the fetching of objects 
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    if (outCount > 0)
    {
        [self valueForKey:[NSString stringWithUTF8String:property_getName(properties[0])]];
    }
    
    NSString *classMappingObject = [classMapping objectForKey:aKey];
    if (classMappingObject)
        {
        if ([aValue isKindOfClass:[NSDictionary class]])
            {
                [CoreDataManager mergeJSONSubDictionary:aValue
                                   toManagedObjectNamed:classMappingObject
                                     usingIdentifierKey:[classUniqueIdentifierMapping objectForKey:aKey]
                                      JSONIdentifierKey:[classUniqueIdentifierMapping objectForKey:aKey]];
            }
        else if ([aValue isKindOfClass:[NSArray class]])
            {
                [CoreDataManager mergeJSONSubArray:aValue
                              toManagedObjectNamed:classMappingObject
                                usingIdentifierKey:[classUniqueIdentifierMapping objectForKey:aKey]
                                 JSONIdentifierKey:[classUniqueIdentifierMapping objectForKey:aKey]];
            }
        else
            {
            printFail(@"unknown type passed to object class mapping. will ignore ->");
            printObject(aValue);
            }
        return;
        }
    
    NSString *mapping = [mappings objectForKey:aKey];

    if(mapping != nil) {
        [super setValue:aValue forKey:mapping];
        return;
    }

    [super setValue:aValue forKey:aKey];
}

- (void)setValue:(id)aValue forUndefinedKey:(NSString *)aKey {
    if([aValue isEqual:[NSNull null]]) {
        return;
    }
    
    NSString *mapping = [mappings objectForKey:aKey];
    
    if(mapping != nil) {
        [self setValue:aValue forKey:mapping];
        return;
    }
    
    if([ignoreDecodeList containsObject:aKey]) {
        return;
    }
    
    [super setValue:aValue forUndefinedKey:aKey];
}

- (NSMutableDictionary *)dictionary {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];

        if([ignoreEncodeList containsObject:propertyName]) {
            continue;
        }

        id propertyValue = [self valueForKey:(NSString *)propertyName];

        if(propertyValue) { 
            if([propertyValue isKindOfClass:[NSDate class]]) {
                [data setObject:[outputFormatter stringFromDate:propertyValue] forKey:propertyName];
            } else {
                [data setObject:propertyValue forKey:propertyName];
            }
        }
    }
    
    free(properties);

    return data;
}

@end