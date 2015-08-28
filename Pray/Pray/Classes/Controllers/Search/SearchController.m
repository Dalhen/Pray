//
//  SearchController.m
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()

@end

@implementation SearchController


- (id)init {
    self = [super init];
    
    if (self) {
        results = [[NSMutableArray alloc] init];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 56*sratio)];
    [headerView setBackgroundColor:Colour_PrayDarkBlue];
    [self.view addSubview:headerView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0*sratio, 14*sratio, 40*sratio, 40*sratio)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = LocString(@"Search");
    titleLabel.font = [FontService systemFont:14*sratio];
    titleLabel.textColor = Colour_White;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
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
    Notification_Observe(JXNotification.UserServices.ViewUserInfoSuccess, loadUserInfoSuccess:);
    Notification_Observe(JXNotification.UserServices.ViewUserInfoFailed, loadUserInfoFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.UserServices.GetPrayersForUserSuccess);
    Notification_Remove(JXNotification.UserServices.GetPrayersForUserFailed);

    Notification_RemoveObserver;
}


#pragma mark - UITableView dataSource & delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 66*sratio;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return notifications.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsCell"];
//    
//    if(!cell) {
//        cell = [[NotificationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationsCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    [cell updateWithNotification:[notifications objectAtIndex:indexPath.row]];
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
