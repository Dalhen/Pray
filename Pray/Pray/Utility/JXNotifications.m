//
//  JXNotifications.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXNotifications.h"

const struct JXNotificationStruct JXNotification = {
   .UserServices = {
        .UpdateOAuthTokenSuccess = @"com.pray.userServices.UpdateOAuthTokenSuccess",
        .UpdateOAuthTokenFailed = @"com.pray.userServices.UpdateOAuthTokenFailed",
        
        .ResetPasswordSuccess = @"com.pray.userServices.ResetPasswordSuccess",
        .ResetPasswordFailed = @"com.pray.userServices.ResetPasswordFailed",
        .UpdateDeviceTokenSuccess = @"com.pray.userServices.UpdateDeviceTokenSuccess",
        .UpdateDeviceTokenFailed = @"com.pray.userServices.UpdateDeviceTokenFailed",
        .ValidateEmailSuccess = @"com.pray.userServices.ValidateEmailSuccess",
        .ValidateEmailFailed = @"com.pray.userServices.ValidateEmailFailed",
        .RegistrationSuccess = @"com.pray.userServices.RegistrationSuccess",
        .RegistrationFailed = @"com.pray.userServices.RegistrationFailed",
        .LoginSuccess = @"com.pray.userServices.LoginSuccess",
        .LoginFailed = @"com.pray.userServices.LoginFailed",
        .UpdateUserDetailsSuccess = @"com.pray.userServices.UpdateUserDetailsSuccess",
        .UpdateUserDetailsFailed = @"com.pray.userServices.UpdateUserDetailsFailed",
        .UpdateLocationSuccess = @"com.pray.userServices.UpdateLocationSuccess",
        .UpdateLocationFailed = @"com.pray.userServices.UpdateLocationFailed",
        
        .GetUsersToMatchSuccess = @"com.pray.userServices.GetUsersToMatchSuccess",
        .GetUsersToMatchFailed = @"com.pray.userServices.GetUsersToMatchFailed",
        .GetCompanyDepartmentsSuccess = @"com.pray.userServices.GetCompanyDepartmentsSuccess",
        .GetCompanyDepartmentsFailed = @"com.pray.userServices.GetCompanyDepartmentsFailed",
        .GetCompanyLocationsSuccess = @"com.pray.userServices.GetCompanyLocationsSuccess",
        .GetCompanyLocationsFailed = @"com.pray.userServices.GetCompanyLocationsFailed",
        
        .WantToMatchSuccess = @"com.pray.userServices.WantToMatchSuccess",
        .WantToMatchFailed = @"com.pray.userServices.WantToMatchFailed",
        .ConfirmMatchSuccess = @"com.pray.userServices.ConfirmMatchSuccess",
        .ConfirmMatchFailed = @"com.pray.userServices.ConfirmMatchFailed",
        .GetAllMatchesSuccess = @"com.pray.userServices.GetAllMatchesSuccess",
        .GetAllMatchesFailed = @"com.pray.userServices.GetAllMatchesFailed",
        .ChangeMatchDateSuccess = @"com.pray.userServices.ChangeMatchDateSuccess",
        .ChangeMatchDateFailed = @"com.pray.userServices.ChangeMatchDateFailed",
        .CancelMatchSuccess = @"com.pray.userServices.CancelMatchSuccess",
        .CancelMatchFailed = @"com.pray.userServices.CancelMatchFailed",
        .ReportMatchSuccess = @"com.pray.userServices.ReportMatchSuccess",
        .ReportMatchFailed = @"com.pray.userServices.ReportMatchFailed",
        
        .UpdateMessagesSuccess = @"com.pray.userServices.UpdateMessagesSuccess",
        .UpdateMessagesFailed = @"com.pray.userServices.UpdateMessagesFailed",
        .RefreshChatNow = @"com.pray.userServices.RefreshChatNow",
        .SendMessageSuccess = @"com.pray.userServices.SendMessageSuccess",
        .SendMessageFailed = @"com.pray.userServices.SendMessageFailed",
        
        .FacebookLoginSuccess = @"com.pray.userServices.FacebookLoginSuccess",
        .FacebookLoginFailed = @"com.pray.userServices.FacebookLoginFailed",
       
        .GetPrayersForUserSuccess = @"com.pray.userServices.GetPrayersForUserSuccess",
        .GetPrayersForUserFailed= @"com.pray.userServices.GetPrayersForUserFailed",
        .GetMorePrayersForUserSuccess = @"com.pray.userServices.GetMorePrayersForUserSuccess",
        .GetMorePrayersForUserFailed= @"com.pray.userServices.GetMorePrayersForUserFailed",
        .ViewUserInfoSuccess = @"com.pray.userServices.ViewUserInfoSuccess",
        .ViewUserInfoFailed = @"com.pray.userServices.ViewUserInfoFailed",
        .FollowUserSuccess = @"com.pray.userServices.FollowUserSuccess",
        .FollowUserFailed = @"com.pray.userServices.FollowUserFailed",
        .UnFollowUserSuccess = @"com.pray.userServices.UnFollowUserSuccess",
        .UnFollowUserFailed = @"com.pray.userServices.UnFollowUserFailed",
    },
    
    .FeedServices = {
        .LoadFeedSuccess = @"com.pray.feedServices.LoadFeedSuccess",
        .LoadFeedFailed = @"com.pray.feedServices.LoadFeedFailed",
        .DeletePostSuccess = @"com.pray.feedServices.DeletePostSuccess",
        .DeletePostFailed = @"com.pray.feedServices.DeletePostFailed",
        .ReportPostSuccess = @"com.pray.feedServices.ReportPostSuccess",
        .ReportPostFailed = @"com.pray.feedServices.ReportPostFailed",
        .LikePostSuccess = @"com.pray.feedServices.LikePostSuccess",
        .LikePostFailed = @"com.pray.feedServices.LikePostFailed",
        .UnLikePostSuccess = @"com.pray.feedServices.UnLikePostSuccess",
        .UnLikePostFailed = @"com.pray.feedServices.UnLikePostFailed",
        .SearchSuccess = @"com.pray.feedServices.SearchSuccess",
        .SearchFailed = @"com.pray.feedServices.SearchFailed",
    },
    
    .PostServices = {
        .PostPrayerSuccess = @"com.pray.postServices.PostPrayerSuccess",
        .PostPrayerFailed = @"com.pray.postServices.PostPrayerFailed",
    },
    
    .NotificationsServices = {
        .GetNotificationsSuccess = @"com.pray.notificationsServices.GetNotificationsSuccess",
        .GetNotificationsFailed = @"com.pray.notificationsServices.GetNotificationsFailed",
    },
    
    .CommentsServices = {
        .GetPostCommentsSuccess = @"com.pray.commentsServices.GetPostCommentsSuccess",
        .GetPostCommentsFailed = @"com.pray.commentsServices.GetPostCommentsFailed",
        .PostCommentSuccess = @"com.pray.commentsServices.PostCommentSuccess",
        .PostCommentFailed = @"com.pray.commentsServices.PostCommentFailed",
        .DeleteCommentSuccess = @"com.pray.commentsServices.DeletePostSuccess",
        .DeleteCommentFailed = @"com.pray.commentsServices.DeleteCommentFailed",
        .ReportCommentSuccess = @"com.pray.commentsServices.ReportCommentSuccess",
       
        .ReportCommentFailed = @"com.pray.commentsServices.ReportCommentFailed",
    },
    
    .PushNotificationServices = {
        .NewMessages = @"com.pray.pushServices.NewMessages",
        .NewMeeting = @"com.pray.pushServices.NewMeeting",
    },
    
    .ChatServices = {
        .PostMessageSuccess = @"com.pray.chatServices.PostMessageSuccess",
        .PostMessageFailed = @"com.pray.chatServices.PostMessageFailed",
        .GetMessagesSuccess = @"com.pray.chatServices.GetMessagesSuccess",
        .GetMessagesFailed = @"com.pray.chatServices.GetMessagesFailed",
        .RefreshChatNow = @"com.pray.chatServices.RefreshChatNow",
    },
    
    .SettingsServices = {
        .GetSettingsSuccess = @"com.pray.settingsServices.GetSettingsSuccess",
        .GetSettingsFailed = @"com.pray.settingsServices.GetSettingsFailed",
    },
};



