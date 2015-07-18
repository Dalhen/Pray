//
//  JXNotifications.m
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import "JXNotifications.h"

const struct JXNotificationStruct JXNotification = {
    .CalendarServices = {
        .ConfirmDateSuccess = @"com.nea.calendar.confirmDateSuccess",
        .ConfirmDateFailed = @"com.nea.calendar.confirmDateFailed",
    },
    
    .UserServices = {
        .UpdateOAuthTokenSuccess = @"com.nea.userServices.UpdateOAuthTokenSuccess",
        .UpdateOAuthTokenFailed = @"com.nea.userServices.UpdateOAuthTokenFailed",
        
        .ResetPasswordSuccess = @"com.nea.userServices.ResetPasswordSuccess",
        .ResetPasswordFailed = @"com.nea.userServices.ResetPasswordFailed",
        .UpdateDeviceTokenSuccess = @"com.nea.userServices.UpdateDeviceTokenSuccess",
        .UpdateDeviceTokenFailed = @"com.nea.userServices.UpdateDeviceTokenFailed",
        .ValidateEmailSuccess = @"com.nea.userServices.ValidateEmailSuccess",
        .ValidateEmailFailed = @"com.nea.userServices.ValidateEmailFailed",
        .RegistrationSuccess = @"com.nea.userServices.RegistrationSuccess",
        .RegistrationFailed = @"com.nea.userServices.RegistrationFailed",
        .LoginSuccess = @"com.nea.userServices.LoginSuccess",
        .LoginFailed = @"com.nea.userServices.LoginFailed",
        .ViewUserInfoSuccess = @"com.nea.userServices.ViewUserInfoSuccess",
        .ViewUserInfoFailed = @"com.nea.userServices.ViewUserInfoFailed",
        .UpdateUserDetailsSuccess = @"com.nea.userServices.UpdateUserDetailsSuccess",
        .UpdateUserDetailsFailed = @"com.nea.userServices.UpdateUserDetailsFailed",
        .UpdateLocationSuccess = @"com.nea.userServices.UpdateLocationSuccess",
        .UpdateLocationFailed = @"com.nea.userServices.UpdateLocationFailed",
        
        .GetUsersToMatchSuccess = @"com.nea.userServices.GetUsersToMatchSuccess",
        .GetUsersToMatchFailed = @"com.nea.userServices.GetUsersToMatchFailed",
        .GetCompanyDepartmentsSuccess = @"com.nea.userServices.GetCompanyDepartmentsSuccess",
        .GetCompanyDepartmentsFailed = @"com.nea.userServices.GetCompanyDepartmentsFailed",
        .GetCompanyLocationsSuccess = @"com.nea.userServices.GetCompanyLocationsSuccess",
        .GetCompanyLocationsFailed = @"com.nea.userServices.GetCompanyLocationsFailed",
        
        .WantToMatchSuccess = @"com.nea.userServices.WantToMatchSuccess",
        .WantToMatchFailed = @"com.nea.userServices.WantToMatchFailed",
        .ConfirmMatchSuccess = @"com.nea.userServices.ConfirmMatchSuccess",
        .ConfirmMatchFailed = @"com.nea.userServices.ConfirmMatchFailed",
        .GetAllMatchesSuccess = @"com.nea.userServices.GetAllMatchesSuccess",
        .GetAllMatchesFailed = @"com.nea.userServices.GetAllMatchesFailed",
        .ChangeMatchDateSuccess = @"com.nea.userServices.ChangeMatchDateSuccess",
        .ChangeMatchDateFailed = @"com.nea.userServices.ChangeMatchDateFailed",
        .CancelMatchSuccess = @"com.nea.userServices.CancelMatchSuccess",
        .CancelMatchFailed = @"com.nea.userServices.CancelMatchFailed",
        .ReportMatchSuccess = @"com.nea.userServices.ReportMatchSuccess",
        .ReportMatchFailed = @"com.nea.userServices.ReportMatchFailed",
        
        .UpdateMessagesSuccess = @"com.nea.userServices.UpdateMessagesSuccess",
        .UpdateMessagesFailed = @"com.nea.userServices.UpdateMessagesFailed",
        .RefreshChatNow = @"com.nea.userServices.RefreshChatNow",
        .SendMessageSuccess = @"com.nea.userServices.SendMessageSuccess",
        .SendMessageFailed = @"com.nea.userServices.SendMessageFailed",
    },
    
    .MeetingsServices = {
        .GetMeetingsSuccess = @"com.nea.meetingsServices.GetMeetingsSuccess",
        .GetMeetingsFailed = @"com.nea.meetingsServices.GetMeetingsFailed",
        .CancelMeetingSuccess = @"com.nea.meetingsServices.CancelMeetingSuccess",
        .CancelMeetingFailed = @"com.nea.meetingsServices.CancelMeetingFailed",
    },
    
    .PushNotificationServices = {
        .NewMessages = @"com.nea.pushServices.NewMessages",
        .NewMeeting = @"com.nea.pushServices.NewMeeting",
    },
    
    .ChatServices = {
        .PostMessageSuccess = @"com.nea.chatServices.PostMessageSuccess",
        .PostMessageFailed = @"com.nea.chatServices.PostMessageFailed",
        .GetMessagesSuccess = @"com.nea.chatServices.GetMessagesSuccess",
        .GetMessagesFailed = @"com.nea.chatServices.GetMessagesFailed",
        .RefreshChatNow = @"com.nea.chatServices.RefreshChatNow",
    },
};



