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
    [name setTextColor:Colour_White];
    [name setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:name];
}


#pragma mark - Data update
- (void)setDetailsWithData:(NSDictionary *)data {
    
    if ([[data objectForKey:@"avatar"] isEqualToString:@""] || ![data objectForKey:@"avatar"])
        [iconImageView setImage:[UIImage imageNamed:@"emptyProfilePicture"]];
    
    else [iconImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"emptyProfilePicture"]];
    
    if ([data objectForKey:@"first_name"] && [data objectForKey:@"last_name"]) {
        [name setText:[NSString stringWithFormat:@"%@ %@", [data objectForKey:@"first_name"], [[data objectForKey:@"last_name"] substringToIndex:1]]];
    }
    else if ([data objectForKey:@"full_name"]) {
        [name setText:[data objectForKey:@"full_name"]];
    }
    else [name setText:[data objectForKey:@"first_name"]];
}


@end
