//
//  FeedController.m
//  Pray
//
//  Created by Jason LAPIERRE on 29/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "FeedController.h"
#import "PKRevealController.h"
#import "CommentsController.h"
#import "SearchController.h"
#import "ProfileController.h"

@interface FeedController ()

@end

@implementation FeedController



- (id)init {
    self = [super init];
    
    if (self) {
        showDiscover = YES;
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
    [self setupSwitchMenu];
    [self setupAddPrayerButton];
    [self loadFeedAnimated:YES];
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
    [feedSelector addTarget:self action:@selector(switchMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedSelector];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setFrame:CGRectMake(self.view.screenWidth - 60*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(displaySearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

- (void)setupSwitchMenu {
    switchMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, 0)];
    [switchMenu setBackgroundColor:Colour_255RGB(46, 48, 56)];
    [switchMenu setClipsToBounds:YES];
    [self.view addSubview:switchMenu];
    
    feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedButton setFrame:CGRectMake(0, 0, self.view.screenWidth/2, 54*sratio)];
    [feedButton setTitle:LocString(@"Feed") forState:UIControlStateNormal];
    [feedButton setTitleColor:Colour_255RGB(111, 116, 132) forState:UIControlStateNormal];
    [feedButton setTitleColor:Colour_White forState:UIControlStateSelected];
    [feedButton.titleLabel setFont:[FontService systemFont:16*sratio]];
    [feedButton addTarget:self action:@selector(displayFeed) forControlEvents:UIControlEventTouchUpInside];
    [feedButton setSelected:YES];
    [switchMenu addSubview:feedButton];
    
    followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followingButton setFrame:CGRectMake(self.view.screenWidth/2, 0, self.view.screenWidth/2, 54*sratio)];
    [followingButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
    [followingButton setTitleColor:Colour_255RGB(111, 116, 132) forState:UIControlStateNormal];
    [followingButton setTitleColor:Colour_White forState:UIControlStateSelected];
    [followingButton.titleLabel setFont:[FontService systemFont:16*sratio]];
    [followingButton addTarget:self action:@selector(displayFollowing) forControlEvents:UIControlEventTouchUpInside];
    [followingButton setSelected:NO];
    [switchMenu addSubview:followingButton];
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
    [addPrayerButton setFrame:CGRectMake((self.view.screenWidth - 128*sratio)/2, self.view.screenHeight - 60*sratio, 128*sratio, 39*sratio)];
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
    Notification_Remove(JXNotification.FeedServices.LikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.LikePostFailed);
    Notification_Remove(JXNotification.FeedServices.UnLikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.UnLikePostFailed);
    
    Notification_RemoveObserver;
}


#pragma mark - SwitchMenu
- (void)switchMenuClicked {
    if (!displayingSwitchMenu) {
        [self displaySwitchMenu];
    }
    else {
        [self hideSwitchMenu];
    }
}

- (void)displaySwitchMenu {
    displayingSwitchMenu = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [switchMenu setHeight:54*sratio];
    }];
}

- (void)hideSwitchMenu {
    displayingSwitchMenu = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [switchMenu setHeight:0];
    }];
}

- (void)displayFeed {
    [feedButton setSelected:YES];
    [followingButton setSelected:NO];
    showDiscover = YES;
    [self hideSwitchMenu];
    [self loadFeedAnimated:YES];
}

- (void)displayFollowing {
    [feedButton setSelected:NO];
    [followingButton setSelected:YES];
    showDiscover = NO;
    [self hideSwitchMenu];
    [self loadFeedAnimated:YES];
}


#pragma mark - Loading data
- (void)refreshTriggered {
    [self loadFeedAnimated:NO];
}

- (void)loadFeedAnimated:(BOOL)animated {
    if (animated) {
        [SVProgressHUD showWithStatus:LocString(@"Loading") maskType:SVProgressHUDMaskTypeGradient];
    }
    [NetworkService loadFeedForDiscover:showDiscover];
}

- (void)loadNextPrayers {
    CDPrayer *lastPrayer = [prayers lastObject];
    [NetworkService loadMorePrayersWithLastID:[lastPrayer.uniqueId stringValue] forDiscover:showDiscover];
}

- (void)loadFeedSuccess:(NSNotification *)notification {
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

- (void)loadFeedFailed {
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
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
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
    
    if (displayingSwitchMenu) {
        [self hideSwitchMenu];
    }
    
    //Data reload system
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[prayers count]-1 inSection:0];
    if ([mainTable.indexPathsForVisibleRows containsObject:indexPath]
        && [prayers count]>=maxMomentPerPage
        && !refreshing)
        //&& currentPage < maxPagesCount
    {
        currentPage +=1;
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
    CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
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
    
}


#pragma mark - AddPrayer
- (void)addPrayer {
    PrayerCreationController *prayerController = [[PrayerCreationController alloc] init];
    [prayerController setDelegate:self];
    [self.navigationController presentViewController:prayerController animated:YES completion:nil];
}


#pragma mark - Search
- (void)displaySearch {
    SearchController *searchController = [[SearchController alloc] init];
    [self presentViewController:searchController animated:YES completion:nil];
}


#pragma mark - UserProfile
- (void)showUserForCell:(PrayerCell *)cell {
    if (cell.prayer.creator) {
        ProfileController *profileController = [[ProfileController alloc] initWithUser:cell.prayer.creator];
        [self.navigationController pushViewController:profileController animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
