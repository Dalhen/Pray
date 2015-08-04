//
//  JXNetwork.m
//  VortexVault
//
//  Created by Jason LAPIERRE on 23/10/2013.
//  Copyright (c) 2015 Jason LAPIERRE. All rights reserved.
//

#import "JXNetworkService.h"
#import "AFHTTPRequestOperationManager.h"
#import <CommonCrypto/CommonDigest.h>


#define serverBase @"http://pray" //DEMO
//#define serverBase @"http://pray" //LIVE

#define OAuthClientID @"pray-client"
#define OAuthClientSecret @"pray-secret"
#define OAuthGrantType @"client_credentials"


@implementation JXNetworkService

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXNetworkService *)sharedInstance {
    static JXNetworkService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXNetworkService alloc] init];
    });
    return sharedInstance;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self)
    {
    }
    return self;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Authentication
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData *)getSHA512FromString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    if ( CC_SHA1([data bytes], (CC_LONG)[data length], hash) ) {
        NSData *sha512 = [NSData dataWithBytes:hash length:CC_SHA512_DIGEST_LENGTH];
        return sha512;
    }
    return nil;
}

- (NSString *)getMD5FromString:(NSString *)source {
    const char *src = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, (CC_LONG)strlen(src), result);
    NSString *ret = [[NSString alloc] initWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                     ];
    return [ret lowercaseString];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OAuth
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)checkAccessTokenAndCall:(NSString *)urlToGet isPost:(BOOL)isPost includedImages:(NSArray *)images parameters:(NSMutableDictionary *)params successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    if (![UserService isOAuthExpired]) {
        if (isPost) {
            if ([images count]>0) {
                [self formPost:urlToGet images:images parameters:params successBlock:successBlock failureBlock:failureBlock];
            }
            else {
                [self post:urlToGet parameters:params successBlock:successBlock failureBlock:failureBlock];
            }
        }
        else [self get:urlToGet parameters:params successBlock:successBlock failureBlock:failureBlock];
    }
    else {
        void (^innersuccessBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
            if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
            
            NSInteger statusCode = [operation.response statusCode];
            
            //success
            if (statusCode == 200) {
                [UserService setOAuthToken:[responseObject objectForKey:@"access_token"]];
                
                NSDate *expiracyDate = [NSDate dateWithTimeIntervalSinceNow:[[responseObject objectForKey:@"expires_in"] intValue]];
                [UserService setOAuthExpiracy:expiracyDate];
                
                [params setObject:[UserService getOAuthToken] forKey:@"access_token"];
                if (isPost) {
                    if ([images count]>0) {
                        [self formPost:urlToGet images:images parameters:params successBlock:successBlock failureBlock:failureBlock];
                    }
                    else {
                        [self post:urlToGet parameters:params successBlock:successBlock failureBlock:failureBlock];
                    }
                }
                else [self get:urlToGet parameters:params successBlock:successBlock failureBlock:failureBlock];
            }
            
            //invalid
            else {
                Notification_Post(JXNotification.UserServices.UpdateOAuthTokenFailed, nil);
            }
        };
        
        void (^innerfailureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
            if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
            Notification_Post(JXNotification.UserServices.UpdateOAuthTokenFailed, nil);
        };
        
        NSMutableDictionary *innerparams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            OAuthClientID, @"client_id",
                                            OAuthClientSecret, @"client_secret",
                                            OAuthGrantType, @"grant_type", nil];
        
        [self post:@"oauth/access_token" parameters:innerparams successBlock:innersuccessBlock failureBlock:innerfailureBlock];
    }
}

- (void)generateAccessToken {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [UserService setOAuthToken:[responseObject objectForKey:@"access_token"]];
            Notification_Post(JXNotification.UserServices.UpdateOAuthTokenSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UpdateOAuthTokenFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UpdateOAuthTokenFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   OAuthClientID, @"client_id",
                                   OAuthClientSecret, @"client_secret",
                                   OAuthGrantType, @"grant_type", nil];
    
    [self checkAccessTokenAndCall:@"oauth/access_token" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Generic call
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)get:(NSString *)urlToGet parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    //    [parameters addEntriesFromDictionary:[self generateAuthDigestWithParameters:parameters]];
    //
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    [parameters addEntriesFromDictionary:@{@"app_version": version}];
    //
    //    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    [parameters addEntriesFromDictionary:@{@"lang": currentLanguage}];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/%@", serverBase, urlToGet] parameters:parameters success:successBlock failure:failureBlock];
}

- (void)post:(NSString *)urlToGet parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    //    [parameters addEntriesFromDictionary:[self generateAuthDigestWithParameters:parameters]];
    //
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    [parameters addEntriesFromDictionary:@{@"app_version": version}];
    //
    //    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    [parameters addEntriesFromDictionary:@{@"lang": currentLanguage}];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@/%@", serverBase, urlToGet] parameters:parameters success:successBlock failure:failureBlock];
}

- (void)postWithDownloadProgress:(NSString *)urlToGet parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    //    [parameters addEntriesFromDictionary:[self generateAuthDigestWithParameters:parameters]];
    //
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    [parameters addEntriesFromDictionary:@{@"app_version": version}];
    //
    //    NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    [parameters addEntriesFromDictionary:@{@"lang": currentLanguage}];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", serverBase, urlToGet] relativeToURL:manager.baseURL] absoluteString] parameters:parameters];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        if (((float)totalBytesWritten/ totalBytesExpectedToWrite) < 1 && totalBytesExpectedToWrite>0) {
            //            Notification_Post(JXNotification.MomentsServices.UpdateUploadProgress, [NSNumber numberWithFloat:(float)totalBytesWritten/totalBytesExpectedToWrite]);
        }
    }];
    
    [operation start];
}

- (void)formPost:(NSString *)urlToGet images:(NSArray *)imagesFiles parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", serverBase, urlToGet] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSInteger i = 0; i<[imagesFiles count]; i++) {
            NSData *imageData = [imagesFiles objectAtIndex:i];
            [formData appendPartWithFileData:imageData name:@"avatar_image"
                                    fileName:[NSString stringWithFormat:@"photo%li.jpg", (long)i]
                                    mimeType:@"image/jpeg"];
        }
    } success:successBlock failure:failureBlock];
}

- (BOOL)getServerStatusWithResponse:(NSDictionary *)responseObject {
    return ([[[responseObject objectForKey:@"status"] objectForKey:@"valid"] isEqualToString:@"true"]);
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Signup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateDeviceToken:(NSData *)deviceToken {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.UpdateDeviceTokenSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UpdateDeviceTokenFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UpdateDeviceTokenFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   @"0", @"device",
                                   deviceToken, @"device_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/device" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)validateEmail:(NSString *)email {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.ValidateEmailSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ValidateEmailFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ValidateEmailFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   email, @"email",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/auth/validateEmail" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)signupWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                   password:(NSString *)password
                 linkedinID:(NSString *)linkedinID
                      email:(NSString *)email
                   position:(NSString *)position
                        bio:(NSString *)bio
               departmentID:(NSString *)departmentID
                  avatarURL:(NSString *)avatarURL
                avatarImage:(NSData *)avatarImage {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200 && [[responseObject objectForKey:@"success"] isEqualToString:@"true"]) {
            Notification_Post(JXNotification.UserServices.RegistrationSuccess, responseObject);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.RegistrationFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.RegistrationFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   firstName, @"first_name",
                                   lastName, @"last_name",
                                   password, @"password",
                                   email, @"email",
                                   position, @"position",
                                   departmentID, @"department_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    NSMutableArray *avatarImageArray = [[NSMutableArray alloc] init];
    if (avatarImage) {
        [avatarImageArray addObject:avatarImage];
    }
    
    if (avatarURL) {
        [params setObject:avatarURL forKey:@"avatar"];
    }
    
    if (bio) {
        [params setObject:bio forKey:@"bio"];
    }
    
    if (bio) {
        [params setObject:bio forKey:@"bio"];
    }
    
    if (linkedinID) {
        [params setObject:linkedinID forKey:@"linkedin_id"];
    }
    
    
    [self checkAccessTokenAndCall:@"api/v1/auth/register" isPost:YES includedImages:avatarImageArray parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.LoginSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.LoginFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.LoginFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   email, @"email",
                                   password, @"password",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/auth/login" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)loginUserWithLinkedIn:(NSString *)linkedInID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.LoginSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.LoginFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.LoginFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   linkedInID, @"linkedin_id",
                                   
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/auth/loginLinkedIn" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)updateLocationWithCityName:(NSString *)cityName
                          latitude:(NSString *)latitude
                         longitude:(NSString *)longitude {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [UserService setCity:cityName];
            Notification_Post(JXNotification.UserServices.UpdateLocationSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UpdateLocationFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UpdateLocationFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   cityName, @"city",
                                   latitude, @"latitude",
                                   longitude, @"longitude",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/location" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)resetPasswordForEmailAddress:(NSString *)email {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.ResetPasswordSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ResetPasswordFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ResetPasswordFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   email, @"email",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/auth/password/sendReset" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)updateProfileWithFirstname:(NSString *)firstName
                          lastName:(NSString *)lastName
                          password:(NSString *)password
                          position:(NSString *)position
                      departmentID:(NSString *)departmentID
                    departmentName:(NSString *)departmentName
                       avatarImage:(NSData *)avatarImage
                               bio:(NSString *)bio {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [UserService setFirstName:firstName];
            [UserService setLastName:lastName];
            if (password)[UserService setPassword:password];
            [UserService setPosition:position];
            [UserService setDepartmentID:departmentID];
            [UserService setDepartmentName:departmentName];
            [UserService setAvatarURL:[self validString:[[responseObject objectForKey:@"data"] objectForKey:@"avatar"]]];
            [UserService setBio:bio];
            
            Notification_Post(JXNotification.UserServices.UpdateUserDetailsSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UpdateUserDetailsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UpdateUserDetailsFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUsername], @"email",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    if (firstName) {
        [params setObject:firstName forKey:@"first_name"];
    }
    
    if (lastName) {
        [params setObject:lastName forKey:@"last_name"];
    }
    
    if (position) {
        [params setObject:position forKey:@"position"];
    }
    
    if (bio) {
        [params setObject:bio forKey:@"bio"];
    }
    
    if (departmentID) {
        [params setObject:departmentID forKey:@"department_id"];
    }
    else [params setObject:[UserService getDepartmentID] forKey:@"department_id"];
    
    if (password) {
        [params setObject:avatarImage forKey:@"password"];
    }
    
    NSMutableArray *avatarImageArray = [[NSMutableArray alloc] init];
    if (avatarImage) {
        [avatarImageArray addObject:avatarImage];
    }
    
    [self checkAccessTokenAndCall:@"api/v1/user/update" isPost:YES includedImages:avatarImageArray parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Feed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeed {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.FeedServices.LoadFeedSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.LoadFeedFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.LoadFeedFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/feed" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)deletePostWithID:(NSString *)postId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.FeedServices.DeletePostSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.DeletePostFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.DeletePostFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   postId, @"post_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/post/delete" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)reportPostWithID:(NSString *)postId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.FeedServices.ReportPostSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.ReportPostFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.ReportPostFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   postId, @"post_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/post/report" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Post
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postPrayerWithImage:(NSData *)prayerImage andText:(NSString *)prayerText {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.PostServices.PostPrayerSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.PostServices.PostPrayerFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.PostServices.PostPrayerFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   prayerText, @"text",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    NSMutableArray *prayerImageArray = [[NSMutableArray alloc] init];
    if (prayerImage) {
        [prayerImageArray addObject:prayerImage];
    }
    
    [self checkAccessTokenAndCall:@"api/v1/post" isPost:YES includedImages:prayerImageArray parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Cards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getUsersToMachWithDepartmentID:(NSString *)departmentID locationID:(NSString *)locationID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.GetUsersToMatchSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetUsersToMatchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetUsersToMatchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   departmentID, @"department_id",
                                   locationID, @"location_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/users" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)getDepartmentsForCompanyID:(NSString *)companyID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.GetCompanyDepartmentsSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetCompanyDepartmentsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetCompanyDepartmentsFailed, nil);
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:[NSString stringWithFormat:@"api/v1/companies/%@", companyID] isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)getLocationsForCompanyID:(NSString *)companyID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.GetCompanyLocationsSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetCompanyLocationsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetCompanyLocationsFailed, nil);
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:[NSString stringWithFormat:@"api/v1/companies/%@/locations", companyID] isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Cards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wantToMatchUser:(NSString *)userID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.WantToMatchSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.WantToMatchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.WantToMatchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userID, @"invitee_id",
                                   [UserService getUserID], @"inviter_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches/invite" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)confirmMatchWithUser:(NSString *)userID date:(NSString *)dateString withPlusOne:(NSString *)plusOne {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.ConfirmMatchSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ConfirmMatchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ConfirmMatchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userID, @"inviter_id",
                                   dateString, @"lunch_date",
                                   (plusOne? @"1":@"0"), @"plus_one",
                                   [UserService getUserID], @"invitee_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches/confirm" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)getAllMatches {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.GetAllMatchesSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetAllMatchesFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetAllMatchesFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)changeMatch:(NSString *)matchID withDate:(NSString *)dateString withPlusOne:(NSString *)plusOne {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.ChangeMatchDateSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ChangeMatchDateFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ChangeMatchDateFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   matchID, @"match_id",
                                   dateString, @"lunch_date",
                                   (plusOne? @"1":@"0"), @"plus_one",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches/update" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)cancelMatch:(NSString *)matchID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.CancelMatchSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.CancelMatchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.CancelMatchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   matchID, @"match_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches/cancel" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)reportMatch:(NSString *)matchID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.ReportMatchSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ReportMatchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ReportMatchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   matchID, @"match_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/matches/report" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Chat
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewMessagesForMatch:(NSString *)matchId {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.UpdateMessagesSuccess, [responseObject objectForKey:@"data"]);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UpdateMessagesFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UpdateMessagesFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   matchId, @"match_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/messages" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)sendMessageWithText:(NSString *)text toMatch:(NSString *)matchId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.SendMessageSuccess, nil);
        }
        
        //invalid
        else {
            if(DEBUGConnections) NSLog(@"Error message: %@", nil);
            Notification_Post(JXNotification.UserServices.SendMessageFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.SendMessageFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   text, @"body",
                                   matchId, @"match_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/messages/send" isPost:YES includedImages:nil parameters:params successBlock:successBlock failureBlock:failureBlock];
}


- (NSString *)validString:(NSString *)string {
    return (string && ![string isKindOfClass:[NSNull class]])? string : @"";
}

@end
