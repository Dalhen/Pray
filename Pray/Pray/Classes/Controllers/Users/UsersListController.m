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
- (id)initWithUsersList:(NSArray *)usersList {
    self = [super init];
    if (self) {
        users = [[NSArray alloc] initWithArray:usersList];
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

- (void)viewWillAppear:(BOOL)animated {
    [self registerForEvents];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unRegisterForEvents];
}


#pragma mark - Events registration
- (void)registerForEvents {
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsSuccess, updateUserDetailsSuccess:);
    Notification_Observe(JXNotification.UserServices.UpdateUserDetailsFailed, updateUserDetailsFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsSuccess);
    Notification_Remove(JXNotification.UserServices.UpdateUserDetailsFailed);
    Notification_RemoveObserver;
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
    
    [mainTable reloadData];
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
    }
    
    [cell loadWithUserData:[users objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [SVProgressHUD showWithStatus:LocString(@"Loading...") maskType:SVProgressHUDMaskTypeGradient];
    [NetworkService viewUserInfoForID:[users objectAtIndex:indexPath.row]];
}


#pragma mark - Loading profile
- (void)updateUserDetailsSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    ProfileController *profileController = [[ProfileController alloc] initWithUser:notification.object];
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)updateUserDetailsFailed {
    [SVProgressHUD showErrorWithStatus:LocString(@"Couldn't load this profile. Please check your connection and try again.")];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
