//
//  AppHelper.m
//  VortextVault
//
//  Created by Jason LAPIERRE on 14/11/2013.
//  Copyright (c) 2013 Bundll. All rights reserved.
//

#import "JXUserService.h"

@implementation JXUserService


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (JXUserService *)sharedInstance {
    static JXUserService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JXUserService alloc] init];
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
#pragma mark - Connection
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isUserLoggedIn {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    return (userID ? YES : NO);
}

- (void)disconnect {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dob"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groupID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - User info
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOAuthToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"OAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOAuthExpiracy:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"OAuthExpiracy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)getOAuthExpiracyDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthExpiracy"];
}

- (BOOL)isOAuthExpired {
    //NSLog(@"NOW: %@", [NSDate dateWithTimeIntervalSinceNow:0]);
    //NSLog(@"EXP: %@", [self getOAuthExpiracyDate]);
    
    if ([[NSDate dateWithTimeIntervalSinceNow:0] compare:[self getOAuthExpiracyDate]] == NSOrderedAscending) {
        return NO;
    }
    else return YES;
}

- (NSString *)getOAuthToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"OAuthToken"];
}

- (void)setUserWithUsername:(NSString *)username
                     userID:(NSString *)userID
                 linkedinID:(NSString *)linkedinID
                  firstname:(NSString *)firstname
                   lastname:(NSString *)lastname
                   fullname:(NSString *)fullname
                companyName:(NSString *)companyName
                  companyID:(NSString *)companyID
                   position:(NSString *)position
             departmentName:(NSString *)departmentName
               departmentID:(NSString *)departmentID
                        bio:(NSString *)bio
                       city:(NSString *)city
                 profileURL:(NSString *)profileURL {
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] setObject:fullname forKey:@"fullname"];
    [[NSUserDefaults standardUserDefaults] setObject:companyName forKey:@"companyName"];
    [[NSUserDefaults standardUserDefaults] setObject:companyID forKey:@"companyID"];
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:@"position"];
    [[NSUserDefaults standardUserDefaults] setObject:departmentName forKey:@"departmentName"];
    [[NSUserDefaults standardUserDefaults] setObject:departmentID forKey:@"departmentID"];
    [[NSUserDefaults standardUserDefaults] setObject:bio forKey:@"bio"];
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
    [[NSUserDefaults standardUserDefaults] setObject:linkedinID forKey:@"linkedinID"];
    [[NSUserDefaults standardUserDefaults] setObject:profileURL forKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCity:(NSString *)city {
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBio:(NSString *)bio {
    [[NSUserDefaults standardUserDefaults] setObject:bio forKey:@"bio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAvatarURL:(NSString *)avatarURL {
    [[NSUserDefaults standardUserDefaults] setObject:avatarURL forKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPosition:(NSString *)position {
    [[NSUserDefaults standardUserDefaults] setObject:position forKey:@"position"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFirstName:(NSString *)firstname {
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastName:(NSString *)lastname {
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDepartmentName:(NSString *)departmentName {
    [[NSUserDefaults standardUserDefaults] setObject:departmentName forKey:@"departmentName"];
}

- (void)setDepartmentID:(NSString *)departmentID {
    [[NSUserDefaults standardUserDefaults] setObject:departmentID forKey:@"departmentID"];
}

- (NSString *)getPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (NSString *)getUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)getUserID {
    return [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
}

- (NSString *)getFirstname {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"firstname"];
}

- (NSString *)getLastname {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastname"];
}

- (NSString *)getFullname {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"fullname"];
}

- (NSString *)getCompanyName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companyName"];
}

- (NSString *)getCompanyID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"];
}

- (NSString *)getPosition {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"position"];
}

- (NSString *)getDepartmentName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"departmentName"];
}

- (NSString *)getDepartmentID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"departmentID"];
}

- (NSString *)getBio {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
}

- (NSString *)getCity {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
}

- (NSString *)getLinkedinID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinID"];
}

- (NSString *)getAvatarURL {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatarURL"];
}


- (void)logoutUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fullname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companyName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companyID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"position"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"departmentName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"departmentID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bio"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linkedinID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end