//
//  JXNotifications.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


struct UserServicesStruct {
    __unsafe_unretained NSString * const UpdateOAuthTokenSuccess;
    __unsafe_unretained NSString * const UpdateOAuthTokenFailed;
    
    __unsafe_unretained NSString * const ResetPasswordSuccess;
    __unsafe_unretained NSString * const ResetPasswordFailed;
    __unsafe_unretained NSString * const UpdateDeviceTokenSuccess;
    __unsafe_unretained NSString * const UpdateDeviceTokenFailed;
    __unsafe_unretained NSString * const ValidateEmailSuccess;
    __unsafe_unretained NSString * const ValidateEmailFailed;
    __unsafe_unretained NSString * const RegistrationSuccess;
    __unsafe_unretained NSString * const RegistrationFailed;
    __unsafe_unretained NSString * const LoginSuccess;
    __unsafe_unretained NSString * const LoginFailed;
    __unsafe_unretained NSString * const ViewUserInfoSuccess;
    __unsafe_unretained NSString * const ViewUserInfoFailed;
    __unsafe_unretained NSString * const UpdateUserDetailsSuccess;
    __unsafe_unretained NSString * const UpdateUserDetailsFailed;
    __unsafe_unretained NSString * const UpdateLocationSuccess;
    __unsafe_unretained NSString * const UpdateLocationFailed;
    
    __unsafe_unretained NSString * const GetUsersToMatchSuccess;
    __unsafe_unretained NSString * const GetUsersToMatchFailed;
    __unsafe_unretained NSString * const GetCompanyDepartmentsSuccess;
    __unsafe_unretained NSString * const GetCompanyDepartmentsFailed;
    __unsafe_unretained NSString * const GetCompanyLocationsSuccess;
    __unsafe_unretained NSString * const GetCompanyLocationsFailed;
    
    __unsafe_unretained NSString * const WantToMatchSuccess;
    __unsafe_unretained NSString * const WantToMatchFailed;
    __unsafe_unretained NSString * const ConfirmMatchSuccess;
    __unsafe_unretained NSString * const ConfirmMatchFailed;
    __unsafe_unretained NSString * const GetAllMatchesSuccess;
    __unsafe_unretained NSString * const GetAllMatchesFailed;
    __unsafe_unretained NSString * const ChangeMatchDateSuccess;
    __unsafe_unretained NSString * const ChangeMatchDateFailed;
    __unsafe_unretained NSString * const CancelMatchSuccess;
    __unsafe_unretained NSString * const CancelMatchFailed;
    __unsafe_unretained NSString * const ReportMatchSuccess;
    __unsafe_unretained NSString * const ReportMatchFailed;
    
    __unsafe_unretained NSString * const UpdateMessagesSuccess;
    __unsafe_unretained NSString * const UpdateMessagesFailed;
    __unsafe_unretained NSString * const RefreshChatNow;
    __unsafe_unretained NSString * const SendMessageSuccess;
    __unsafe_unretained NSString * const SendMessageFailed;
    
    __unsafe_unretained NSString * const FacebookLoginSuccess;
    __unsafe_unretained NSString * const FacebookLoginFailed;
    
    __unsafe_unretained NSString * const GetPrayersForUserSuccess;
    __unsafe_unretained NSString * const GetPrayersForUserFailed;
    __unsafe_unretained NSString * const GetMorePrayersForUserSuccess;
    __unsafe_unretained NSString * const GetMorePrayersForUserFailed;
    
    __unsafe_unretained NSString * const FollowUserSuccess;
    __unsafe_unretained NSString * const FollowUserFailed;
    __unsafe_unretained NSString * const UnFollowUserSuccess;
    __unsafe_unretained NSString * const UnFollowUserFailed;
    
    __unsafe_unretained NSString * const AutocompleteSuccess;
    __unsafe_unretained NSString * const AutocompleteFailed;
    
    __unsafe_unretained NSString * const GetUserFollowersSuccess;
    __unsafe_unretained NSString * const GetUserFollowersFailed;
    __unsafe_unretained NSString * const GetFollowedUsersSuccess;
    __unsafe_unretained NSString * const GetFollowedUsersFailed;
};

struct FeedServicesStruct {
    __unsafe_unretained NSString * const LoadFeedSuccess;
    __unsafe_unretained NSString * const LoadFeedFailed;
    __unsafe_unretained NSString * const DeletePostSuccess;
    __unsafe_unretained NSString * const DeletePostFailed;
    __unsafe_unretained NSString * const ReportPostSuccess;
    __unsafe_unretained NSString * const ReportPostFailed;
    __unsafe_unretained NSString * const LikePostSuccess;
    __unsafe_unretained NSString * const LikePostFailed;
    __unsafe_unretained NSString * const UnLikePostSuccess;
    __unsafe_unretained NSString * const UnLikePostFailed;
    __unsafe_unretained NSString * const SearchSuccess;
    __unsafe_unretained NSString * const SearchFailed;
    __unsafe_unretained NSString * const GetPrayerDetailsSuccess;
    __unsafe_unretained NSString * const GetPrayerDetailsFailed;
    __unsafe_unretained NSString * const GetPrayerLikesListSuccess;
    __unsafe_unretained NSString * const GetPrayerLikesListFailed;
};

struct NotificationsServicesStruct {
    __unsafe_unretained NSString * const GetNotificationsSuccess;
    __unsafe_unretained NSString * const GetNotificationsFailed;
};

struct PostServicesStruct {
    __unsafe_unretained NSString * const PostPrayerSuccess;
    __unsafe_unretained NSString * const PostPrayerFailed;
};

struct CommentsServicesStruct {
    __unsafe_unretained NSString * const GetPostCommentsSuccess;
    __unsafe_unretained NSString * const GetPostCommentsFailed;
    __unsafe_unretained NSString * const PostCommentSuccess;
    __unsafe_unretained NSString * const PostCommentFailed;
    __unsafe_unretained NSString * const DeleteCommentSuccess;
    __unsafe_unretained NSString * const DeleteCommentFailed;
    __unsafe_unretained NSString * const ReportCommentSuccess;
    __unsafe_unretained NSString * const ReportCommentFailed;
};

struct PushNotificationServicesStruct {
    __unsafe_unretained NSString * const NewMessages;
    __unsafe_unretained NSString * const NewMeeting;
};

struct ChatServicesStruct {
    __unsafe_unretained NSString * const PostMessageSuccess;
    __unsafe_unretained NSString * const PostMessageFailed;
    __unsafe_unretained NSString * const GetMessagesSuccess;
    __unsafe_unretained NSString * const GetMessagesFailed;
    __unsafe_unretained NSString * const RefreshChatNow;
};

struct SettingsServicesStruct {
    __unsafe_unretained NSString * const GetSettingsSuccess;
    __unsafe_unretained NSString * const GetSettingsFailed;
};


struct JXNotificationStruct {
    struct UserServicesStruct const UserServices;
    struct FeedServicesStruct const FeedServices;
    struct PostServicesStruct const PostServices;
    struct CommentsServicesStruct const CommentsServices;
    struct PushNotificationServicesStruct const PushNotificationServices;
    struct ChatServicesStruct const ChatServices;
    struct NotificationsServicesStruct const NotificationsServices;
    struct SettingsServicesStruct const SettingsServices;
};

extern const struct JXNotificationStruct JXNotification;

