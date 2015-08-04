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
        .ViewUserInfoSuccess = @"com.pray.userServices.ViewUserInfoSuccess",
        .ViewUserInfoFailed = @"com.pray.userServices.ViewUserInfoFailed",
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
    },
    
    .FeedServices = {
        .LoadFeedSuccess = @"com.pray.feedServices.LoadFeedSuccess",
        .LoadFeedFailed = @"com.pray.feedServices.LoadFeedFailed",
        .DeletePostSuccess = @"com.pray.feedServices.DeletePostSuccess",
        .DeletePostFailed = @"com.pray.feedServices.DeletePostFailed",
        .ReportPostSuccess = @"com.pray.feedServices.ReportPostSuccess",
        .ReportPostFailed = @"com.pray.feedServices.ReportPostFailed",
    },
    
    .PostServices = {
        .PostPrayerSuccess = @"com.pray.postServices.PostPrayerSuccess",
        .PostPrayerFailed = @"com.pray.postServices.PostPrayerFailed",
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
};



