//
//  JXNetwork.h
//  VortexVault
//
//  Created by Jason LAPIERRE on 23/10/2013.
//  Copyright (c) 2015 Jason LAPIERRE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JXNetworkService : NSObject {
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXNetworkService *)sharedInstance;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helpers
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)getServerStatusWithResponse:(NSDictionary *)responseObject;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OAuth
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)generateAccessToken;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Signup
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateDeviceToken:(NSData *)deviceToken;

- (void)validateEmail:(NSString *)email;

- (void)signupWithUsername:(NSString *)username
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                  password:(NSString *)password
                     email:(NSString *)email
                       bio:(NSString *)bio
                 avatarURL:(NSString *)avatarURL
               avatarImage:(NSData *)avatarImage;

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password;

- (void)loginUserWithLinkedIn:(NSString *)linkedInID;

- (void)updateLocationWithCityName:(NSString *)cityName latitude:(NSString *)latitude longitude:(NSString *)longitude;

- (void)resetPasswordForEmailAddress:(NSString *)email;

- (void)updateProfileWithFirstname:(NSString *)firstName
                          lastName:(NSString *)lastName
                          password:(NSString *)password
                          position:(NSString *)position
                      departmentID:(NSString *)departmentID
                    departmentName:(NSString *)departmentName
                       avatarImage:(NSData *)avatarImage
                               bio:(NSString *)bio;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Feed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeed;

- (void)deletePostWithID:(NSString *)postId;

- (void)reportPostWithID:(NSString *)postId;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Post
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postPrayerWithImage:(NSData *)prayerImage andText:(NSString *)prayerText;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comments
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadCommentsForPrayerID:(NSString *)prayerID;
- (void)deleteCommentWithID:(NSString *)commentID;


@end
