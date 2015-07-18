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

- (void)signupWithFirstName:(NSString *)firstName
                   lastName:(NSString *)lastName
                   password:(NSString *)password
                 linkedinID:(NSString *)linkedinID
                      email:(NSString *)email
                   position:(NSString *)position
                        bio:(NSString *)bio
               departmentID:(NSString *)departmentID
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
#pragma mark - Cards
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getUsersToMachWithDepartmentID:(NSString *)departmentID locationID:(NSString *)locationID;

- (void)getDepartmentsForCompanyID:(NSString *)companyID;

- (void)getLocationsForCompanyID:(NSString *)companyID;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Matching
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)wantToMatchUser:(NSString *)userID;

- (void)confirmMatchWithUser:(NSString *)userID date:(NSString *)dateString withPlusOne:(NSString *)plusOne;

- (void)getAllMatches;

- (void)changeMatch:(NSString *)matchID withDate:(NSString *)dateString withPlusOne:(NSString *)plusOne;

- (void)cancelMatch:(NSString *)matchID;

- (void)reportMatch:(NSString *)matchID;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Chat
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sendMessageWithText:(NSString *)text toMatch:(NSString *)matchId;

- (void)viewMessagesForMatch:(NSString *)matchId;


@end
