//
//  AppHelper.h
//  VortextVault
//
//  Created by Jason LAPIERRE on 14/11/2013.
//  Copyright (c) 2013 Bundll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXUserService : NSObject {
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXUserService *)sharedInstance;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Connection
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isUserLoggedIn;
- (void)disconnect;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UserData
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setUserWithUsername:(NSString *)username
                      email:(NSString *)email
                     userID:(NSString *)userID
                  firstname:(NSString *)firstname
                   lastname:(NSString *)lastname
                   fullname:(NSString *)fullname
                        bio:(NSString *)bio
                       city:(NSString *)city
                 profileURL:(NSString *)profileURL;

- (NSString *)getUsername;
- (NSString *)getEmail;
- (NSString *)getPassword;
- (NSString *)getUserID;
- (NSNumber *)getUserIDNumber;
- (NSString *)getFirstname;
- (NSString *)getLastname;
- (NSString *)getFullname;
- (NSString *)getCompanyName;
- (NSString *)getCompanyID;
- (NSString *)getPosition;
- (NSString *)getDepartmentName;
- (NSString *)getDepartmentID;
- (NSString *)getBio;
- (NSString *)getCity;
- (NSString *)getLinkedinID;
- (NSString *)getAvatarURL;

- (void)setUsername:(NSString *)username;
- (void)setEmail:(NSString *)email;
- (void)setPassword:(NSString *)password;
- (void)setCity:(NSString *)city;
- (void)setBio:(NSString *)bio;
- (void)setAvatarURL:(NSString *)avatarURL;
- (void)setPosition:(NSString *)position;
- (void)setFirstName:(NSString *)firstname;
- (void)setLastName:(NSString *)lastname;
- (void)setDepartmentName:(NSString *)departmentName;
- (void)setDepartmentID:(NSString *)departmentID;

- (void)setOAuthToken:(NSString *)token;
- (void)setOAuthExpiracy:(NSDate *)date;
- (BOOL)isOAuthExpired;
- (NSString *)getOAuthToken;

- (void)logoutUser;


@end
