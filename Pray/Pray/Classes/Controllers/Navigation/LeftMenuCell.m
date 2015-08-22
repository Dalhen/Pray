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
        
        [self.contentView setBackgroundColor:Colour_PrayDarkBlue];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(32*sratio, 23*sratio, 24*sratio, 24*sratio)];
        [iconView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:iconView];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + 8*sratio, 23*sratio, 160*sratio, 24*sratio)];
        [title setBackgroundColor:Colour_Clear];
        [title setFont:[FontService systemFont:12*sratio]];
        [title setTextColor:Colour_White];
        [self.contentView addSubview:title];
        
        UIImageView *accessoryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallArrow.png"]];
        [accessoryArrow setFrame:CGRectMake(200*sratio, 30*sratio, 5*sratio, 11*sratio)];
        [self.contentView addSubview:accessoryArrow];
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(36*sratio, 69*sratio, self.screenWidth - 36*sratio, 1)];
        [separator setBackgroundColor:Colour_255RGB(83, 84, 90)];
        [self.contentView addSubview:separator];
    }
    
    return self;
}

- (void)setIconsSetWithOffImage:(NSString *)offImageName andOnImage:(NSString *)onImageName {
    iconOFF = offImageName;
    iconON = onImageName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [title setTextColor:selected ? Colour_PrayBlue : Colour_White];
    [iconView setImage:[UIImage imageNamed:selected ? iconON : iconOFF]];
}

@end
