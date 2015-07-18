//
//  JXDeviceFactory.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "JXDeviceManager.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation JXDeviceManager
@synthesize isRetina;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXDeviceManager *)sharedInstance
{
    static JXDeviceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXDeviceManager alloc] init];
    });
    return sharedInstance;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - lifecycle
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self)
    {
        float screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (screenHeight == 568)
        {
            self.deviceType = JXDeviceType_iPhone568;
        }
        else if (screenHeight == 480)
        {
            self.deviceType = JXDeviceType_iPhone480;
        }
        else
        {
            self.deviceType = JXDeviceType_iPad;
        }
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
            isRetina = YES;
        }
        else
        {
            isRetina = NO;
        }
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - utility
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(BOOL)isIpad
{
    return self.deviceType == JXDeviceType_iPad;
}

-(BOOL)isIphone480
{
    return self.deviceType == JXDeviceType_iPhone480;
}

- (BOOL)isIphone568
{
    return self.deviceType == JXDeviceType_iPhone568;
}

@end
