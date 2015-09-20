//
//  NotificationsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "NotificationsController.h"
#import "PKRevealController.h"
#import "NotificationsCell.h"


@interface NotificationsController ()

@end

@implementation NotificationsController


#pragma mark - Init
- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
    [self loadNotifications];
}

- (void)setupHeader {
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = LocString(@"Notifications");
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_White;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setupTableView {
    
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*sratio, 260*sratio, self.view.screenWidth - 40*sratio, 40*sratio)];
    [noDataLabel setTextColor:Colour_255RGB(140, 146, 164)];
    [noDataLabel setFont:[FontService systemFont:14*sratio]];
    [noDataLabel setText:LocString(@"No notifications yet.")];
    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:noDataLabel];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [mainTable setBackgroundColor:Colour_PrayDarkBlue];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setScrollsToTop:YES];
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:Colour_White];
    [mainTable addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Side Navigation
- (void)showLeftMenu {
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.NotificationsServices.GetNotificationsSuccess, loadNotificationsSuccess:);
    Notification_Observe(JXNotification.NotificationsServices.GetNotificationsFailed, loadNotificationsFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.NotificationsServices.GetNotificationsSuccess);
    Notification_Remove(JXNotification.NotificationsServices.GetNotificationsFailed);
    Notification_RemoveObserver;
}


#pragma mark - Loading data
- (void)refreshTriggered {
    [self loadNotifications];
}

- (void)loadNotifications {
    [SVProgressHUD showWithStatus:LocString(@"Loading...") maskType:SVProgressHUDMaskTypeNone];
    [NetworkService loadNotifications];
}

- (void)loadNotificationsSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    notifications = [[NSArray alloc] initWithArray:notification.object];
    
    [UIView animateWithDuration:0.3 animations:^{
        if ([notifications count]>0) {
            [mainTable setAlpha:1];
            [noDataLabel setAlpha:0];
        }
        else {
            [mainTable setAlpha:0];
            [noDataLabel setAlpha:1];
        }
    }];
    
    [mainTable reloadData];
}

- (void)loadNotificationsFailed {
    [SVProgressHUD showErrorWithStatus:LocString(@"We couldn't load the latest notifications for now. Please check your internet connection and try again.")];
}


#pragma mark - UITableView dataSource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66*sratio;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsCell"];
    
    if(!cell) {
        cell = [[NotificationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell updateWithNotification:[notifications objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
