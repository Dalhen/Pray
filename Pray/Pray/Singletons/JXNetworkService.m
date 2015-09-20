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


#define serverBase @"http://praydev.us.to" //DEMO
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
- (void)checkAccessTokenAndCall:(NSString *)urlToGet isPost:(BOOL)isPost includedImages:(NSArray *)images imagesKey:(NSString *)imagesKey parameters:(NSMutableDictionary *)params successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    if (![UserService isOAuthExpired]) {
        if (isPost) {
            if ([images count]>0) {
                [self formPost:urlToGet images:images imagesKey:imagesKey parameters:params successBlock:successBlock failureBlock:failureBlock];
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
                        [self formPost:urlToGet images:images imagesKey:imagesKey parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"oauth/access_token" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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

- (void)formPost:(NSString *)urlToGet images:(NSArray *)imagesFiles imagesKey:(NSString *)imagesKey parameters:(NSMutableDictionary *)parameters successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:[NSString stringWithFormat:@"%@/%@", serverBase, urlToGet] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (NSInteger i = 0; i<[imagesFiles count]; i++) {
            NSData *imageData = [imagesFiles objectAtIndex:i];
            [formData appendPartWithFileData:imageData name:imagesKey
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
    
    [self checkAccessTokenAndCall:@"api/v1/user/device" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/auth/validateEmail" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)signupWithUsername:(NSString *)username
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                  password:(NSString *)password
                     email:(NSString *)email
                       bio:(NSString *)bio
                 avatarURL:(NSString *)avatarURL
               avatarImage:(NSData *)avatarImage {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
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
                                   username, @"username",
                                   firstName, @"first_name",
                                   lastName, @"last_name",
                                   password, @"password",
                                   email, @"email",
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
    
    [self checkAccessTokenAndCall:@"api/v1/auth/register" isPost:YES includedImages:avatarImageArray imagesKey:@"avatar_image" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/auth/login" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/auth/loginLinkedIn" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/user/location" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/auth/password/sendReset" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)updateProfileWithUsername:(NSString *)username
                        firstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         password:(NSString *)password
                            email:(NSString *)email
                              bio:(NSString *)bio
                      avatarImage:(NSData *)avatarImage {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.UserServices.UpdateUserDetailsSuccess, [responseObject objectForKey:@"data"]);
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
                                   username, @"username",
                                   firstName, @"first_name",
                                   lastName, @"last_name",
                                   password, @"password",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    NSMutableArray *avatarImageArray = [[NSMutableArray alloc] init];
    if (avatarImage) {
        [avatarImageArray addObject:avatarImage];
    }
    
    if (bio) {
        [params setObject:bio forKey:@"bio"];
    }

    [self checkAccessTokenAndCall:@"api/v1/user/update" isPost:YES includedImages:avatarImageArray imagesKey:@"avatar_image" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Feed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeedForDiscover:(BOOL)discover {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.FeedServices.LoadFeedSuccess, prayers);
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
                                   [NSString stringWithFormat:@"%i", discover], @"discover",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)loadMorePrayersWithLastID:(NSString *)lastPrayerId forDiscover:(BOOL)discover {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.FeedServices.LoadFeedSuccess, prayers);
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
                                   lastPrayerId, @"prayer_id",
                                   [NSString stringWithFormat:@"%i", discover], @"discover",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/more" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
                                   postId, @"prayer_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/delete" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
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
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/report" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)likePostWithID:(NSString *)postId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.FeedServices.LikePostSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.LikePostFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.LikePostFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   postId, @"post_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/like" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)unlikePostWithID:(NSString *)postId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.FeedServices.UnLikePostSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.UnLikePostFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.UnLikePostFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   postId, @"post_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/unlike" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)searchForPrayersWithText:(NSString *)searchText {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.FeedServices.SearchSuccess, prayers);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.SearchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.SearchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   searchText, @"q",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/search" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Users
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadPrayersForUser:(NSString *)userId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.UserServices.GetPrayersForUserSuccess, prayers);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetPrayersForUserFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetPrayersForUserFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userId, @"user_id",
                                   [UserService getUserID], @"visitor_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/user" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)loadMorePrayersForUser:(NSString *)userId withLastID:(NSString *)lastPrayerId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.UserServices.GetPrayersForUserSuccess, prayers);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.GetPrayersForUserFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.GetPrayersForUserFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userId, @"user_id",
                                   lastPrayerId, @"prayer_id",
                                   [UserService getUserID], @"visitor_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/user/more" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)viewUserInfoForID:(NSString *)userId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            CDUser *user = [DataAccess addUserWithData:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.UserServices.ViewUserInfoSuccess, user);
        }
          
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.ViewUserInfoFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.ViewUserInfoFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userId, @"user_id",
                                   [UserService getUserID], @"visitor_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)searchForUsersWithText:(NSString *)searchText {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *users = [DataAccess addUsers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.FeedServices.SearchSuccess, users);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.FeedServices.SearchFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.FeedServices.SearchFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   searchText, @"q",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/search" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)followUserForID:(NSString *)userId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [DataAccess followUser:[NSNumber numberWithInt:[userId intValue]]];
            Notification_Post(JXNotification.UserServices.FollowUserSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.FollowUserFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.FollowUserFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userId, @"user_id",
                                   [UserService getUserID], @"follower_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/follow" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)unfollowUserForID:(NSString *)userId {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [DataAccess unfollowUser:[NSNumber numberWithInt:[userId intValue]]];
            Notification_Post(JXNotification.UserServices.UnFollowUserSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.UnFollowUserFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.UnFollowUserFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   userId, @"user_id",
                                   [UserService getUserID], @"follower_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/unfollow" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)autocompleteForTag:(NSString *)searchText {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            CDUser *user = [DataAccess addUserWithData:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.UserServices.AutocompleteSuccess, user);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.UserServices.AutocompleteFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.UserServices.AutocompleteFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   searchText, @"q",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/user/autocomplete" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Post
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postPrayerWithImage:(NSData *)prayerImage
                       text:(NSString *)prayerText
          withMentionString:(NSString *)mentionString
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude
            andLocationName:(NSString *)locationName {
    
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            CDPrayer *prayer = [DataAccess addPrayerWithData:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.PostServices.PostPrayerSuccess, prayer);
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
                                   prayerText, @"body",
                                   latitude, @"latitude",
                                   longitude, @"longitude",
                                   locationName, @"location",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    NSMutableArray *prayerImageArray = [[NSMutableArray alloc] init];
    if (prayerImage) {
        [prayerImageArray addObject:prayerImage];
    }
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/create" isPost:YES includedImages:prayerImageArray imagesKey:@"image" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comments
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadCommentsForPrayerID:(NSString *)prayerID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *comments = [DataAccess addCommentsWithData:[responseObject objectForKey:@"data"] toPrayer:[NSNumber numberWithInt:[prayerID intValue]]];
            
            Notification_Post(JXNotification.CommentsServices.GetPostCommentsSuccess, comments);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.CommentsServices.GetPostCommentsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.CommentsServices.GetPostCommentsFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   prayerID, @"prayer_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/comments" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)postComment:(NSString *)comment withMentionString:(NSString *)mentionString forPrayerID:(NSString *)prayerID andTempIdentifier:(NSString *)tempIdentifier {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            [DataAccess addCommentWithData:[responseObject objectForKey:@"data"] toPrayer:[NSNumber numberWithInt:[prayerID intValue]]];
            Notification_Post(JXNotification.CommentsServices.PostCommentSuccess, tempIdentifier);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.CommentsServices.PostCommentFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.CommentsServices.PostCommentFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   comment, @"body",
                                   prayerID, @"prayer_id",
                                   mentionString, @"tagged",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/prayers/comment" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}

- (void)deleteCommentWithID:(NSString *)commentID {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            Notification_Post(JXNotification.CommentsServices.DeleteCommentSuccess, nil);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.CommentsServices.DeleteCommentFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.CommentsServices.DeleteCommentFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   commentID, @"comment_id",
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/comment/delete" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchFor {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.FeedServices.LoadFeedSuccess, prayers);
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
    
    [self checkAccessTokenAndCall:@"api/v1/prayers" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadNotifications {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *notifications = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.NotificationsServices.GetNotificationsSuccess, notifications);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.NotificationsServices.GetNotificationsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.NotificationsServices.GetNotificationsFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/notifications" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Settings
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getSettings {
    void (^successBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        
        NSInteger statusCode = [operation.response statusCode];
        
        //success
        if (statusCode == 200) {
            NSArray *prayers = [DataAccess addPrayers:[responseObject objectForKey:@"data"]];
            Notification_Post(JXNotification.SettingsServices.GetSettingsSuccess, prayers);
        }
        
        //invalid
        else {
            Notification_Post(JXNotification.SettingsServices.GetSettingsFailed, nil);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject)  {
        if(DEBUGConnections) NSLog(@"ResponseObject: %@", responseObject);
        Notification_Post(JXNotification.SettingsServices.GetSettingsFailed, nil);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [UserService getUserID], @"user_id",
                                   [UserService getOAuthToken], @"access_token", nil];
    
    [self checkAccessTokenAndCall:@"api/v1/settings" isPost:YES includedImages:nil imagesKey:@"" parameters:params successBlock:successBlock failureBlock:failureBlock];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helpers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)validString:(NSString *)string {
    return (string && ![string isKindOfClass:[NSNull class]])? string : @"";
}


@end
