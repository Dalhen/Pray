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
@synthesize delegate;


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
    
    fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 8*sratio, 6*sratio, 164*sratio, 58*sratio)];
    fullNameLabel.font = [FontService systemFont:13*sratio];
    fullNameLabel.textColor = Colour_White;
    fullNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:fullNameLabel];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 8*sratio, fullNameLabel.bottom, 164*sratio, 16*sratio)];
    usernameLabel.font = [FontService systemFont:8.5*sratio];
    usernameLabel.textColor = Colour_White;
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:usernameLabel];
    
    followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followButton setFrame:CGRectMake(230*sratio, 18*sratio, 74*sratio, 32*sratio)];
    [followButton setBackgroundColor:Colour_PrayDarkBlue];
    [followButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [followButton addTarget:self action:@selector(followClicked:) forControlEvents:UIControlEventTouchUpInside];
    [followButton setHidden:YES];
    [self addSubview:followButton];
}


#pragma mark - Data
- (void)updateWithUserObject:(CDUser *)userObject {
    
    if (userObject.avatar != nil && ![userObject.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:userObject.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    [fullNameLabel setText:userObject.firstname];
    [usernameLabel setText:[NSString stringWithFormat:@"@%@", userObject.username]];
    [followButton setBackgroundColor:([userObject.isFollowed boolValue]==YES) ? Colour_PrayDarkBlue : Colour_PrayBlue];
}


#pragma mark - Follow delegate
- (void)followClicked:(id)sender {
    //Follow user
    if (followButton.backgroundColor == Colour_PrayDarkBlue) {
        [followButton setBackgroundColor:Colour_PrayBlue];
        [delegate followUserForCell:self];
    }
    
    //UnFollow user
    else {
        [followButton setBackgroundColor:Colour_PrayDarkBlue];
        [delegate unfollowUserForCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
