//
//  UserCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 30/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCell;

@protocol UserCellDelegate <NSObject>

- (void)followUserForCell:(UserCell *)cell;
- (void)unfollowUserForCell:(UserCell *)cell;
- (void)showUserForCell:(UITableViewCell *)cell;

@end


@interface UserCell : UITableViewCell {
    
    UIImageView *userAvatar;
    UILabel *fullNameLabel;
    UILabel *usernameLabel;
    UIButton *followButton;
}

@property(nonatomic, strong) CDUser *currentUser;
@property(nonatomic, assign) id <UserCellDelegate> delegate;

- (void)updateWithUserObject:(CDUser *)userObject;

@end