//
//  LeftMenuCell.h
//  Invisible
//
//  Created by Jason LAPIERRE on 21/08/2013.
//  Copyright (c) 2013 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuCell : UITableViewCell {
    
}

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) NSString *iconON;
@property(nonatomic, strong) NSString *iconOFF;
@property(nonatomic, strong) UILabel  *title;
@property(nonatomic, strong) UIButton *accessoryButton;

- (void)setIconsSetWithOffImage:(NSString *)offImageName andOnImage:(NSString *)onImageName;

@end
