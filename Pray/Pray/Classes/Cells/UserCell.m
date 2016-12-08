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
@synthesize currentUser;
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
    self.backgroundColor = Colour_White;
    
    userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(16*sratio, 16*sratio, 38*sratio, 38*sratio)];
    [userAvatar setRoundedToDiameter:38*sratio];
    [userAvatar setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:userAvatar];
    
    UIButton *userAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [userAction setFrame:userAvatar.frame];
    [userAction addTarget:self action:@selector(showUser) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:userAction];
    
    fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 10*sratio, 18*sratio, 164*sratio, 18*sratio)];
    fullNameLabel.font = [FontService systemFont:15*sratio];
    fullNameLabel.textColor = Colour_255RGB(82, 82, 82);
    fullNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:fullNameLabel];
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.right + 8*sratio, fullNameLabel.bottom - 2*sratio, 164*sratio, 16*sratio)];
    usernameLabel.font = [FontService systemFont:10*sratio];
    usernameLabel.textColor = Colour_255RGB(82, 82, 82);
    usernameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:usernameLabel];
    
    followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [followButton setFrame:CGRectMake(230*sratio, 20*sratio, 74*sratio, 32*sratio)];
    [followButton setBackgroundColor:Colour_255RGB(82, 82, 82)];
    [followButton.titleLabel setFont:[FontService systemFont:13*sratio]];
    [followButton setTitleColor:Colour_White forState:UIControlStateNormal];
    [followButton.layer setCornerRadius:5.0f];
    [followButton addTarget:self action:@selector(followClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:followButton];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 73*sratio, self.screenWidth, 1)];
    [separator setBackgroundColor:Colour_255RGB(232, 232, 232)];
    [self.contentView addSubview:separator];
}


#pragma mark - Data
- (void)updateWithUserObject:(CDUser *)userObject {
    
    currentUser = userObject;
    
    if (userObject.avatar != nil && ![userObject.avatar isEqualToString:@""]) {
        [userAvatar sd_setImageWithURL:[NSURL URLWithString:userObject.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    else {
        [userAvatar setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    [fullNameLabel setText:userObject.firstname];
    [usernameLabel setText:[NSString stringWithFormat:@"@%@", userObject.username]];
    if ([userObject.isFollowed boolValue]==YES) {
        [followButton setBackgroundColor:Colour_255RGB(232, 232, 232)];
        [followButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
    }
    else {
        [followButton setBackgroundColor:Colour_255RGB(82, 82, 82)];
        [followButton setTitle:LocString(@"Follow") forState:UIControlStateNormal];
    }
    
    if ([userObject.uniqueId isEqualToNumber:[UserService getUserIDNumber]]) {
        [followButton setHidden:YES];
    }
    else {
        [followButton setHidden:NO];
    }
}

#pragma mark - Follow delegate
- (void)followClicked:(id)sender {
    
    //Follow user
    if ([currentUser.isFollowed boolValue]==YES) {
        [followButton setBackgroundColor:Colour_255RGB(232, 232, 232)];
        [followButton setTitle:LocString(@"Follow") forState:UIControlStateNormal];
        [delegate unfollowUserForCell:self];
    }
    
    //UnFollow user
    else {
        [followButton setBackgroundColor:Colour_255RGB(82, 82, 82)];
        [followButton setTitle:LocString(@"Following") forState:UIControlStateNormal];
        [delegate followUserForCell:self];
    }
}

#pragma mark - Display user profile
- (void)showUser {
    [delegate showUserForCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
