//
//  CommentsController.h
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"

@interface CommentsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CommentCellDelegate, UIAlertViewDelegate> {
    
    CDPrayer *currentPrayer;
    
    NSMutableArray *comments;
    UITableView *commentsTable;
    UIRefreshControl *refreshControl;
    UISwipeGestureRecognizer *swipeRecognizer;
    CGSize keyboardSize;
    
    BOOL refreshing;
    NSInteger currentPage;
    NSInteger maxCommentsPerPage;
    NSInteger maxPagesCount;
    
    UIView *addCommentView;
    UITextView *commentTextView;
    UIButton *sendCommentButton;
    UIButton *cancelCommentButton;
    CGFloat previousCommentHeight;
    
    NSMutableArray *sendingStack;
    
    BOOL displayCommentsOnly;
    
    //Tagging
    BOOL removedSpaceCharacter;
    BOOL removedArobaseCharacter;
    BOOL addedSpaceCharacter;
    BOOL addedArobaseCharacter;
    BOOL isTagging;
    
    BOOL searchingForMentions;
    NSArray *mentions;
    NSMutableArray *mentionsAdded;
    NSInteger mentionIndex;
    NSInteger mentionTotal;
    NSString *currentMention;
    
    //PrayerView
    UIImageView *likesIcon;
    UILabel *likesCount;
    UIButton *likeListButton;
    UILabel *commentsCount;
}

- (id)initWithPrayer:(CDPrayer *)prayer andDisplayCommentsOnly:(BOOL)display;


@end
