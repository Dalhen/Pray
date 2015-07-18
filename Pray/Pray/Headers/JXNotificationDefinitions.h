//
//  JXNotificationDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

#define NotificationCenter  [NSNotificationCenter defaultCenter]

#define Notification_Observe(notification, method)  [NotificationCenter addObserver:self selector:@selector(method) name:notification object:nil];
#define Notification_RemoveObserver                 [NotificationCenter removeObserver:self];

#define Notification_Post(notification, anObject)     [NotificationCenter postNotificationName:notification object:anObject];

#define Notification_PostInfo(notification, info)   [NotificationCenter postNotificationName:notification object:self userInfo:info];

#define Notification_Remove(notification)           [NotificationCenter removeObserver:self name:notification object:nil];

