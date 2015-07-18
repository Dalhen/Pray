//
//  JXNotifications.h
//  VortexVault
//
//  Created by Jason YL on 10/02/12.
//  Copyright (c) 2013 All rights reserved.
//

#import <Foundation/Foundation.h>


struct CalendarStruct {
    __unsafe_unretained NSString * const ConfirmDateSuccess;
    __unsafe_unretained NSString * const ConfirmDateFailed;
};

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
};

struct MeetingsServicesStruct {
    __unsafe_unretained NSString * const GetMeetingsSuccess;
    __unsafe_unretained NSString * const GetMeetingsFailed;
    __unsafe_unretained NSString * const CancelMeetingSuccess;
    __unsafe_unretained NSString * const CancelMeetingFailed;
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


struct JXNotificationStruct {
    struct CalendarStruct const CalendarServices;
    struct UserServicesStruct const UserServices;
    struct MeetingsServicesStruct const MeetingsServices;
    struct PushNotificationServicesStruct const PushNotificationServices;
    struct ChatServicesStruct const ChatServices;
};

extern const struct JXNotificationStruct JXNotification;

