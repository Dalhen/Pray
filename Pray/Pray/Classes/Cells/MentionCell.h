//
//  MentionCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 04/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentionCell : UITableViewCell {
    
    UIImageView *iconImageView;
    UILabel *name;
}

- (void)setDetailsWithData:(NSDictionary *)data;

@end
