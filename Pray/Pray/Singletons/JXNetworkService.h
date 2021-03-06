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

- (void)facebookSignupWithFacebookID:(NSString *)facebookId
                       facebookToken:(NSString *)facebookToken
                            username:(NSString *)username
                           firstName:(NSString *)firstName
                            lastName:(NSString *)lastName
                               email:(NSString *)email
                                 bio:(NSString *)bio
                           avatarURL:(NSString *)avatarURL;

- (void)loginUserWithEmail:(NSString *)email password:(NSString *)password;

- (void)updateLocationWithCityName:(NSString *)cityName latitude:(NSString *)latitude longitude:(NSString *)longitude;

- (void)resetPasswordForEmailAddress:(NSString *)email;

- (void)updateProfileWithUsername:(NSString *)username
                        firstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                         password:(NSString *)password
                            email:(NSString *)email
                              bio:(NSString *)bio
                      avatarImage:(NSData *)avatarImage;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Feed
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFeedForDiscover:(BOOL)discover;

- (void)loadMorePrayersWithLastID:(NSString *)lastPrayerId forDiscover:(BOOL)discover;

- (void)deletePostWithID:(NSString *)postId;

- (void)reportPostWithID:(NSString *)postId;

- (void)likePostWithID:(NSString *)postId;

- (void)unlikePostWithID:(NSString *)postId;

- (void)searchForPrayersWithText:(NSString *)searchText;

- (void)getPrayerDetailsForID:(NSString *)postId;

- (void)getPrayerLikesListForID:(NSString *)postId;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Users
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadPrayersForUser:(NSString *)userId;

- (void)loadMorePrayersForUser:(NSString *)userId withLastID:(NSString *)lastPrayerId;

- (void)viewUserInfoForID:(NSString *)userId;

- (void)searchForUsersWithText:(NSString *)searchText;

- (void)followUserForID:(NSString *)userId;

- (void)unfollowUserForID:(NSString *)userId;

- (void)autocompleteForTag:(NSString *)searchText;

- (void)getFollowersForUserWithID:(NSString *)userId;

- (void)getUsersFollowedByUserWithID:(NSString *)userId;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Post
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postPrayerWithImage:(NSData *)prayerImage
                       text:(NSString *)prayerText
               religionType:(NSString *)religionType
          withMentionString:(NSString *)mentionString
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude
            andLocationName:(NSString *)locationName;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Comments
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadCommentsForPrayerID:(NSString *)prayerID;

- (void)postComment:(NSString *)comment withMentionString:(NSString *)mentionString forPrayerID:(NSString *)prayerID andTempIdentifier:(NSString *)tempIdentifier;

- (void)deleteCommentWithID:(NSString *)commentID;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadNotifications;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Settings
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)getSettings;


@end
