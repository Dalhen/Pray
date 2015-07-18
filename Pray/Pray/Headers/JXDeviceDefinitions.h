//
//  JXDeviceDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

#define ISIPHONE5()                                               ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define ISIPHONE4()                                               ([[UIScreen mainScreen] bounds].size.height < 568.0)
#define ISIPAD()                                                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define PLATFORM_VALUE(iPhoneValue, iPhone5Value)                 (ISIPHONE5() ? iPhone5Value : iPhoneValue)
#define PLATFORM_STRING(value) (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [NSString stringWithFormat:@"%@-iPad", value] : [NSString stringWithFormat:@"%@-iPhone", value]
#define PLATFORM_FILENAME(name, extension) [NSString stringWithFormat:@"%@.%@", PLATFORM_STRING(name), extension]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ISIOS6()                                    SYSTEM_VERSION_LESS_THAN(@"7.0")

#define isDemo ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isEqualToString:@""])
