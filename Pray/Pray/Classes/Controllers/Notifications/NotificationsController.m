//
//  NotificationsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "NotificationsController.h"
#import "PKRevealController.h"


@interface NotificationsController ()

@end

@implementation NotificationsController


#pragma mark - Init
- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupTableView];
    [self loadNotifications];
}

- (void)setupTableView {
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
    Notification_Observe(JXNotification.NotificationsServices.GetNotificationsSuccess, getNotificationsSuccess:);
    Notification_Observe(JXNotification.NotificationsServices.GetNotificationsFailed, getNotificationsFailed);
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
    
}


#pragma mark - UITableView dataSource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 264*sratio;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return prayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrayerCell"];
    
    if(!cell) {
        cell = [[PrayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrayerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    [cell updateWithPrayerObject:[prayers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDPrayer *prayer = [prayers objectAtIndex:indexPath.row];
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
    [self.navigationController pushViewController:commentsController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
