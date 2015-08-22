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
#import "PrayerCreationController.h"
#import "CommentsController.h"

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
    [self setupAddPrayerButton];
    [self loadFeed];
}

- (void)setupHeader {
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UIButton *feedSelector = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedSelector setFrame:CGRectMake((self.view.screenWidth - 200*sratio)/2, 16*sratio, 200*sratio, 38*sratio)];
    [feedSelector setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    [feedSelector setTitle:LocString(@"Discover") forState:UIControlStateNormal];
    [feedSelector setTitleColor:Colour_White forState:UIControlStateNormal];
    [feedSelector.titleLabel setFont:[FontService systemFont:16*sratio]];
    [feedSelector setImageEdgeInsets:UIEdgeInsetsMake(4*sratio, 140*sratio, 0, 0)];
    [feedSelector setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10*sratio)];
    [feedSelector addTarget:self action:@selector(changeFeedType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedSelector];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setFrame:CGRectMake(self.view.screenWidth - 60*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(displaySearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
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

- (void)setupAddPrayerButton {
    addPrayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPrayerButton setFrame:
     CGRectMake((self.view.screenWidth - 128*sratio)/2, self.view.screenHeight*sratio - 56*sratio - 96*sratio, 128*sratio, 39*sratio)];
    [addPrayerButton setImage:[UIImage imageNamed:@"addPrayerButton"] forState:UIControlStateNormal];
    [addPrayerButton addTarget:self action:@selector(addPrayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPrayerButton];
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


#pragma mark - Loading data
- (void)refreshTriggered {
    [self loadFeed];
}

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
        [prayers addObjectsFromArray:notification.object];
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


#pragma mark - Feed Type
- (void)changeFeedType:(id)sender {
    
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


#pragma mark - Like Post
- (void)likeButtonClickedForCell:(PrayerCell *)cell {
    
    CDPrayer *prayer = [prayers objectAtIndex:[[mainTable indexPathForCell:cell] row]];
    
    if (prayer.isLiked.boolValue == YES) {
        [NetworkService unlikePostWithID:[prayer.uniqueId stringValue]];
    }
    else {
        [NetworkService likePostWithID:[prayer.uniqueId stringValue]];
    }
}

- (void)likePostSuccess {
    
}

- (void)likePostFailed {
    
}

- (void)unlikePostSuccess {
    
}

- (void)unlikePostFailed {
    
}


#pragma mark - Comments
- (void)commentButtonClickedForCell:(PrayerCell *)cell {
    CDPrayer *prayer = [prayers objectAtIndex:[[mainTable indexPathForCell:cell] row]];
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
    [self.navigationController pushViewController:commentsController animated:YES];
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


#pragma mark - AddPrayer
- (void)addPrayer {
    PrayerCreationController *prayerController = [[PrayerCreationController alloc] init];
    [self.navigationController presentViewController:prayerController animated:YES completion:nil];
}


#pragma mark - Search
- (void)displaySearch {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
