//
//  FeedController.m
//  Pray
//
//  Created by Jason LAPIERRE on 29/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "FeedController.h"
#import "BaseView.h"
#import "PKRevealController.h"

@interface FeedController ()

@end

@implementation FeedController



- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (id)init {
    self = [super init];
    
    if (self) {
        prayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[BaseView alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupLayout];
    [self loadFeed];
}

- (void)setupLayout {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, self.view.screenHeight)];
    [mainTable setBackgroundColor:Colour_PrayDarkBlue];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setScrollsToTop:YES];
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


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.FeedServices.LoadFeedSuccess, loadFeedSuccess:);
    Notification_Observe(JXNotification.FeedServices.LoadFeedFailed, loadFeedFailed);
    Notification_Observe(JXNotification.FeedServices.DeletePostSuccess, deletePostSuccess);
    Notification_Observe(JXNotification.FeedServices.DeletePostFailed, deletePostFailed);
    Notification_Observe(JXNotification.FeedServices.ReportPostSuccess, reportPostSuccess);
    Notification_Observe(JXNotification.FeedServices.ReportPostFailed, reportPostFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.FeedServices.LoadFeedSuccess);
    Notification_Remove(JXNotification.FeedServices.LoadFeedFailed);
    Notification_Remove(JXNotification.FeedServices.DeletePostSuccess);
    Notification_Remove(JXNotification.FeedServices.DeletePostFailed);
    Notification_Remove(JXNotification.FeedServices.ReportPostSuccess);
    Notification_Remove(JXNotification.FeedServices.ReportPostFailed);
    Notification_RemoveObserver;
}


#pragma mark - Loading data
- (void)loadFeed {
    [NetworkService loadFeed];
}

- (void)loadFeedSuccess:(NSNotification *)notification {
    refreshing = NO;
    
    maxMomentPerPage = [[notification.object objectForKey:@"page_size"] intValue];
    maxPagesCount = [[notification.object objectForKey:@"page_count"] intValue];
    
    if (currentPage==1) {
        prayers = [[NSMutableArray alloc] initWithArray:[[notification object] objectForKey:@"posts"]];
        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
        [mainTable reloadData];
    }
    else {
        [prayers addObjectsFromArray:[[notification object] objectForKey:@"posts"]];
        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
        [mainTable reloadData];
    }
    
    [SVProgressHUD dismiss];
    
    //[mainTable setHidden:([prayers count]==0)];
}

- (void)loadFeedFailed {
    refreshing = NO;
    [SVProgressHUD dismiss];
    if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
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
        cell.delegate = self;
    }
    
    [cell updateWithPrayerObject:[prayers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Delete post
- (void)deletePost {
    
}

- (void)deletePostSuccess {
    
}

- (void)deletePostFailed {
    
}


#pragma mark - Report post
- (void)reportPost {
    
}

- (void)reportPostSuccess {
    
}

- (void)reportPostFailed {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
