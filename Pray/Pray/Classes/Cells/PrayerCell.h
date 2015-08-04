//
//  PrayerCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrayerCellDelegate <NSObject>

- (void)likeButtonClicked;
- (void)commentButtonClicked;

@end


@interface PrayerCell : UITableViewCell {
    
    UIImageView *imageView;
    UILabel *textView;
    UILabel *timeAgo;
    UILabel *username;
    UIImageView *userAvatar;
    UILabel *likesCount;
    UILabel *commentsCount;
    UIImageView *commentsIcon;
    UIImageView *likesIcon;
    UIButton *likeButton;
    UIButton *commentButton;
    
    CDPrayer *prayer;
}

@property(nonatomic, assign) id <PrayerCellDelegate> delegate;

- (void)updateWithPrayerObject:(CDPrayer *)prayerObject;

@end
