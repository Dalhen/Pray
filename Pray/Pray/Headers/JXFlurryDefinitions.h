//
//  JXFlurryDefinitions.h
//
//
//  Created by Jason YL on 25/04/13.
//  Copyright (c) 2013 All rights reserved.
//

#define Flurry_Key                              @"AAAAA"

#ifdef ENABLE_ANALYTICS
#define Flurry_LogEvent(eventName,...)        [FlurryAnalytics logEvent:[NSString stringWithFormat:@"EVENT: %@", [NSString stringWithFormat:eventName, ##__VA_ARGS__]]];
#define Flurry_Start                          [FlurryAnalytics startSession:Flurry_Key];
#else
#define Flurry_LogEvent(eventName, ...)       print(@"%@", [NSString stringWithFormat:@"EVENT: %@", [NSString stringWithFormat:eventName, ##__VA_ARGS__]]);
#define Flurry_Start
#endif