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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76*sratio, 20*sratio, 162*sratio, 26*sratio)];
    titleLabel.text = LocString(@"Settings");
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
    Notification_Observe(JXNotification.SettingsServices.GetSettingsSuccess, loadSettingsSuccess:);
    Notification_Observe(JXNotification.SettingsServices.GetSettingsFailed, loadSettingsFailed);
}

- (void)unRegisterForEvents {
    Notification_Remove(JXNotification.SettingsServices.GetSettingsSuccess);
    Notification_Remove(JXNotification.SettingsServices.GetSettingsFailed);
    Notification_RemoveObserver;
}


#pragma mark - Loading data
- (void)loadSettings {
    [SVProgressHUD showWithStatus:LocString(@"Loading") maskType:SVProgressHUDMaskTypeGradient];
    [NetworkService getSettings];
}

- (void)loadSettingsSuccess:(NSNotification *)notification {
    [SVProgressHUD dismiss];
    [mainTable reloadData];
}

- (void)loadSettingsFailed {
    [SVProgressHUD dismiss];
}


#pragma mark - UITableView dataSource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*sratio;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Terms + Info
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = LocString(@"Privacy Policy");
                break;
                
            case 1:
                cell.textLabel.text = LocString(@"Terms Of Service");
                break;
                
            case 2:
                cell.textLabel.text = LocString(@"Learn more");
                break;
                
            default:
                break;
        }
    }
    
    //Log out
    else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
