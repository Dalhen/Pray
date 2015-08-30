//
//  UserCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 30/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+WebCache.h"

@implementation UserCell



#pragma mark - Init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupLayout];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [userAvatar setImage:[UIImage new]];
}


#pragma mark - Layout
- (void)setupLayout {
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(16*sratio, 16*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:userAvatar];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 8*sratio, 6*sratio, 214*sratio, 58*sratio)];
    usernameLabel.font = [FontService systemFont:13*sratio];
    usernameLabel.textColor = Colour_White;
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:usernameLabel];
    
    followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followButton setFrame:CGRectMake(272*sratio, 20*sratio, 88*sratio, 36*sratio)];
    [followButton setBackgroundColor:Colour_PrayDarkBlue];
    [followButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [followButton setHidden:YES];
    [self addSubview:followButton];
}


#pragma mark - Data
- (void)loadWithUserData:(NSDictionary *)userData {
    [userAvatar sd_setImageWithURL:[NSURL URLWithString:[userData objectForKey:@"avatar"]]];
    [usernameLabel setText:[userData objectForKey:@"first_name"]];
    
    [followButton setBackgroundColor:([[userData objectForKey:@"following"] boolValue]==YES) ? Colour_PrayDarkBlue : Colour_PrayBlue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
