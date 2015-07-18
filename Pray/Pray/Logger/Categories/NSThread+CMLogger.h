//
//  NSThread+CMLogger.h
//  CMLogger
//
//  Created by Jason LAPIERRE on 19/10/2012.
//  Copyright (c) 2012 Jason LAPIERRE a.k.a. The One Man Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (CMLogger)
- (NSString *) logDescriptionWithSpacing:(NSString *)spaceString;
- (NSString *) logStackDescriptionWithSpacing:(NSString *)spaceString;
@end
