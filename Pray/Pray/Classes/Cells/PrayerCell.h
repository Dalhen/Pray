//
//  PrayerCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "TTTAttributedLabel.h"

#define prayerCellHeight 320*sratio

@class PrayerCell;

@protocol PrayerCellDelegate <NSObject>

- (void)likeButtonClickedForCell:(PrayerCell *)cell;
- (void)commentButtonClickedForCell:(PrayerCell *)cell;
- (void)showUserForCell:(UITableViewCell *)cell;
- (void)showUserForUserObject:(CDUser *)user;

@optional

- (void)sharePrayerImage:(UIImage *)image;

@end


@interface PrayerCell : SWTableViewCell <TTTAttributedLabelDelegate> {
    
    UIImageView *imageView;
    TTTAttributedLabel *textView;
    UILabel *timeAgo;
    UILabel *username;
    UIImageView *userAvatar;
    UILabel *likesCount;
    UILabel *commentsCount;
    UIImageView *commentsIcon;
    UIImageView *likesIcon;
    UIButton *likeButton;
    UIButton *commentButton;
    UIButton *sharePrayerButton;
    UIView *blackMask;
    UIImageView *religionType;
}

@property(nonatomic, strong) CDPrayer *prayer;
@property(nonatomic, assign) id <PrayerCellDelegate, SWTableViewCellDelegate> delegate;

- (void)updateWithPrayerObject:(CDPrayer *)prayerObject;

@end
