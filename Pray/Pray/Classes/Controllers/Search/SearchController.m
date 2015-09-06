//
//  SearchController.m
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SearchController.h"
#import "CommentsController.h"

@interface SearchController ()

@end

@implementation SearchController


- (id)init {
    self = [super init];
    
    if (self) {
        searchResults = [[NSMutableArray alloc] init];
        isSearchingPeople = YES;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupSearchBar];
    [self setupTableView];
}

- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_PrayDarkBlue];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"People", @"Prayers"]];
    [segmentControl setFrame:CGRectMake(0, 24*sratio, 200*sratio, 26*sratio)];
    [segmentControl setTintColor:Colour_255RGB(157, 160, 171)];
    [segmentControl addTarget:self action:@selector(selectorChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [self.view addSubview:segmentControl];
    [segmentControl centerHorizontallyInSuperView];
}

- (void)setupSearchBar {
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, 50*sratio)];
    [search setDelegate:self];
    [self.view addSubview:search];
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


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.FeedServices.SearchSuccess, searchSuccess:);
    Notification_Observe(JXNotification.FeedServices.SearchFailed, searchFailed);
    
    Notification_Observe(JXNotification.FeedServices.DeletePostSuccess, deletePostSuccess);
    Notification_Observe(JXNotification.FeedServices.DeletePostFailed, deletePostFailed);
    Notification_Observe(JXNotification.FeedServices.ReportPostSuccess, reportPostSuccess);
    Notification_Observe(JXNotification.FeedServices.ReportPostFailed, reportPostFailed);
    
    Notification_Observe(JXNotification.FeedServices.LikePostSuccess, likePostSuccess);
    Notification_Observe(JXNotification.FeedServices.LikePostFailed, likePostFailed);
    Notification_Observe(JXNotification.FeedServices.UnLikePostSuccess, unlikePostSuccess);
    Notification_Observe(JXNotification.FeedServices.UnLikePostFailed, unlikePostFailed);
    
    Notification_Observe(JXNotification.UserServices.FollowUserSuccess, followUserSuccess);
    Notification_Observe(JXNotification.UserServices.FollowUserFailed, followUserFailed);
    Notification_Observe(JXNotification.UserServices.UnFollowUserSuccess, unfollowUserSuccess);
    Notification_Observe(JXNotification.UserServices.UnFollowUserFailed, unfollowUserFailed);
    
    Notification_Observe(UIKeyboardWillShowNotification, keyboardWillShow:);
    Notification_Observe(UIKeyboardWillHideNotification, keyboardWillHide:);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.FeedServices.SearchSuccess);
    Notification_Remove(JXNotification.FeedServices.SearchFailed);

    Notification_Remove(JXNotification.FeedServices.DeletePostSuccess);
    Notification_Remove(JXNotification.FeedServices.DeletePostFailed);
    Notification_Remove(JXNotification.FeedServices.ReportPostSuccess);
    Notification_Remove(JXNotification.FeedServices.ReportPostFailed);
    
    Notification_Remove(JXNotification.FeedServices.LikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.LikePostFailed);
    Notification_Remove(JXNotification.FeedServices.UnLikePostSuccess);
    Notification_Remove(JXNotification.FeedServices.UnLikePostFailed);
    
    Notification_Remove(JXNotification.UserServices.FollowUserSuccess);
    Notification_Remove(JXNotification.UserServices.FollowUserFailed);
    Notification_Remove(JXNotification.UserServices.UnFollowUserSuccess);
    Notification_Remove(JXNotification.UserServices.UnFollowUserFailed);
    
    Notification_Remove(UIKeyboardWillShowNotification);
    Notification_Remove(UIKeyboardWillHideNotification);
    
    Notification_RemoveObserver;
}


#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
    [mainTable setHeight:self.view.screenHeight - 56*sratio - keyboardSize.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardSize = keyBoardSize;
    [mainTable setHeight:self.view.screenHeight - 56*sratio];
}


#pragma mark - SegmentedControl delegate
- (void)selectorChanged:(id)sender {
    if (segmentControl.selectedSegmentIndex == 0) {
        isSearchingPeople = YES;
    }
    else {
        isSearchingPeople = NO;
    }
    
    [self updateSearch];
}


#pragma mark - SearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length>2) {
        [self updateSearch];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [search resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [search resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [search resignFirstResponder];
}


#pragma mark - Search Delegate
- (void)updateSearch {
    if (isSearchingPeople) {
        [NetworkService searchForUsersWithText:search.text];
    }
    else {
        [NetworkService searchForPrayersWithText:search.text];
    }
}

- (void)searchSuccess:(NSNotification *)notification {
    searchResults = [[NSArray alloc] initWithArray:notification.object];
    [mainTable reloadData];
}

- (void)searchFailed {
    
}


#pragma mark - UITableView dataSource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearchingPeople) {
        return 74*sratio;
    }
    else {
        return prayerCellHeight;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearchingPeople) {
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        
        if (!cell) {
            cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell updateWithUserObject:[searchResults objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
    else {
        PrayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrayerCell"];
        
        if(!cell) {
            cell = [[PrayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrayerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftUtilityButtons = nil;
            cell.delegate = self;
        }
        
        cell.rightUtilityButtons = [self cellRightButtonsForCurrentGroupCellAndPrayer:[searchResults objectAtIndex:indexPath.row]];
        [cell updateWithPrayerObject:[searchResults objectAtIndex:indexPath.row]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isSearchingPeople) {
        
    }
    else {
        CDPrayer *prayer = [searchResults objectAtIndex:indexPath.row];
        CommentsController *commentsController = [[CommentsController alloc] initWithPrayer:prayer];
        [self.navigationController pushViewController:commentsController animated:YES];
    }
}

- (NSArray *)cellRightButtonsForCurrentGroupCellAndPrayer:(CDPrayer *)prayer {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Colour_255RGB(40, 155, 229) title:@"Report"];
    
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
            [NetworkService reportPostWithID:[searchResults objectAtIndex:[[mainTable indexPathForCell:currentlyEditedCell] row]]];
        }
    }
}
#pragma mark - Like Post
- (void)likeButtonClickedForCell:(PrayerCell *)cell {
    
    CDPrayer *prayer = [searchResults objectAtIndex:[[mainTable indexPathForCell:cell] row]];
    
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
    CDPrayer *prayer = [searchResults objectAtIndex:[[mainTable indexPathForCell:cell] row]];
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


#pragma mark - UserCell delegate
- (void)followUserForCell:(UserCell *)cell {
    
}

- (void)followUserSuccess {
    
}

- (void)followUserFailed {
    
}

- (void)unfollowUserForCell:(UserCell *)cell {
    
}

- (void)unfollowUserSuccess {
    
}

- (void)unfollowUserFailed {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
