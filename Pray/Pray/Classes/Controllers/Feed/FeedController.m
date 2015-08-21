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



- (id)init {
    self = [super init];
    
    if (self) {
        prayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
    [self loadFeed];
}

- (void)setupHeader {
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
//    UIButton *feedSelector = [UIButton buttonWithType:UIButtonTypeCustom];
//    [feedSelector setFrame:CGRectMake(0, disclaimer1.bottom - 6*sratio, self.view.screenWidth/2, 43*sratio)];
//    [feedSelector setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
//    [feedSelector setTitle:LocString(@"DEPARTMENT") forState:UIControlStateNormal];
//    [feedSelector setTitleColor:Colour_255RGB(144, 144, 144) forState:UIControlStateNormal];
//    [feedSelector.titleLabel setFont:[FontService systemFont:11*sratio]];
//    [feedSelector setImageEdgeInsets:UIEdgeInsetsMake(0, 130*sratio, 0, 0)];
//    [feedSelector setTitleEdgeInsets:UIEdgeInsetsMake(0, 4*sratio, 0, 0)];
//    [feedSelector addTarget:self action:@selector(displayDepartmentSelectorPanel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:feedSelector];
    
//    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchButton setFrame:CGRectMake(self.view.screenWidth/2, disclaimer1.bottom - 6*sratio, self.view.screenWidth/2, 43*sratio)];
//    [searchButton setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(displayLocationSelectorPanel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:searchButton];
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
    [NetworkService loadFeedForDiscover:YES];
}

- (void)loadFeedSuccess:(NSNotification *)notification {
    refreshing = NO;
    
    //maxMomentPerPage = [[notification.object objectForKey:@"page_size"] intValue];
    //maxPagesCount = [[notification.object objectForKey:@"page_count"] intValue];
    
    if (currentPage==0) {
        prayers = [[NSMutableArray alloc] initWithArray:notification.object];
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
