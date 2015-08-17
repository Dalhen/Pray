//
//  LeftMenuCell.m
//  Invisible
//
//  Created by Jason LAPIERRE on 21/08/2013.
//  Copyright (c) 2013 All rights reserved.
//

#import "LeftMenuCell.h"


#define kCellPadding 16

@implementation LeftMenuCell
@synthesize iconView;
@synthesize title;
@synthesize iconON;
@synthesize iconOFF;
@synthesize accessoryButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView setBackgroundColor:Colour_255RGB(51, 58, 68)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 14, 28, 28)];
        [iconView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:iconView];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + kCellPadding, 16, 160, 23)];
        [title setBackgroundColor:Colour_Clear];
        [title setFont:[FontService systemFont:15*sratio]];
        [title setTextColor:Colour_White];
        [self.contentView addSubview:title];
        
        UIImageView *accessoryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallArrow.png"]];
        [accessoryArrow setFrame:CGRectMake(218, 24, 5, 11)];
        [self.contentView addSubview:accessoryArrow];
    }
    
    return self;
}

- (void)setIconsSetWithOffImage:(NSString *)offImageName andOnImage:(NSString *)onImageName {
    iconOFF = offImageName;
    iconON = onImageName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [title setTextColor:selected ? Colour_White : Colour_PrayBlue];
    [iconView setImage:[UIImage imageNamed:selected ? iconON : iconOFF]];
}

@end
