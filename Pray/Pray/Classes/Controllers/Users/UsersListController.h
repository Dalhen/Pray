//
//  UsersListController.h
//  Pray
//
//  Created by Jason LAPIERRE on 30/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCell.h"

@interface UsersListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserCellDelegate> {
    
    UITableView *mainTable;
    NSMutableArray *users;
    NSString *headerTitle;
    
    CDUser *selectedUser;
}

@property(nonatomic, assign) BOOL shouldFollowSelectedUser;

- (id)initWithTitle:(NSString *)title andUsersList:(NSArray *)usersList;

@end
