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
#import "SignupController.h"
#import "PrayerCreationController.h"
#import "UsersListController.h"


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

    if ([currentUser.uniqueId isEqualToNumber:[UserService getUserIDNumber]]) {
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setFrame:CGRectMake(10*sratio, 18*sratio, 40*sratio, 40*sratio)];
        [menuButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:menuButton];
    }
    else {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0*sratio, 18*sratio, 40*sratio, 40*sratio)];
        [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76*sratio, 28*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = [NSString stringWithFormat:@"@%@", currentUser.username];
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_White;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(256*sratio, 22*sratio, 52*sratio, 30*sratio)];
    [rightButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [rightButton.layer setCornerRadius:5.0f];
    if ([currentUser.uniqueId isEqualToNumber:[UserService getUserIDNumber]]) {
        [rightButton setBackgroundColor:Colour_255RGB(140, 146, 164)];
        [rightButton setTitle:LocString(@"Edit") forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [rightButton setBackgroundColor:Colour_PrayBlue];
        [rightButton setTitle:LocString(@"Pray") forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(prayForUser) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:rightButton];
}

- (void)setupProfileHeader {
    
    profileHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 196*sratio)];
    
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16*sratio, 48*sratio, 48*sratio)];
    [userAvatar setRoundedToDiameter:48*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [userAvatar setBackgroundColor:Colour_White];
    [profileHeader addSubview:userAvatar];
    [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    [userAvatar centerHorizontallyInSuperView];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userAvatar.bottom + 4*sratio, self.view.screenWidth, 26*sratio)];
    [usernameLabel setBackgroundColor:Colour_Clear];
    [usernameLabel setFont:[FontService systemFontBold:14*sratio]];
    [usernameLabel setTextColor:Colour_White];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [profileHeader addSubview:usernameLabel];
    [userAvatar centerHorizontallyInSuperView];
    
    userDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, usernameLabel.bottom - 10*sratio, 290*sratio, 58*sratio)];
    [userDescription setFont:[FontService systemFont:12*sratio]];
    [userDescription setTextColor:Colour_255RGB(140, 146, 164)];
    [userDescription setNumberOfLines:3];
    userDescription.textAlignment = NSTextAlignmentCenter;
    [profileHeader addSubview:userDescription];
    [userDescription centerHorizontallyInSuperView];
    
    
    //Stat 1
    userPrayers = [[UILabel alloc] initWithFrame:CGRectMake(0, 154*sratio, self.view.screenWidth/3, 15*sratio)];
    [userPrayers setTextColor:Colour_PrayBlue];
    [userPrayers setFont:[FontService systemFontBold:12*sratio]];
    [userPrayers setTextAlignment:NSTextAlignmentCenter];
    [userPrayers setText:LocString(@"0")];
    [profileHeader addSubview:userPrayers];
    
    UILabel *prayersTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, userPrayers.bottom, self.view.screenWidth/3, 16*sratio)];
    [prayersTitle setTextColor:Colour_255RGB(125, 131, 144)];
    [prayersTitle setTextAlignment:NSTextAlignmentCenter];
    [prayersTitle setText:LocString(@"prayers")];
    [prayersTitle setFont:[FontService systemFont:12*sratio]];
    [profileHeader addSubview:prayersTitle];
    
    //Stat 2
    userFollowers = [[UILabel alloc] initWithFrame:CGRectMake(self.view.screenWidth/3, 154*sratio, self.view.screenWidth/3, 15*sratio)];
    [userFollowers setTextColor:Colour_PrayBlue];
    [userFollowers setFont:[FontService systemFontBold:12*sratio]];
    [userFollowers setTextAlignment:NSTextAlignmentCenter];
    [userFollowers setText:LocString(@"0")];
    [profileHeader addSubview:userFollowers];
    
    UILabel *followersTitle = [[UILabel alloc] initWithFrame:CGRectMake(userFollowers.left, userFollowers.bottom, self.view.screenWidth/3, 16*sratio)];
    [followersTitle setTextColor:Colour_255RGB(125, 131, 144)];
    [followersTitle setTextAlignment:NSTextAlignmentCenter];
    [followersTitle setText:LocString(@"followers")];
    [followersTitle setFont:[FontService systemFont:12*sratio]];
    [profileHeader addSubview:followersTitle];
    
    UIButton *followersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followersButton setFrame:CGRectMake(self.view.screenWidth/3, 146*sratio, self.view.screenWidth/3, 48*sratio)];
    [followersButton addTarget:self action:@selector(getFollowers) forControlEvents:UIControlEventTouchUpInside];
    [profileHeader addSubview:followersButton];
    
    //Stat 3
    userFollowing = [[UILabel alloc] initWithFrame:CGRectMake(self.view.screenWidth*2/3, 154*sratio, self.view.screenWidth/3, 15*sratio)];
    [userFollowing setTextColor:Colour_PrayBlue];
    [userFollowing setFont:[FontService systemFontBold:12*sratio]];
    [userFollowing setTextAlignment:NSTextAlignmentCenter];
    [userFollowing setText:LocString(@"0")];
    [profileHeader addSubview:userFollowing];
    
    UILabel *followingTitle = [[UILabel alloc] initWithFrame:CGRectMake(userFollowing.left, userPrayers.bottom, self.view.screenWidth/3, 16*sratio)];
    [followingTitle setTextColor:Colour_255RGB(125, 141, 144)];
    [followingTitle setTextAlignment:NSTextAlignmentCenter];
    [followingTitle setText:LocString(@"following")];
    [followingTitle setFont:[FontService systemFont:12*sratio]];
    [profileHeader addSubview:followingTitle];
    
    UIButton *followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followingButton setFrame:CGRectMake(self.view.screenWidth*2/3, 146*sratio, self.view.screenWidth/3, 48*sratio)];
    [followingButton addTarget:self action:@selector(getFollowing) forControlEvents:UIControlEventTouchUpInside];
    [profileHeader addSubview:followingButton];
    
    //Separators
    UIView *horizSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 146*sratio, self.view.screenWidth, 1)];
    [horizSeparator setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [profileHeader addSubview:horizSeparator];
    
    UIView *verticalSeparator1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.screenWidth/3, 160*sratio, 1, 22*sratio)];
    [verticalSeparator1 setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [profileHeader addSubview:verticalSeparator1];
    
    UIView *verticalSeparator2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.screenWidth*2/3, 160*sratio, 1, 22*sratio)];
    [verticalSeparator2 setBackgroundColor:Colour_255RGB(59, 63, 75)];
    [profileHeader addSubview:verticalSeparator2];
    
    //Follow button
    if (![currentUser.uniqueId isEqualToNumber:[UserService getUserIDNumber]]) {
        followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [followButton setFrame:CGRectMake(28*sratio, 30*sratio, 78*sratio, 26*sratio)];
        [followButton.titleLabel setFont:[FontService systemFont:13*sratio]];
        [followButton.layer setCornerRadius:5.0f];
        if (currentUser.isFollowed.boolValue == false) {
            [followButton setTitle:LocString(@"Follow") forState:UIControlStateNormal];
            [followButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
            [followButton setBackgroundColor:Colour_PrayBlue];
            [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
        }
        else {
            [followButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
            [followButton addTarget:self action:@selector(unfollowUser) forControlEvents:UIControlEventTouchUpInside];
            [followButton setBackgroundColor:Colour_255RGB(21, 24, 32)];
            [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
        }
        [profileHeader addSubview:followButton];
    }
}

- (void)setupTableView {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 54*sratio, self.view.screenWidth, self.view.screenHeight - 54*sratio)];
    [mainTable setBackgroundColor:Colour_PrayDarkBlue];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setScrollsToTop:YES];
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
    
    [mainTable setTableHeaderView:profileHeader];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTintColor:Colour_White];
    [mainTable addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
    [self updateUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    Notification_Observe(JXNotification.UserServices.GetUserFollowersSuccess, getFollowersSuccess:);
    Notification_Observe(JXNotification.UserServices.GetUserFollowersFailed, getFollowersFailed);
    Notification_Observe(JXNotification.UserServices.GetFollowedUsersSuccess, getFollowingSuccess:);
    Notification_Observe(JXNotification.UserServices.GetFollowedUsersFailed, getFollowingFailed);
    
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
    Notification_Remove(JXNotification.UserServices.GetUserFollowersSuccess);
    Notification_Remove(JXNotification.UserServices.GetUserFollowersFailed);
    Notification_Remove(JXNotification.UserServices.GetFollowedUsersSuccess);
    Notification_Remove(JXNotification.UserServices.GetFollowedUsersFailed);
    
    Notification_Remove(JXNotification.FeedServices.DeletePostSuccess);
    Notification_Remove(JXNotification.FeedServices.DeletePostFailed);
    Notification_Remove(JXNotification.FeedServices.ReportPostSuccess);
    Notification_Remove(JXNotification.FeedServices.ReportPostFailed);
    
    Notification_Remove(JXNotification.FeedServices.LikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.LikePostFailed);
    Notification_Remove(JXNotification.FeedServices.UnLikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.UnLikePostFailed);
    Notification_RemoveObserver;
}


#pragma mark - Loading user data
- (void)loadUserInfoWithID:(NSString *)userId {
    [NetworkService viewUserInfoForID:userId];
}

- (void)loadUserInfoSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    
    currentUser = notification.object;
    [self updateUserInfo];
}

- (void)updateUserInfo {
    
    //Avatar
    if (currentUser.avatar != nil && ![currentUser.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:currentUser.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    //Name
    [usernameLabel setText:[NSString stringWithFormat:@"%@ %@", currentUser.firstname? currentUser.firstname : @"", currentUser.lastname? currentUser.lastname : @""]];
     //(([currentUser.firstname isEqualToString:@""]||currentUser.firstname==nil)? @"Unkown" : currentUser.firstname)];
    
    //Description
    [userDescription setText:(([currentUser.bio isEqualToString:@""]||currentUser.bio==nil)? @"No bio." : currentUser.bio)];
    
    //Stats
    [userPrayers setText:currentUser.prayersCount];
    [userFollowers setText:currentUser.followersCount];
    [userFollowing setText:currentUser.followingCount];
    
    //Follow - Unfollow
    if (currentUser.isFollowed.boolValue) {
        [followButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
        [followButton setBackgroundColor:Colour_255RGB(21, 24, 32)];
        [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
        [followButton removeTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
        [followButton addTarget:self action:@selector(unfollowUser) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [followButton setTitle:LocString(@"Follow") forState:UIControlStateNormal];
        [followButton setBackgroundColor:Colour_PrayBlue];
        [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
        [followButton removeTarget:self action:@selector(unfollowUser) forControlEvents:UIControlEventTouchUpInside];
        [followButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)loadUserInfoFailed {
    if (!currentUser) {
        [SVProgressHUD showErrorWithStatus:LocString(@"We couldn't load the information about the profile. Please check your connection and try again.")];
    }
}


#pragma mark - Loading users prayers
- (void)refreshTriggered {
    [self loadUsersPrayersAnimated:NO];
}

- (void)loadUsersPrayersAnimated:(BOOL)animated {
    if (animated) {
        [SVProgressHUD showWithStatus:LocString(@"Loading") maskType:SVProgressHUDMaskTypeGradient];
    }
    [NetworkService loadPrayersForUser:[currentUser.uniqueId stringValue]];
}

- (void)loadNextPrayers {
    CDPrayer *lastPrayer = [prayers lastObject];
    [NetworkService loadMorePrayersForUser:[currentUser.uniqueId stringValue] withLastID:[lastPrayer.uniqueId stringValue]];
}

- (void)loadPrayersForUserSuccess:(NSNotification *)notification {
    refreshing = NO;
    
    //maxPagesCount = [[notification.object objectForKey:@"page_count"] intValue];
    maxMomentPerPage = [notification.object count];
    
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
    return prayerCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return prayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrayerCell"];
    
    if(!cell) {
        cell = [[PrayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrayerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftUtilityButtons = nil;
        cell.delegate = self;
    }
    
    cell.rightUtilityButtons = [self cellRightButtonsForCurrentGroupCellAndPrayer:[prayers objectAtIndex:indexPath.row]];
    [cell updateWithPrayerObject:[prayers objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CDPrayer *prayer = [prayers objectAtIndex:indexPath.row];
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer andDisplayCommentsOnly:YES];
    [self.navigationController pushViewController:commentsController animated:YES];
}

- (NSArray *)cellRightButtonsForCurrentGroupCellAndPrayer:(CDPrayer *)prayer {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Colour_255RGB(40, 155, 229) title:@"Report"];
    
    NSLog(@"UserID: %@", [UserService getUserID]);
    NSLog(@"CreatorID: %@", prayer.creatorId);
    
    if ([[prayer.creatorId stringValue] isEqualToString:[UserService getUserID]]) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:Colour_255RGB(254, 74, 68) title:@"Delete"];
    }
    return rightUtilityButtons;
}


#pragma mark - SWTableViewCell Delegates
// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    currentlyEditedCell = cell;
    switch (index) {
        case 0: {
            reportPostAlert = [[UIAlertView alloc] initWithTitle:LocString(@"Report a prayer") message:LocString(@"Are you sure you want to report this prayer?") delegate:self cancelButtonTitle:LocString(@"No") otherButtonTitles:LocString(@"Yes, report it!"), nil];
            [reportPostAlert show];
        }
            break;
            
        case 1: {
            deletePostAlert = [[UIAlertView alloc] initWithTitle:LocString(@"Deleting prayer?") message:LocString(@"Are you sure you want to delete your prayer? This action cannot be undone.") delegate:self cancelButtonTitle:LocString(@"No") otherButtonTitles:LocString(@"Yes, delete it!"), nil];
            [deletePostAlert show];
        }
            break;
            
        default:
            break;
    }
}

// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    return YES;
}


#pragma mark - SWTableViewCell Actions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [(SWTableViewCell *)currentlyEditedCell hideUtilityButtonsAnimated:YES];
    
    if (buttonIndex == 1) {
        if (alertView == reportPostAlert) {
            [SVProgressHUD showWithStatus:LocString(@"Reporting post...") maskType:SVProgressHUDMaskTypeGradient];
            [NetworkService reportPostWithID:[prayers objectAtIndex:[[mainTable indexPathForCell:currentlyEditedCell] row]]];
        }
        else if (alertView == deletePostAlert) {
            [SVProgressHUD showWithStatus:LocString(@"Deleting your post...") maskType:SVProgressHUDMaskTypeGradient];
            [NetworkService deletePostWithID:[prayers objectAtIndex:[[mainTable indexPathForCell:currentlyEditedCell] row]]];
            
            NSInteger row = [[mainTable indexPathForCell:currentlyEditedCell] row];
            [prayers removeObjectAtIndex:row];
            //            [mainTable reloadData];
            [mainTable beginUpdates];
            [mainTable deleteRowsAtIndexPaths:@[[mainTable indexPathForCell:currentlyEditedCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [mainTable endUpdates];
        }
    }
}


#pragma mark - UIScrollView delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Data reload system
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[prayers count]-1 inSection:0];
    if ([mainTable.indexPathsForVisibleRows containsObject:indexPath]
        && [prayers count]>=maxMomentPerPage
        && !refreshing)
        //&& currentPage < maxPagesCount
    {
        currentPage +=1;
        refreshing = YES;
        [self loadNextPrayers];
    }
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
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer andDisplayCommentsOnly:YES];
    [self.navigationController pushViewController:commentsController animated:YES];
}


#pragma mark - Delete post delegate
- (void)deletePostSuccess {
    [SVProgressHUD showSuccessWithStatus:LocString(@"Your prayer has been deleted.")];
}

- (void)deletePostFailed {
    [SVProgressHUD showSuccessWithStatus:LocString(@"We couldn't delete your prayer at this time. Please check your internet connection and try again.")];
}


#pragma mark - Report post delegate
- (void)reportPostSuccess {
    [SVProgressHUD showSuccessWithStatus:LocString(@"This prayer has been reported. We will look at it closely and take any necessary action.")];
}

- (void)reportPostFailed {
    [SVProgressHUD showSuccessWithStatus:LocString(@"We couldn't report this prayer. Please check your internet connection and try again.")];
}


#pragma mark - Header actions
- (void)prayForUser {
    PrayerCreationController *prayerController = [[PrayerCreationController alloc] initWithUser:currentUser];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:prayerController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)editProfile {
    SignupController *profileEditController = [[SignupController alloc] initForProfileEditing];
    [self.navigationController pushViewController:profileEditController animated:YES];
}

- (void)followUser {
    [followButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
    [followButton setBackgroundColor:Colour_255RGB(21, 24, 32)];
    [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [followButton removeTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    [followButton addTarget:self action:@selector(unfollowUser) forControlEvents:UIControlEventTouchUpInside];
    
    [NetworkService followUserForID:[currentUser.uniqueId stringValue]];
}

- (void)unfollowUser {
    [followButton setTitle:LocString(@"Follow") forState:UIControlStateNormal];
    [followButton setBackgroundColor:Colour_White];
    [followButton setTitleColor:Colour_PrayBlue forState:UIControlStateNormal];
    [followButton removeTarget:self action:@selector(unfollowUser) forControlEvents:UIControlEventTouchUpInside];
    [followButton addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
    
    [NetworkService unfollowUserForID:[currentUser.uniqueId stringValue]];
}


#pragma mark - User followers
- (void)getFollowers {
    [SVProgressHUD showWithStatus:LocString(@"Loading followers...")];
    [NetworkService getFollowersForUserWithID:[currentUser.uniqueId stringValue]];
}

- (void)getFollowersSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    UsersListController *usersListController = [[UsersListController alloc] initWithTitle:LocString(@"Followers")
                                                                             andUsersList:notification.object];
    [self.navigationController pushViewController:usersListController animated:YES];
}

- (void)getFollowersFailed {
    [SVProgressHUD showSuccessWithStatus:LocString(@"We couldn't get the list of followers. Please check your internet connection and try again.")];
}


#pragma mark - User following
- (void)getFollowing {
    [SVProgressHUD showWithStatus:LocString(@"Loading users...")];
    [NetworkService getUsersFollowedByUserWithID:[currentUser.uniqueId stringValue]];
}

- (void)getFollowingSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    UsersListController *usersListController = [[UsersListController alloc] initWithTitle:LocString(@"Following")
                                                                             andUsersList:notification.object];
    [self.navigationController pushViewController:usersListController animated:YES];
}

-  (void)getFollowingFailed {
    [SVProgressHUD showSuccessWithStatus:LocString(@"We couldn't get the list of users followed. Please check your internet connection and try again.")];
}


#pragma mark - PrayerCell delegate
- (void)showUserForCell:(PrayerCell *)cell {
    if (cell.prayer.creator) {
        ProfileController *profileController = [[ProfileController alloc] initWithUser:cell.prayer.creator];
        [self.navigationController pushViewController:profileController animated:YES];
    }
}

- (void)showUserForUserObject:(CDUser *)user {
    ProfileController *profileController = [[ProfileController alloc] initWithUser:user];
    [self.navigationController pushViewController:profileController animated:YES];
}


#pragma mark - Sharing
- (void)sharePrayerImage:(UIImage *)image {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
