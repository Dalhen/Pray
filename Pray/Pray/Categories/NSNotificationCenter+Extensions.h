//
//  NSNotificationCenter+MultiThreading.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

/*-----------------------------------------------------------------------------------------------------*/

@interface NSNotificationCenter (Extensions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - notifications
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)postNotificationOnMainThread:(NSNotification *)notification;
+ (void)postNotificationNameOnMainThread:(NSString *)notificationName
                                  object:(id)notificationObject;
+ (void)postNotificationNameOnMainThread:(NSString *)notificationName
                                  object:(id)notificationObject
                                userInfo:(NSDictionary *)userInfoDictionary;

@end
