//
//  NotificationsCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsCell : UITableViewCell {
    
    UIImageView *userAvatar;
    UILabel *textLabel;
    UILabel *timeAgo;
}

- (void)updateWithNotification:(NSDictionary *)notification;

@end
