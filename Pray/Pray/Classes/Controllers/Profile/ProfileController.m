//
//  ProfileController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "ProfileController.h"
#import "PKRevealController.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"
#import "CommentsController.h"


@interface ProfileController ()

@end

@implementation ProfileController


- (id)initWithUser:(CDUser *)aUser {
    self = [super init];
    
    if (self) {
        currentUser = aUser;
        prayers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupProfileHeader];
    [self setupTableView];
    [self loadUserInfoWithID:[currentUser.uniqueId stringValue]];
    [self loadUsersPrayersAnimated:YES];
}

- (void)setupHeader {

    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(10*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
}

- (void)setupProfileHeader {
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:userAvatar];
    [userAvatar centerHorizontallyInSuperView];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userAvatar.bottom + 10*sratio, self.view.screenWidth, 26*sratio)];
    [usernameLabel setBackgroundColor:Colour_Clear];
    [usernameLabel setFont:[FontService systemFont:14*sratio]];
    [usernameLabel setTextColor:Colour_PrayBlue];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:usernameLabel];
    [userAvatar centerHorizontallyInSuperView];
    
    userDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, usernameLabel.bottom, 290*sratio, 48*sratio)];
    userDescription.font = [FontService systemFont:12*sratio];
    userDescription.textColor = Colour_255RGB(140, 146, 164);
    [userDescription setNumberOfLines:3];
    userDescription.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userDescription];
    [userDescription centerHorizontallyInSuperView];
    
    
    //Stat 1
    userPrayers = [[UILabel alloc] initWithFrame:CGRectMake(0, 144*sratio, self.view.screenWidth/3, 18*sratio)];
    [userPrayers setTextColor:Colour_PrayBlue];
    [userPrayers setFont:[FontService systemFontBold:12*sratio]];
    [userPrayers setTextAlignment:NSTextAlignmentCenter];
    [userPrayers setText:LocString(@"Unknown")];
    [self.view addSubview:userPrayers];
    
    UILabel *prayersTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, userPrayers.bottom, self.view.screenWidth/3, 16)];
    [prayersTitle setTextColor:Colour_255RGB(125, 131, 144)];
    [prayersTitle setTextAlignment:NSTextAlignmentCenter];
    [prayersTitle setText:LocString(@"prayers")];
    [self.view addSubview:prayersTitle];
    
    //Stat 2
    userFollowers = [[UILabel alloc] initWithFrame:CGRectMake(self.view.screenWidth/3, 144*sratio, self.view.screenWidth/3, 18*sratio)];
    [userFollowers setTextColor:Colour_PrayBlue];
    [userFollowers setFont:[FontService systemFontBold:12*sratio]];
    [userFollowers setTextAlignment:NSTextAlignmentCenter];
    [userFollowers setText:LocString(@"Unknown")];
    [self.view addSubview:userFollowers];
    
    UILabel *followersTitle = [[UILabel alloc] initWithFrame:CGRectMake(userFollowers.left, userFollowers.bottom, self.view.screenWidth/3, 16)];
    [followersTitle setTextColor:Colour_255RGB(125, 131, 144)];
    [followersTitle setTextAlignment:NSTextAlignmentCenter];
    [followersTitle setText:LocString(@"followers")];
    [self.view addSubview:followersTitle];
    
    //Stat 3
    userFollowing = [[UILabel alloc] initWithFrame:CGRectMake(self.view.screenWidth*2/3, 144*sratio, self.view.screenWidth/3, 18*sratio)];
    [userFollowing setTextColor:Colour_PrayBlue];
    [userFollowing setFont:[FontService systemFontBold:12*sratio]];
    [userFollowing setTextAlignment:NSTextAlignmentCenter];
    [userFollowing setText:LocString(@"Unknown")];
    [self.view addSubview:userFollowing];
    
    UILabel *followingTitle = [[UILabel alloc] initWithFrame:CGRectMake(userFollowing.left, userPrayers.bottom, self.view.screenWidth/3, 16)];
    [followingTitle setTextColor:Colour_255RGB(125, 131, 144)];
    [followingTitle setTextAlignment:NSTextAlignmentCenter];
    [followingTitle setText:LocString(@"following")];
    [self.view addSubview:followingTitle];
    
    UIView *horizSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 136*sratio, self.view.screenWidth, 1)];
    [horizSeparator setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [self.view addSubview:horizSeparator];
    
    UIView *verticalSeparator1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.screenWidth/3, 150*sratio, 1, 22*sratio)];
    [verticalSeparator1 setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [self.view addSubview:verticalSeparator1];
    
    UIView *verticalSeparator2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.screenWidth*2/3, 150*sratio, 1, 22*sratio)];
    [verticalSeparator2 setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [self.view addSubview:verticalSeparator2];
}

- (void)setupTableView {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 186*sratio, self.view.screenWidth, self.view.screenHeight - 186*sratio)];
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
    Notification_Observe(JXNotification.UserServices.ViewUserInfoSuccess, loadUserInfoSuccess:);
    Notification_Observe(JXNotification.UserServices.ViewUserInfoFailed, loadUserInfoFailed);
    Notification_Observe(JXNotification.UserServices.GetPrayersForUserSuccess, loadPrayersForUserSuccess:);
    Notification_Observe(JXNotification.UserServices.GetPrayersForUserFailed, loadPrayersForUserFailed);
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
    Notification_Remove(JXNotification.UserServices.GetPrayersForUserSuccess);
    Notification_Remove(JXNotification.UserServices.GetPrayersForUserFailed);
    Notification_Remove(JXNotification.UserServices.ViewUserInfoSuccess);
    Notification_Remove(JXNotification.UserServices.ViewUserInfoFailed);
    Notification_Remove(JXNotification.FeedServices.DeletePostSuccess);
    Notification_Remove(JXNotification.FeedServices.DeletePostFailed);
    Notification_Remove(JXNotification.FeedServices.ReportPostSuccess);
    Notification_Remove(JXNotification.FeedServices.ReportPostFailed);
    Notification_RemoveObserver;
}


#pragma mark - Loading user data
- (void)loadUserInfoWithID:(NSString *)userId {
    [NetworkService viewUserInfoForID:userId];
}

- (void)loadUserInfoSuccess:(NSNotification *)notification {
    currentUser = notification.object;
    
    //Avatar
    if (currentUser.avatar != nil && ![currentUser.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:currentUser.avatar]];
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyAvatar"]];
    }
    
    //Name
    [usernameLabel setText:(([currentUser.firstname isEqualToString:@""]||currentUser.firstname==nil)? @"Unkown" : currentUser.firstname)];
    
    //Description
    [userDescription setText:(([currentUser.bio isEqualToString:@""]||currentUser.bio==nil)? @"Unkown" : currentUser.bio)];
}

- (void)loadUserInfoFailed {
    
}


#pragma mark - Loading users prayers
- (void)refreshTriggered {
    [self loadUsersPrayersAnimated:NO];
}

- (void)loadUsersPrayersAnimated:(BOOL)animated {
    if (animated) {
        [SVProgressHUD showWithStatus:LocString(@"Loading") maskType:SVProgressHUDMaskTypeGradient];
    }
    [NetworkService loadFeedForDiscover:YES];
}

- (void)loadPrayersForUserSuccess:(NSNotification *)notification {
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

- (void)loadPrayersForUserFailed {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
