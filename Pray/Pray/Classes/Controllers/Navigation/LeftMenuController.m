//
//  LeftMenuController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "LeftMenuController.h"
#import "BaseView.h"
#import "LeftMenuCell.h"

#import "FeedController.h"
#import "NotificationsController.h"
#import "ProfileController.h"
#import "SettingsController.h"


@interface LeftMenuController ()

@end

@implementation LeftMenuController
@synthesize mainTable;


- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    self.view = [[BaseView alloc] init];
    [self.view setBackgroundColor:Colour_PrayDarkBlue];
    selectedLine = 0;
    [self setupLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.revealController setMinimumWidth:220.0 maximumWidth:244.0 forViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    LeftMenuCell *cell = (LeftMenuCell *)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedLine inSection:0]];
    [cell setSelected:YES animated:YES];
}


#pragma mark - Layout
- (void)setupLayout {
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50*sratio, self.view.screenWidth, self.view.screenHeight - 50*sratio)];
    [mainTable setBackgroundColor:Colour_Clear];
    [mainTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTable setDataSource:self];
    [mainTable setDelegate:self];
    [self.view addSubview:mainTable];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*sratio;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftMenuCell class])];
    if (!cell) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LeftMenuCell class])];
    }
    
    switch (indexPath.row) {
            
        case 0:
            [cell.title setText:LocString(@"Feed")];
            [cell setIconsSetWithOffImage:@"feedOFF" andOnImage:@"feedON"];
            [cell.accessoryButton setHidden:YES];
            break;
            
        case 1:
            [cell.title setText:LocString(@"Notitications")];
            [cell setIconsSetWithOffImage:@"notificationsOFF" andOnImage:@"notificationsON"];
            [cell.accessoryButton setHidden:YES];
            break;
            
        case 2:
            [cell.title setText:LocString(@"Profile")];
            [cell setIconsSetWithOffImage:@"profileOFF" andOnImage:@"profileON"];
            [cell.accessoryButton setHidden:YES];
            break;
            
        case 3:
            [cell.title setText:LocString(@"Settings")];
            [cell setIconsSetWithOffImage:@"settingsOFF" andOnImage:@"settingsON"];
            [cell.accessoryButton setHidden:YES];
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller;
    
    switch (indexPath.row) {
        case 0:
            controller = [[FeedController alloc] init];
            break;
            
//        case 1:
//            controller = [[NotificationsController alloc] init];
//            break;
//            
//        case 2:
//            controller = [[ProfileController alloc] init];
//            break;
//            
//        case 3:
//            controller = [[SettingsController alloc] init];
//            break;
            
        default:
            break;
    }
    
    if (indexPath.row == 0) {
        [AppDelegate updateFrontViewControllerWithController:controller andFocus:YES];
    }
    else {
        LeftMenuCell *cell = (LeftMenuCell *)[mainTable cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
