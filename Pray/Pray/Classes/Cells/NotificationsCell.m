//
//  NotificationsCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 28/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "NotificationsCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"

@implementation NotificationsCell


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
}

- (void)setupLayout {
    self.backgroundColor = Colour_255RGB(59, 63, 75);
    
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(12*sratio, 14*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:userAvatar];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 8*sratio, 0, 210*sratio, 66*sratio)];
    textLabel.font = [FontService systemFont:13*sratio];
    textLabel.textColor = Colour_White;
    [textLabel setNumberOfLines:3];
    textLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:textLabel];
    
    timeAgo = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 44*sratio, 0, 42*sratio, 66*sratio)];
    timeAgo.font = [FontService systemFont:8*sratio];
    timeAgo.textColor = Colour_White;
    timeAgo.textAlignment = NSTextAlignmentCenter;
    timeAgo.numberOfLines = 2;
    [self.contentView addSubview:timeAgo];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 65*sratio, self.screenWidth, 1)];
    [separator setBackgroundColor:Colour_255RGB(38, 41, 50)];
    [self.contentView addSubview:separator];
}

- (void)updateWithNotification:(NSDictionary *)notification {
    
    NSDictionary *userInfo = [[notification objectForKey:@"var_one"] objectForKey:@"data"];
    
    if ([userInfo objectForKey:@"avatar"] != [NSNull null]) {
        if (![[userInfo objectForKey:@"avatar"] isEqualToString:@""]) {
            [userAvatar sd_setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
        }
        else {
            [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
        }
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    [textLabel setText:[notification objectForKey:@"body"]];
    [timeAgo setText:[notification objectForKey:@"time_ago"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
