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


- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    self.view = [[BaseView alloc] init];
    selectedLine = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
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
            
        case 1:
            controller = [[NotificationsController alloc] init];
            break;
            
        case 2:
            controller = [[ProfileController alloc] init];
            break;
            
        case 3:
            controller = [[SettingsController alloc] init];
            break;
            
        default:
            break;
    }
    
    [AppDelegate updateFrontViewControllerWithController:controller andFocus:YES];
}



@end
