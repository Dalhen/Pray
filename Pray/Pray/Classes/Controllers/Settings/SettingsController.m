//
//  SettingsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SettingsController.h"
#import "PKRevealController.h"


@interface SettingsController ()

@end

@implementation SettingsController


- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
}

- (void)setupHeader {
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
}

- (void)setupTableView {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [mainTable setBackgroundColor:Colour_PrayDarkBlue];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setScrollsToTop:YES];
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
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
    
    Notification_Observe(JXNotification.FeedServices.LikePostSuccess, likePostSuccess);
    Notification_Observe(JXNotification.FeedServices.LikePostFailed, likePostFailed);
    Notification_Observe(JXNotification.FeedServices.UnLikePostSuccess, unlikePostSuccess);
    Notification_Observe(JXNotification.FeedServices.UnLikePostFailed, unlikePostFailed);
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


//#pragma mark - Loading data
//- (void)refreshTriggered {
//    [self loadFeedAnimated:NO];
//}
//
//- (void)loadFeedAnimated:(BOOL)animated {
//    if (animated) {
//        [SVProgressHUD showWithStatus:LocString(@"Loading") maskType:SVProgressHUDMaskTypeGradient];
//    }
//    [NetworkService loadFeedForDiscover:YES];
//}
//
//- (void)loadFeedSuccess:(NSNotification *)notification {
//    refreshing = NO;
//    
//    //maxMomentPerPage = [[notification.object objectForKey:@"page_size"] intValue];
//    //maxPagesCount = [[notification.object objectForKey:@"page_count"] intValue];
//    
//    if (currentPage==0) {
//        prayers = [[NSMutableArray alloc] initWithArray:notification.object];
//        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
//        [mainTable reloadData];
//    }
//    else {
//        [prayers addObjectsFromArray:notification.object];
//        if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
//        [mainTable reloadData];
//    }
//    
//    [SVProgressHUD dismiss];
//    
//    //[mainTable setHidden:([prayers count]==0)];
//}
//
//- (void)loadFeedFailed {
//    refreshing = NO;
//    [SVProgressHUD dismiss];
//    if ([refreshControl isRefreshing]) [refreshControl endRefreshing];
//}
//
//
//#pragma mark - Feed Type
//- (void)changeFeedType:(id)sender {
//    
//}
//
//
//#pragma mark - UITableView dataSource & delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 264*sratio;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return prayers.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PrayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrayerCell"];
//    
//    if(!cell) {
//        cell = [[PrayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrayerCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
//    }
//    
//    [cell updateWithPrayerObject:[prayers objectAtIndex:indexPath.row]];
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    CDPrayer *prayer = [prayers objectAtIndex:indexPath.row];
//    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
//    [self.navigationController pushViewController:commentsController animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
