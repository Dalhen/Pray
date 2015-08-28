//
//  PrayerCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "PrayerCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"


@implementation PrayerCell
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [userAvatar setImage:[UIImage new]];
    [imageView setImage:[UIImage new]];
}

- (void)setupLayout {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 264*sratio)];
    [imageView setBackgroundColor:Colour_255RGB(80, 92, 109)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [self.contentView addSubview:imageView];
    
    blackMask = [[UIView alloc] initWithFrame:imageView.frame];
    [blackMask setBackgroundColor:Colour_BlackAlpha(0.3)];
    [self.contentView addSubview:blackMask];
    
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(12*sratio, 8*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:userAvatar];
    
    username = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 10*sratio, 12*sratio, 250*sratio, 20*sratio)];
    username.font = [FontService systemFont:14*sratio];
    username.textColor = Colour_White;
    username.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:username];
    
    timeAgo = [[UILabel alloc] initWithFrame:CGRectMake(username.left, username.bottom, 250*sratio,12*sratio)];
    timeAgo.font = [FontService systemFont:9*sratio];
    timeAgo.textColor = Colour_White;
    timeAgo.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeAgo];
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake((self.screenWidth-280*sratio)/2, 64*sratio, 280*sratio, 140*sratio)];
    textView.numberOfLines = 8;
    textView.adjustsFontSizeToFitWidth = YES;
    textView.minimumScaleFactor = (14*sratio)/(50*sratio);
    textView.font = [FontService systemFont:50*sratio];
    textView.textColor = Colour_White;
    [textView setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:textView];
    
    likesIcon = [[UIImageView alloc] initWithFrame:CGRectMake(18*sratio, 226*sratio, 22*sratio, 20*sratio)];
    likesIcon.image = [UIImage imageNamed:@"likeIconOFF"];
    [self.contentView addSubview:likesIcon];
    
    likesCount = [[UILabel alloc] initWithFrame:CGRectMake(likesIcon.right + 6*sratio, 226*sratio, 0, 20*sratio)];
    likesCount.font = [FontService systemFont:13*sratio];
    likesCount.textColor = Colour_White;
    [self.contentView addSubview:likesCount];
    
    commentsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 226*sratio, 22*sratio, 21*sratio)];
    commentsIcon.image = [UIImage imageNamed:@"commentsIcon"];
    [self.contentView addSubview:commentsIcon];
    
    commentsCount = [[UILabel alloc] initWithFrame:CGRectMake(commentsIcon.right, 226*sratio, 0, 20*sratio)];
    commentsCount.font = [FontService systemFont:13*sratio];
    commentsCount.textColor = Colour_White;
    [self.contentView addSubview:commentsCount];
    
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:likeButton];
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentButton];
}


- (void)updateWithPrayerObject:(CDPrayer *)prayerObject {
    
    prayer = prayerObject;
    
    if (prayer.imageURL != nil && ![prayer.imageURL isEqualToString:@""]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:prayer.imageURL]];
    }
    
    if (prayer.creator.avatar != nil && ![prayer.creator.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:prayer.creator.avatar]];
    }
    else {
        
    }
    
    [username setText:[NSString stringWithFormat:@"%@ %@", prayer.creator.firstname, prayer.creator.lastname]];
    [timeAgo setText:prayer.timeAgo];
    [textView setText:prayer.prayerText];
    
    [likesIcon setImage:[UIImage imageNamed:(prayer.isLiked.boolValue)? @"likeIconON" : @"likeIconOFF"]];
    
    [likesCount setText:prayer.likesCount];
    [likesCount sizeToFit];
    [likesCount setHeight:20*sratio];
    [likesCount setLeft:likesIcon.right + 6*sratio];
    [commentsIcon setLeft:likesCount.right + 24*sratio];

    [commentsCount setText:prayer.commentsCount];
    [commentsCount sizeToFit];
    [commentsCount setHeight:20*sratio];
    [commentsCount setLeft:commentsIcon.right + 6*sratio];
    
    likeButton.frame = CGRectMake(likesIcon.left - 10*sratio, 216*sratio, 10*sratio + likesIcon.width + 6*sratio + likesCount.width + 10*sratio, 42*sratio);
    commentButton.frame = CGRectMake(commentsIcon.left - 10*sratio, 216*sratio, 10*sratio + commentsIcon.width + 6*sratio + commentsCount.width + 10*sratio, 42*sratio);
}


- (void)likeButtonClicked {
    [likesIcon setImage:[UIImage imageNamed:(prayer.isLiked.boolValue)? @"likeIconOFF" : @"likeIconON"]];
    
    if (prayer.isLiked.boolValue == NO) {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]+1]];
        [SVProgressHUD showSuccessWithStatus:LocString(@"Liked!")];
        [DataAccess add1LikeToPrayer:prayer];
    }
    else {
        [likesCount setText:[NSString stringWithFormat:@"%d",[likesCount.text intValue]-1]];
        [DataAccess remove1LikeToPrayer:prayer];
    }
    
    [delegate likeButtonClickedForCell:self];
}

- (void)commentButtonClicked {
    [delegate commentButtonClickedForCell:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
