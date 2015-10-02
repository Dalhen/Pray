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
                      email:(NSString *)email
                     userID:(NSString *)userID
                  firstname:(NSString *)firstname
                   lastname:(NSString *)lastname
                   fullname:(NSString *)fullname
                        bio:(NSString *)bio
                       city:(NSString *)city
                 profileURL:(NSString *)profileURL {
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", userID] forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] setObject:fullname forKey:@"fullname"];
    [[NSUserDefaults standardUserDefaults] setObject:bio forKey:@"bio"];
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
    [[NSUserDefaults standardUserDefaults] setObject:profileURL forKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"ID=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]);
}

- (void)setUsername:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEmail:(NSString *)email {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
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

- (void)setFirstName:(NSString *)firstname {
    [[NSUserDefaults standardUserDefaults] setObject:firstname forKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLastName:(NSString *)lastname {
    [[NSUserDefaults standardUserDefaults] setObject:lastname forKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}

- (NSString *)getUsername {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)getEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

- (NSString *)getUserID {
    return [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
}

- (NSNumber *)getUserIDNumber {
    return [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] intValue]];
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

- (NSString *)getBio {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"bio"];
}

- (NSString *)getCity {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
}

- (NSString *)getAvatarURL {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatarURL"];
}


- (void)logoutUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fullname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bio"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatarURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end