//
//  LeftMenuController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "LeftMenuController.h"
#import "BaseView.h"
#import "LeftMenuCell.h"

#import "FeedController.h"
#import "NotificationsController.h"
#import "ProfileController.h"
#import "SettingsController.h"


@interface LeftMenuController ()

@end

@implementation LeftMenuController
@synthesize mainTable;


- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self.view setBackgroundColor:Colour_255RGB(232, 232, 232)];
    selectedLine = 0;
    [self setupLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.revealController setMinimumWidth:220.0 maximumWidth:244.0 forViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
//    LeftMenuCell *cell = (LeftMenuCell *)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedLine inSection:0]];
//    [cell setSelected:YES animated:YES];
}


#pragma mark - Layout
- (void)setupLayout {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50*sratio, self.view.screenWidth, self.view.screenHeight - 50*sratio)];
    [mainTable setBackgroundColor:Colour_Clear];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setDataSource:self];
    [mainTable setDelegate:self];
    [self.view addSubview:mainTable];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*sratio;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Standard"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Standard"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:Colour_255RGB(232, 232, 232)];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(24*sratio, 30*sratio, 170*sratio, 30*sratio)];
        [button setTitle:LocString(@"Share the app with friends") forState:UIControlStateNormal];
        [button setBackgroundColor:Colour_BlackAlpha(0.2)];
        [button setTitleColor:Colour_255RGB(82, 82, 82) forState:UIControlStateNormal];
        [button.titleLabel setFont:[FontService systemFont:12*sratio]];
        [button.layer setCornerRadius:10*sratio];
        [button addTarget:self action:@selector(showInviteSelector) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        return cell;
    }
    
    else if (indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Standard"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Standard"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:Colour_255RGB(232, 232, 232)];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(24*sratio, 20*sratio, 170*sratio, 30*sratio)];
        [button setTitle:LocString(@"Send a feedback") forState:UIControlStateNormal];
        [button setBackgroundColor:Colour_BlackAlpha(0.2)];
        [button setTitleColor:Colour_255RGB(82, 82, 82) forState:UIControlStateNormal];
        [button.titleLabel setFont:[FontService systemFont:12*sratio]];
        [button.layer setCornerRadius:10*sratio];
        [button addTarget:self action:@selector(sendFeedbackSelector) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        
        return cell;
    }
    
    else {
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftMenuCell class])];
        if (!cell) {
            cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LeftMenuCell class])];
        }
        
        switch (indexPath.row) {
                
            case 0:
                [cell.title setText:LocString(@"Feed")];
                [cell setIconsSetWithOffImage:@"feedOFF" andOnImage:@"feedON"];
                [cell.accessoryButton setHidden:YES];
                break;
                
            case 1:
                [cell.title setText:LocString(@"Profile")];
                [cell setIconsSetWithOffImage:@"profileOFF" andOnImage:@"profileON"];
                [cell.accessoryButton setHidden:YES];
                break;
                
            case 2:
                [cell.title setText:LocString(@"Notifications")];
                [cell setIconsSetWithOffImage:@"notificationsOFF" andOnImage:@"notificationsON"];
                [cell.accessoryButton setHidden:YES];
                break;
                
            case 3:
                [cell.title setText:LocString(@"Settings")];
                [cell setIconsSetWithOffImage:@"settingsOFF" andOnImage:@"settingsON"];
                [cell.accessoryButton setHidden:YES];
                break;
                
            case 4: {
                
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller;
    
    switch (indexPath.row) {
        case 0:
            controller = [[FeedController alloc] init];
            break;
            
        case 1:
            controller = [[ProfileController alloc] initWithUser:[DataAccess getUserForID:[UserService getUserIDNumber]]];
            break;
            
        case 2:
            controller = [[NotificationsController alloc] init];
            break;
            
        case 3:
            controller = [[SettingsController alloc] init];
            break;
            
        default:
            break;
    }
    
    if (indexPath.row != 4 & indexPath.row != 5) {
        [AppDelegate updateFrontViewControllerWithController:controller andFocus:YES];
    }
    else if (indexPath.row == 4) {
        [self showInviteSelector];
    }
    else {
        [self sendFeedbackSelector];
    }
}


#pragma mark - Send Feedback
- (void)sendFeedbackSelector {
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"Feedback"];
        [picker setToRecipients:@[@"feedback@getpray.com"]];
        NSString *emailBody = @"Hi, I wanted to send you my feedback:";
        [picker setMessageBody:emailBody isHTML:YES];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showErrorWithStatus:LocString(@"Please set an email on this phone before proceeding.")];
    }
}


#pragma mark - Invites
- (void)showInviteSelector {
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[@"Join and pray with me on PRAY! Download the app here: https://itunes.apple.com/us/app/pray-for-iphone/id860868081?mt=8"] applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypeOpenInIBooks,
                                   UIActivityTypePostToVimeo];
    controller.excludedActivityTypes = excludeActivities;
    [self presentViewController:controller animated:YES completion:nil];
}



#pragma mark - MFMessage delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
