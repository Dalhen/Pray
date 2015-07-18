//
//  NSNotificationCenter+MultiThreading.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

#import "NSNotificationCenter+Extensions.h"

/*-----------------------------------------------------------------------------------------------------*/

@implementation NSNotificationCenter (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notifications
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)postNotificationOnMainThread:(NSNotification *)notification
{
    if ([[NSThread currentThread] isMainThread])
    {
        [NotificationCenter postNotification:notification];
    }
    else
    {
        [NotificationCenter performSelectorOnMainThread:@selector(postNotification:)
                                             withObject:notification
                                          waitUntilDone:NO];
    }
}

+ (void)postNotificationNameOnMainThread:(NSString *)notificationName
                                  object:(id)notificationObject
{
    if ([[NSThread currentThread] isMainThread])
    {
        [NotificationCenter postNotificationName:notificationName
                                          object:notificationObject];
    }
    else
    {
        NSNotification *notification = [NSNotification notificationWithName:notificationName
                                                                     object:notificationObject];
        [NotificationCenter performSelectorOnMainThread:@selector(postNotification:)
                                             withObject:notification
                                          waitUntilDone:NO];
    }
}
+ (void)postNotificationNameOnMainThread:(NSString *)notificationName
                                  object:(id)notificationObject
                                userInfo:(NSDictionary *)userInfoDictionary
{
    if ([[NSThread currentThread] isMainThread])
    {
        [NotificationCenter postNotificationName:notificationName
                                          object:notificationObject
                                        userInfo:userInfoDictionary];
    }
    else
    {
        NSNotification *notification = [NSNotification notificationWithName:notificationName
                                                                     object:notificationObject
                                                                   userInfo:userInfoDictionary];
        [NotificationCenter performSelectorOnMainThread:@selector(postNotification:)
                                             withObject:notification
                                          waitUntilDone:NO];
    }
}

@end
