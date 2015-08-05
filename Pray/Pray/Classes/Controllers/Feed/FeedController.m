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
    MomentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegularMomentCell"];
    
    if(!cell) {
        cell = [[MomentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RegularMomentCell"];
        cell.delegate = self;
        [cell setBackgroundColor:Colour_White];
    }
    
    [cell.favouriteButton setTag:indexPath.row];
    [cell updateWithMoment:cellMoment andHeightData:
     [computedHeightsData objectForKey:[NSString stringWithFormat:@"%li", (long)indexPath.row]]];
    
    [cell updateMomentMediaInTableView:tableView forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (tabOption) {
        case TabOptionFeed: {
            CDMoment *momentClicked = [moments objectAtIndex:indexPath.row];
            if ([momentClicked.type isEqualToString:@"col_album"]) {
                AlbumController *albumController = [[AlbumController alloc] initWithAlbumMoment:[moments objectAtIndex:indexPath.row]
                                                                         andCollectionDisplayed:YES];
                [self.navigationController pushViewController:albumController animated:YES];
            }
        }
            break;
            
        case TabOptionPhotos: {
            if (indexPath.row == 0) {
                if([group.images count]>0) {
                    MediaViewController *mediaController = [[MediaViewController alloc] initWithGroup:group andType:typeImage];
                    [self.navigationController pushViewController:mediaController animated:YES];
                }
                else {
                    [ErrorService showErrorForCode:104];
                }
            }
            else if (indexPath.row == 1) {
                if([group.videos count]>0) {
                    MediaViewController *mediaController = [[MediaViewController alloc] initWithGroup:group andType:typeVideo];
                    [self.navigationController pushViewController:mediaController animated:YES];
                }
                else {
                    [ErrorService showErrorForCode:105];
                }
            }
            else if (indexPath.row>2) {
                AlbumController *albumController = [[AlbumController alloc] initWithAlbumMoment:[albums objectAtIndex:indexPath.row-3]
                                                                         andCollectionDisplayed:YES];
                [self.navigationController pushViewController:albumController animated:YES];
            }
        }
            break;
            
            //        case TabOptionMembersAndLink: {
            //            //Private Group OR Group Admin
            //            if ([group.privacyType isEqualToNumber:[NSNumber numberWithInt:0]] || [self isGroupAdmin]) {
            //                if (indexPath.row == 0 && [self isGroupAdmin]) {
            //                    [self displayFriendsSelector];
            //                }
            //                else {
            //                    if ([groupMembers count]>indexPath.row-([self isGroupAdmin]? 1 : 0)) {
            //                        CDUser *user = [DataAccess getUserForID:[NSNumber numberWithInt:[[[groupMembers objectAtIndex:indexPath.row - ([self isGroupAdmin]? 1 : 0)] objectForKey:@"unique_id"] intValue]]];
            //                        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithUser:user andGroupId:[group.uniqueId stringValue]];
            //                        [self.navigationController pushViewController:profileViewController animated:YES];
            //                    }
            //                }
            //            }
            //
            //            //Public Group
            //            else {
            //
            //            }
            //        }
            //            break;
            
            //        case TabOptionSettings: {
            //
            //            //Edit group
            //            if (indexPath.row == 0) {
            //                EditGroupController *editGroupController = [[EditGroupController alloc] initWithGroup:group];
            //                [self.navigationController pushViewController:editGroupController animated:YES];
            //            }
            //
            //            //Invite friends
            //            else if (indexPath.row == 1) {
            //                InviteFriendsController *inviteController = [[InviteFriendsController alloc] initWithGroup:group];
            //                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inviteController];
            //                [self.navigationController presentViewController:navController animated:YES completion:nil];
            //            }
            //        }
            //            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        
    }
    
    [tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LocString(@"Remove this user");
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
