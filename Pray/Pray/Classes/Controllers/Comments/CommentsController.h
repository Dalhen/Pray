//
//  CommentsController.h
//  Pray
//
//  Created by Jason LAPIERRE on 21/08/2015.
//  Copyright (c) 2015 Pray Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    
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
}


@end
