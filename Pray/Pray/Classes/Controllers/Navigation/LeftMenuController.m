//
//  LeftMenuController.m
//  Pray
//
//  Created by Jason LAPIERRE on 26/07/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "LeftMenuController.h"
#import "BaseView.h"

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


//#pragma mark - Table view data source
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 54;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftMenuCell class])];
//    if (!cell) {
//        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([LeftMenuCell class])];
//    }
//    
//    switch (indexPath.row) {
//            
//        case 0:
//            [cell.title setText:@"Réserver"];
//            [cell setIconsSetWithOffImage:@"liveMapIconOFF" andOnImage:@"liveMapIconON"];
//            [cell.accessoryButton setHidden:YES];
//            break;
//            
//        case 1:
//            [cell.title setText:@"Historique"];
//            [cell setIconsSetWithOffImage:@"historyIconOFF" andOnImage:@"historyIconON"];
//            [cell.accessoryButton setHidden:YES];
//            break;
//            
//        case 2:
//            [cell.title setText:@"Paiement"];
//            [cell setIconsSetWithOffImage:@"cardDetailsIconOFF" andOnImage:@"cardDetailsIconON"];
//            [cell.accessoryButton setHidden:YES];
//            break;
//            
//        case 3:
//            [cell.title setText:@"Profil"];
//            [cell setIconsSetWithOffImage:@"profileIconOFF" andOnImage:@"profileIconON"];
//            [cell.accessoryButton setHidden:YES];
//            break;
//            
//        case 4:
//            [cell.title setText:@"Réglages"];
//            [cell setIconsSetWithOffImage:@"settingsIconOFF" andOnImage:@"settingsIconON"];
//            [cell.accessoryButton setHidden:YES];
//            break;
//            
//        default:
//            break;
//    }
//    
//    return cell;
//}
//
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UIViewController *controller;
//    
//    switch (indexPath.row) {
//        case 0:
//            controller = [[DashboardController alloc] init];
//            break;
//            
//        case 1:
//            controller = [[HistoryController alloc] init];
//            break;
//            
//        case 2:
//            controller = [[EditPaymentController alloc] init];
//            break;
//            
//        case 3:
//            controller = [[ProfileViewController alloc] init];
//            break;
//            
//        case 4:
//            controller = [[SettingsController alloc] init];
//            break;
//            
//        default:
//            break;
//    }
//    
//    [AppDelegate updateFrontViewControllerWithController:controller andFocus:YES];
//}
//


@end
