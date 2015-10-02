//
//  SettingsController.m
//  Pray
//
//  Created by Jason LAPIERRE on 17/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "SettingsController.h"
#import "PKRevealController.h"
#import "WebController.h"

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
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 56*sratio, self.view.screenWidth, self.view.screenHeight - 56*sratio) style:UITableViewStylePlain];
    [mainTable setBackgroundColor:Colour_Clear];
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
    switch (section) {
        case 0:
            return 3;
            break;
            
        case 1:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 38*sratio)];
        [header setBackgroundColor:Colour_255RGB(29, 32, 39)];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*sratio, 0, self.view.screenWidth-20*sratio, 38*sratio)];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setBackgroundColor:Colour_255RGB(29, 32, 39)];
        [textLabel setFont:[FontService systemFont:13*sratio]];
        [textLabel setTextColor:Colour_255RGB(93, 98, 113)];
        [textLabel setText:LocString(@"About us")];
        [header addSubview:textLabel];
        
        return header;
    }
    else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.screenWidth, 38*sratio)];
        [header setBackgroundColor:Colour_255RGB(29, 32, 39)];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*sratio, 0, self.view.screenWidth-20*sratio, 38*sratio)];
        [textLabel setTextAlignment:NSTextAlignmentLeft];
        [textLabel setBackgroundColor:Colour_255RGB(29, 32, 39)];
        [textLabel setFont:[FontService systemFont:13*sratio]];
        [textLabel setTextColor:Colour_255RGB(93, 98, 113)];
        [textLabel setText:LocString(@"Account")];
        [header addSubview:textLabel];
        
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38*sratio;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setBackgroundColor:Colour_255RGB(48, 51, 61)];
        cell.textLabel.textColor = Colour_White;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Terms + Info
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = LocString(@"Privacy Policy");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = Colour_White;
                break;
                
            case 1:
                cell.textLabel.text = LocString(@"Terms Of Service");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = Colour_White;
                break;
                
            case 2:
                cell.textLabel.text = LocString(@"Learn more");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = Colour_White;
                break;
                
            default:
                break;
        }
    }
    
    //Log out
    else {
        cell.textLabel.text = LocString(@"Sign Out");
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = Colour_255RGB(253, 79, 78);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        //Privacy
        if (indexPath.row == 0) {
            WebController *webController = [[WebController alloc] initWithURL:@"http://www.google.com"];
            [self.navigationController pushViewController:webController animated:YES];
        }
        //Terms of Service
        else if (indexPath.row == 1) {
            WebController *webController = [[WebController alloc] initWithURL:@"http://www.google.com"];
            [self.navigationController pushViewController:webController animated:YES];
        }
        //Learn More
        else if (indexPath.row == 2) {
            WebController *webController = [[WebController alloc] initWithURL:@"http://www.google.com"];
            [self.navigationController pushViewController:webController animated:YES];
        }
        
//        if ([MFMailComposeViewController canSendMail]) {
//            
//            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//            picker.mailComposeDelegate = self;
//            NSArray *toRecipients = [NSArray arrayWithObjects:@"theteemapp@gmail.com", nil];
//            [picker setToRecipients:toRecipients];
//            [picker setSubject:@"Feedback"];
//            
//            [self presentViewController:picker animated:YES completion:nil];
//        }
//        else {
//            [SVProgressHUD showErrorWithStatus:LocString(@"Please set an email on this phone before proceeding.")];
//        }
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[[UIAlertView alloc] initWithTitle:LocString(@"Sign Out?") message:LocString(@"Are you sure you want to sign out?") delegate:self cancelButtonTitle:LocString(@"Cancel") otherButtonTitles:LocString(@"Sign Out"), nil] show];
        }
    }
}

#pragma mark - SWTableViewCell Actions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [UserService logoutUser];
        [AppDelegate displayPrehome];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
