//
//  CommentCell.h
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

#define commentTextWidth 252*sratio
#define commentTextMinimumHeight 40*sratio

@class CommentCell;

@protocol CommentCellDelegate <NSObject>

- (void)showUserForCell:(CommentCell *)cell;
- (void)showUserForUserObject:(CDUser *)user;
- (float)heightToFitCommentText:(NSString *)text;

@end


@interface CommentCell : UITableViewCell <TTTAttributedLabelDelegate> {
    
    UIImageView *iconImageView;
    UILabel *usernameLabel;
    TTTAttributedLabel *descriptionText;
    UILabel *timeAgoLabel;
    CDComment *commentObject;
}

@property(nonatomic, weak) id <CommentCellDelegate> delegate;

- (void)updateWithComment:(CDComment *)aComment;


@end
