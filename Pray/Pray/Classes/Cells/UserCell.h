//
//  UserCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 30/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell {
    
    UIImageView *userAvatar;
    UILabel *usernameLabel;
    UIButton *followButton;
}

- (void)loadWithUserData:(NSDictionary *)userData;

@end