//
//  MentionCell.m
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import "MentionCell.h"
#import "UIImageView+Rounded.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation MentionCell

#pragma mark - Setup
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [iconImageView setImage:[UIImage new]];
}

#pragma mark - Layout
- (void)setupLayout {
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, 7*sratio, 32*sratio, 32*sratio)];
    [iconImageView setRoundedToDiameter:32*sratio];
    [iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:iconImageView];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right + kPadding, 13*sratio, 165*sratio, 20*sratio)];
    [name setBackgroundColor:Colour_Clear];
    [name setFont:[FontService systemFont:14*sratio]];
    [name setTextColor:Colour_PrayBlue];
    [name setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:name];
}

#pragma mark - Data update
- (void)setDetailsWithUserObject:(CDUser *)userObject {
    
    if (userObject.avatar != nil && ![userObject.avatar isEqualToString:@""]) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:userObject.avatar] placeholderImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    else {
        [iconImageView setImage:[UIImage imageNamed:@"emptyProfile"]];
    }
    
    [name setText:[NSString stringWithFormat:@"%@ %@ (@%@)", userObject.firstname, userObject.lastname, userObject.username]];
}


@end
