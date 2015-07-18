//
//  NSURL+SSLIgnore.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "NSMutableURLRequest+IgnoreSSL.h"

@implementation NSMutableURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {
    return YES;
}

@end


