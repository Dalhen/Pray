//
//  UsersListController.m
//  Pray
//
//  Created by Jason LAPIERRE on 30/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "UsersListController.h"
#import "UserCell.h"
#import "PKRevealController.h"
#import "ProfileController.h"

@interface UsersListController ()

@end

@implementation UsersListController


#pragma mark - Init
- (id)initWithTitle:(NSString *)title andUsersList:(NSArray *)usersList {
    self = [super init];
    if (self) {
        headerTitle = title;
        users = [[NSMutableArray alloc] initWithArray:usersList];
    }
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:Colour_White];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupHeader];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
    
    NSArray *currentUsers = [[NSArray alloc] initWithArray:users];
    
    for (NSInteger i = 0; i<[currentUsers count]; i++) {
        CDUser *user = [currentUsers objectAtIndex:i];
        CDUser *updatedUser = [DataAccess getUserForID:user.uniqueId];
        [users replaceObjectAtIndex:i withObject:updatedUser];
    }
    
    [mainTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
//    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsSuccess, updateUserDetailsSuccess:);
//    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsFailed, updateUserDetailsFailed);
}

- (void)unRegisterForEvents {
//    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsSuccess);
//    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsFailed);
    Notification_RemoveObserver;
}


- (void)setupHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_255RGB(232, 232, 232)];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56*sratio, 20*sratio, 202*sratio, 26*sratio)];
    titleLabel.text = headerTitle;
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_255RGB(82, 82, 82);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setupTableView {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio)];
    [mainTable setBackgroundColor:Colour_White];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setScrollsToTop:YES];
    [mainTable setDelegate:self];
    [mainTable setDataSource:self];
    [self.view addSubview:mainTable];
    
    [mainTable reloadData];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView dataSource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66*sratio;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    if(!cell) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelegate:self];
    }
    
    [cell updateWithUserObject:[users objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedUser = [users objectAtIndex:indexPath.row];
    ProfileController *profileController = [[ProfileController alloc] initWithUser:selectedUser];
    [self.navigationController pushViewController:profileController animated:YES];
}


#pragma mark - Loading profile
- (void)updateUserDetailsSuccess:(NSNotification *)notification {
    
}

- (void)updateUserDetailsFailed {
    [SVProgressHUD showErrorWithStatus:LocString(@"Couldn't load this profile. Please check your connection and try again.")];
}


#pragma mark - UserCell delegate
- (void)followUserForCell:(UserCell *)cell {
    [NetworkService followUserForID:[cell.currentUser.uniqueId stringValue]];
}

- (void)unfollowUserForCell:(UserCell *)cell {
    [NetworkService unfollowUserForID:[cell.currentUser.uniqueId stringValue]];
}

- (void)unfollowUserSuccess {
    
}

- (void)unfollowUserFailed {
    
}

- (void)showUserForCell:(UserCell *)cell {
    ProfileController *profileController = [[ProfileController alloc] initWithUser:cell.currentUser];
    [self.navigationController pushViewController:profileController animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
